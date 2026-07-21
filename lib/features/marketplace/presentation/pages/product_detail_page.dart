import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/i18n/failure_messages.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/utils/safe_area_utils.dart';
import '../../../../core/utils/money_format.dart';
import '../../../../core/utils/product_share_helper.dart';
import '../../../../core/utils/promo_analytics_tracker.dart';
import '../../../../core/utils/product_pricing.dart';
import '../../../../core/utils/rupiah_input_formatter.dart';
import '../../../negotiation/domain/models/negotiation_offer_draft.dart';
import '../../../negotiation/presentation/bloc/negotiation_cubit.dart';
import '../../../negotiation/presentation/widgets/negotiation_product_preview.dart';
import '../../../negotiation/presentation/widgets/negotiation_seller_chip.dart';
import '../../../negotiation/presentation/widgets/negotiation_stock_banner.dart';
import '../../../negotiation/presentation/utils/negotiation_quantity_rules.dart';
import '../../../negotiation/presentation/utils/product_seller_chat.dart';
import '../../../../core/readiness/readiness_gate.dart';
import '../../../../injection_container.dart';
import '../bloc/marketplace_cubit.dart';
import '../../domain/entities/product_entity.dart';
import '../widgets/product_card.dart';
import '../../../../shared/widgets/bisa_media_skeleton.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../widgets/horizontal_product_section.dart';
import '../widgets/product_specs_sheet.dart';
import '../../../../shared/widgets/product_video_player.dart';
import '../../../../shared/widgets/auth_sheet.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../../../core/utils/media_url_utils.dart';
import '../../../commerce/presentation/bloc/commerce_cubit.dart';
import '../../../orders/presentation/bloc/order_cubit.dart';
import '../bloc/compare_cubit.dart';
import '../bloc/product_qa_cubit.dart';
import '../widgets/product_qa_section.dart';
import '../widgets/product_recommendations_section.dart';
import '../widgets/product_certificate_section.dart';
import '../../../ai/presentation/widgets/predict_quality_sheet.dart';
import '../../../commerce/presentation/widgets/product_like_button.dart';
import '../../../follow/presentation/widgets/follow_button.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../booking/presentation/widgets/booking_create_sheet.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  static const int _specPreviewLimit = 5;

  ProductEntity? _product;
  File? _imageFile;
  final _messageController = TextEditingController();
  bool _isDescriptionExpanded = false;
  late final ProductQaCubit _qaCubit = sl<ProductQaCubit>();
  bool _isSampleOrdering = false;
  bool _autoNegotiateOpened = false;

  @override
  void dispose() {
    _qaCubit.close();
    _messageController.dispose();
    super.dispose();
  }

  void _maybeOpenNegotiateFromQuery() {
    if (_autoNegotiateOpened || _product == null) return;
    final negotiate = GoRouterState.of(
      context,
    ).uri.queryParameters['negotiate'];
    if (negotiate != '1') return;
    _autoNegotiateOpened = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _showNegotiationSheet();
    });
  }

  Future<void> _orderSample(ProductEntity p) async {
    if (!mounted) return;
    final ready = await ReadinessGate.ensureBuyerReady(context);
    if (!ready || !mounted) return;

    final qty = p.sampleMaxQty >= 1 ? 1.0 : p.sampleMaxQty;
    final unitPrice = p.samplePricePerUnit ?? p.pricePerUnit;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('product.sample_order_title'.tr()),
        content: Text(
          'product.sample_order_confirm'.tr(
            namedArgs: {
              'qty': '$qty',
              'unit': p.unit,
              'price': formatMoneyDisplay(unitPrice),
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('product.sample_order_cta'.tr()),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isSampleOrdering = true);
    final result = await context.read<OrderCubit>().createDirectOrder(
      items: [
        {'productId': p.id, 'quantity': qty},
      ],
      orderType: 'SAMPLE',
    );
    if (!mounted) return;
    setState(() => _isSampleOrdering = false);

    if (!result.isSuccess) {
      if (result.isBuyerReadiness) {
        await ReadinessGate.ensureBuyerReady(context);
      } else {
        showFailureSnackBarFromMessage(
          context,
          result.errorMessage ?? 'product.sample_order_failed',
        );
      }
      return;
    }

    final orderId = result.orders.firstOrNull?['orderId']?.toString();
    if (orderId != null && mounted) {
      context.push('/order/$orderId');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<MarketplaceCubit>()..getProductById(widget.productId),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocConsumer<MarketplaceCubit, MarketplaceState>(
          listener: (context, state) {
            state.maybeWhen(
              loaded: (products, hasReachedMax) {
                if (products.isNotEmpty) {
                  final p = products.first;
                  setState(() => _product = p);
                  if (p.isPromotionActive) {
                    PromoAnalyticsTracker.recordImpression(p.id);
                  }
                  _maybeOpenNegotiateFromQuery();
                }
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => _buildLoadingSkeleton(),
              error: (message) => Center(child: Text(message.localizedFailure)),
              loaded: (products, hasReachedMax) =>
                  _product == null ? _buildLoadingSkeleton() : _buildContent(),
              orElse: () => _buildLoadingSkeleton(),
            );
          },
        ),
        bottomNavigationBar: _product == null ? null : _buildBottomAction(),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: BisaMediaSkeleton(width: double.infinity, height: 350.h),
        ),
        SliverPadding(
          padding: AppSpacing.cardPadding,
          sliver: SliverToBoxAdapter(
            child: ShimmerLoading(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Bone.multiText(lines: 2),
                  SizedBox(height: AppSpacing.md),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Bone.circle(size: 44.w),
                      SizedBox(width: AppSpacing.md12),
                      Expanded(child: Bone.multiText(lines: 2)),
                    ],
                  ),
                  SizedBox(height: AppSpacing.lg),
                  Bone(width: double.infinity, height: 56.h),
                  SizedBox(height: AppSpacing.md12),
                  Bone(width: double.infinity, height: 120.h),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _sellerDisplayName(ProductEntity p) {
    final company = p.seller.companyName?.trim();
    if (company != null && company.isNotEmpty) return company;
    final name = p.seller.name.trim();
    return name.isNotEmpty ? name : 'marketplace.store_default_name'.tr();
  }

  Future<void> _openNegotiationPreview(NegotiationOfferDraft draft) async {
    if (!await ReadinessGate.ensureBuyerReady(context)) return;
    if (!mounted) return;
    // Route preview tetap tersedia (deep link / fallback), alur utama sudah in-sheet.
    final edited = await context.push<NegotiationOfferDraft>(
      '/negotiation-offer-preview',
      extra: draft,
    );
    if (edited != null && mounted) {
      _showNegotiationSheet(prefill: edited);
    }
  }

  void _showNegotiationSheet({NegotiationOfferDraft? prefill}) {
    final p = _product!;
    final quantityController = TextEditingController(
      text: prefill != null
          ? prefill.quantity.toStringAsFixed(0)
          : p.minOrder.toString(),
    );
    final priceController = TextEditingController(
      text: prefill != null
          ? formatRupiahInput(prefill.offerPricePerUnit)
          : formatRupiahInput(p.pricePerUnit),
    );
    if (prefill != null) {
      _messageController.text = prefill.message ?? '';
      if (prefill.localImagePath != null) {
        _imageFile = File(prefill.localImagePath!);
      }
    } else {
      _messageController.clear();
      _imageFile = null;
    }
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (sheetContext) {
        final maxHeight = MediaQuery.sizeOf(sheetContext).height * 0.92;
        var confirmStep = false;
        NegotiationOfferDraft? draft;

        return Padding(
          padding: sheetBottomPadding(sheetContext),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Container(
              padding: EdgeInsets.all(AppSpacing.comfortable),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.xxlPx.r),
                ),
              ),
              child: BlocConsumer<NegotiationCubit, NegotiationState>(
                listener: (context, state) {
                  state.maybeWhen(
                    detailLoaded: (negotiation, _, __) {
                      Navigator.pop(sheetContext);
                      context.push('/negotiation/${negotiation.id}');
                    },
                    error: (message) => showErrorSnackBar(context, message),
                    orElse: () {},
                  );
                },
                builder: (context, negoState) {
                  final sending = negoState.maybeWhen(
                    loading: () => true,
                    orElse: () => false,
                  );
                  return StatefulBuilder(
                    builder: (context, setSheetState) {
                      final requestedQty = double.tryParse(
                        quantityController.text,
                      );
                      final outOfStock = NegotiationQuantityRules.isOutOfStock(
                        p.stock,
                      );

                      if (confirmStep && draft != null) {
                        final d = draft!;
                        final savings = d.totalSavings;
                        return SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'negotiation.preview_title'.tr(),
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: sending
                                        ? null
                                        : () => Navigator.pop(sheetContext),
                                  ),
                                ],
                              ),
                              SizedBox(height: AppSpacing.md12),
                              NegotiationSellerChip(
                                displayName: d.sellerDisplayName,
                                avatarUrl: d.sellerAvatarUrl,
                                isVerified: d.sellerIsVerified,
                              ),
                              SizedBox(height: AppSpacing.sm10),
                              NegotiationProductPreview(
                                name: d.productName,
                                thumbnailUrl: d.productThumbnailUrl,
                                priceLabel: formatMoneyDisplay(
                                  d.catalogPricePerUnit,
                                ),
                                subtitle: 'marketplace.catalog_price'.tr(),
                              ),
                              SizedBox(height: AppSpacing.md12),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(AppSpacing.md12),
                                decoration: BoxDecoration(
                                  color: AppColors.grey50,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.lg,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    _sheetSummaryRow(
                                      'marketplace.qty_label'.tr(
                                        namedArgs: {'unit': d.unit},
                                      ),
                                      '${ProductPricingInfo.formatQty(d.quantity)} ${d.unit}',
                                    ),
                                    _sheetSummaryRow(
                                      'marketplace.offer_price_label'.tr(
                                        namedArgs: {'unit': d.unit},
                                      ),
                                      formatMoneyDisplay(d.offerPricePerUnit),
                                    ),
                                    _sheetSummaryRow(
                                      'negotiation.preview_total_offer'.tr(),
                                      formatMoneyDisplay(d.offerSubtotal),
                                      emphasized: true,
                                    ),
                                    if (d.hasDiscount)
                                      _sheetSummaryRow(
                                        'negotiation.preview_savings_total'.tr(
                                          namedArgs: {
                                            'amount': formatMoneyDisplay(
                                              savings,
                                            ),
                                            'percent': d.discountTotalPercent
                                                .abs()
                                                .toStringAsFixed(1),
                                          },
                                        ),
                                        '',
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(height: AppSpacing.sectionGapLarge),
                              CustomButton(
                                text: 'negotiation.preview_edit_offer'.tr(),
                                height: AppSpacing.buttonHeightSm,
                                isOutlined: true,
                                onPressed: sending
                                    ? null
                                    : () => setSheetState(
                                        () => confirmStep = false,
                                      ),
                              ),
                              SizedBox(height: AppSpacing.sm10),
                              CustomButton(
                                text: 'negotiation.preview_send_offer'.tr(),
                                useGradient: true,
                                height: 48.h,
                                isLoading: sending,
                                onPressed: sending
                                    ? null
                                    : () async {
                                        if (!await ReadinessGate.ensureBuyerReady(
                                          context,
                                        )) {
                                          return;
                                        }
                                        if (!context.mounted) return;
                                        context
                                            .read<NegotiationCubit>()
                                            .createOffer(
                                              productId: d.productId,
                                              quantity: d.quantity,
                                              pricePerUnit: d.offerPricePerUnit,
                                              message: d.message,
                                              localImagePath: d.localImagePath,
                                            );
                                      },
                              ),
                              SizedBox(height: AppSpacing.md),
                            ],
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'marketplace.negotiate_title'.tr(),
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () =>
                                        Navigator.pop(sheetContext),
                                  ),
                                ],
                              ),
                              SizedBox(height: AppSpacing.md12),
                              NegotiationSellerChip(
                                displayName:
                                    prefill?.sellerDisplayName ??
                                    _sellerDisplayName(p),
                                avatarUrl:
                                    prefill?.sellerAvatarUrl ??
                                    p.seller.avatarUrl,
                                isVerified:
                                    prefill?.sellerIsVerified ??
                                    p.seller.isVerified,
                              ),
                              SizedBox(height: AppSpacing.sm10),
                              NegotiationProductPreview(
                                name: p.name,
                                thumbnailUrl: p.thumbnailUrl,
                                priceLabel: formatMoneyDisplay(p.pricePerUnit),
                                subtitle: 'marketplace.catalog_price'.tr(),
                              ),
                              SizedBox(height: AppSpacing.sm10),
                              NegotiationStockBanner(
                                stock: p.stock,
                                minOrder: p.minOrder,
                                unit: p.unit,
                                requestedQty: requestedQty,
                              ),
                              SizedBox(height: AppSpacing.md12),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(AppSpacing.md12),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.06,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.lg,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      LucideIcons.messageCircle,
                                      size: 18.sp,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: AppSpacing.sm10),
                                    Expanded(
                                      child: Text(
                                        'marketplace.negotiate_hint'.tr(),
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          height: 1.4,
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: AppSpacing.lg),
                              Text(
                                'marketplace.step_qty'.tr(),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: AppSpacing.sm),
                              CustomTextField(
                                label: 'marketplace.qty_label'.tr(
                                  namedArgs: {'unit': p.unit},
                                ),
                                hint: 'marketplace.qty_hint'.tr(
                                  namedArgs: {
                                    'min': ProductPricingInfo.formatQty(
                                      p.minOrder,
                                    ),
                                    'max': ProductPricingInfo.formatQty(
                                      p.stock,
                                    ),
                                  },
                                ),
                                controller: quantityController,
                                keyboardType: TextInputType.number,
                                prefixIcon: LucideIcons.package,
                                onChanged: (_) => setSheetState(() {}),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'marketplace.required_field'.tr();
                                  }
                                  return NegotiationQuantityRules.validate(
                                    quantity: double.tryParse(value),
                                    minOrder: p.minOrder,
                                    stock: p.stock,
                                    unit: p.unit,
                                  );
                                },
                              ),
                              SizedBox(height: AppSpacing.lg),
                              Text(
                                'marketplace.step_offer_price'.tr(),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'marketplace.catalog_price_line'.tr(
                                  namedArgs: {
                                    'price': formatMoneyDisplay(p.pricePerUnit),
                                    'unit': p.unit,
                                  },
                                ),
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: AppSpacing.sm),
                              CustomTextField(
                                label: 'marketplace.offer_price_label'.tr(
                                  namedArgs: {'unit': p.unit},
                                ),
                                hint: formatRupiahInput(p.pricePerUnit),
                                controller: priceController,
                                keyboardType: TextInputType.number,
                                prefixIcon: LucideIcons.banknote,
                                inputFormatters: [RupiahInputFormatter()],
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'marketplace.required_field'.tr();
                                  }
                                  if (parseRupiahInput(value) == null) {
                                    return 'marketplace.invalid_amount'.tr();
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: AppSpacing.lg),
                              Text(
                                'marketplace.step_seller_note'.tr(),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: AppSpacing.sm),
                              CustomTextField(
                                label: 'marketplace.optional_message_label'
                                    .tr(),
                                hint: 'marketplace.optional_message_hint'.tr(),
                                controller: _messageController,
                                maxLines: 3,
                                prefixIcon: LucideIcons.messageSquare,
                              ),
                              SizedBox(height: AppSpacing.md),
                              Text(
                                'marketplace.support_photo_optional'.tr(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(height: AppSpacing.md12),
                              InkWell(
                                onTap: _pickImage,
                                child: Container(
                                  height: 100.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.grey50,
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.xl,
                                    ),
                                    border: Border.all(
                                      color: AppColors.grey200,
                                      width: 1,
                                    ),
                                  ),
                                  child: _imageFile != null
                                      ? Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    AppRadius.xl,
                                                  ),
                                              child: Image.file(
                                                _imageFile!,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                              top: AppSpacing.sm,
                                              right: AppSpacing.sm,
                                              child: GestureDetector(
                                                onTap: () => setState(
                                                  () => _imageFile = null,
                                                ),
                                                child: CircleAvatar(
                                                  radius: AppRadius.lg,
                                                  backgroundColor: AppColors
                                                      .black
                                                      .withValues(alpha: 0.5),
                                                  child: Icon(
                                                    Icons.close,
                                                    size: 14.sp,
                                                    color: AppColors.surface,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              LucideIcons.imagePlus,
                                              color: AppColors.grey400,
                                              size: 32.sp,
                                            ),
                                            SizedBox(height: AppSpacing.sm),
                                            Text(
                                              'marketplace.tap_add_image'.tr(),
                                              style: TextStyle(
                                                color: AppColors.textHint,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                              SizedBox(height: AppSpacing.sectionGapLarge),
                              CustomButton(
                                text: outOfStock
                                    ? 'marketplace.out_of_stock'.tr()
                                    : 'marketplace.review_and_send'.tr(),
                                useGradient: true,
                                onPressed: outOfStock
                                    ? null
                                    : () {
                                        if (!formKey.currentState!.validate())
                                          return;
                                        final qty = double.tryParse(
                                          quantityController.text,
                                        );
                                        final price = parseRupiahInput(
                                          priceController.text,
                                        );
                                        if (qty == null || price == null)
                                          return;
                                        final qtyError =
                                            NegotiationQuantityRules.validate(
                                              quantity: qty,
                                              minOrder: p.minOrder,
                                              stock: p.stock,
                                              unit: p.unit,
                                            );
                                        if (qtyError != null) return;

                                        draft =
                                            NegotiationOfferDraft.fromProduct(
                                              p,
                                              quantity: qty,
                                              offerPricePerUnit: price,
                                              message:
                                                  _messageController.text
                                                      .trim()
                                                      .isEmpty
                                                  ? null
                                                  : _messageController.text
                                                        .trim(),
                                              localImagePath: _imageFile?.path,
                                            );
                                        setSheetState(() => confirmStep = true);
                                      },
                              ),
                              SizedBox(height: AppSpacing.sm),
                              TextButton(
                                onPressed: outOfStock
                                    ? null
                                    : () {
                                        if (!formKey.currentState!.validate())
                                          return;
                                        final qty = double.tryParse(
                                          quantityController.text,
                                        );
                                        final price = parseRupiahInput(
                                          priceController.text,
                                        );
                                        if (qty == null || price == null)
                                          return;
                                        final d =
                                            NegotiationOfferDraft.fromProduct(
                                              p,
                                              quantity: qty,
                                              offerPricePerUnit: price,
                                              message:
                                                  _messageController.text
                                                      .trim()
                                                      .isEmpty
                                                  ? null
                                                  : _messageController.text
                                                        .trim(),
                                              localImagePath: _imageFile?.path,
                                            );
                                        Navigator.pop(sheetContext);
                                        _openNegotiationPreview(d);
                                      },
                                child: Text(
                                  'marketplace.open_full_preview'.tr(),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              SizedBox(height: AppSpacing.md),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sheetSummaryRow(
    String label,
    String value, {
    bool emphasized = false,
  }) {
    if (value.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(bottom: AppSpacing.sm),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.success,
          ),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: emphasized ? 14.sp : 12.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  int _currentImageIndex = 0;

  Widget _buildContent() {
    final p = _product!;
    final List<String> images = p.images != null && p.images!.isNotEmpty
        ? p.images!.map((e) => e.url).toList()
        : [p.thumbnailUrl ?? ''];
    final hasVideo = p.videoUrl != null && p.videoUrl!.isNotEmpty;
    final galleryCount = images.length + (hasVideo ? 1 : 0);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          expandedHeight: 350.h,
          pinned: true,
          elevation: 0,
          backgroundColor: AppColors.surface,
          leading: Padding(
            padding: EdgeInsets.all(AppSpacing.sm),
            child: CircleAvatar(
              backgroundColor: AppColors.surface,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textPrimary,
                  size: 18.sp,
                ),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/');
                  }
                },
              ),
            ),
          ),
          actions: [
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                final currentUser = authState.maybeWhen(
                  authenticated: (user) => user,
                  orElse: () => null,
                );
                final isOwner = currentUser?.id == _product?.seller.id;

                if (isOwner) {
                  return Padding(
                    padding: EdgeInsets.all(AppSpacing.sm),
                    child: CircleAvatar(
                      backgroundColor: AppColors.surface,
                      child: IconButton(
                        icon: Icon(
                          LucideIcons.settings,
                          color: AppColors.info,
                          size: 18.sp,
                        ),
                        onPressed: () =>
                            context.push('/product-manage/${_product!.id}'),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.sm),
              child: CircleAvatar(
                backgroundColor: AppColors.surface,
                child: IconButton(
                  icon: Icon(
                    LucideIcons.search,
                    color: AppColors.textPrimary,
                    size: 18.sp,
                  ),
                  onPressed: () => context.go('/'),
                ),
              ),
            ),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                final isLoggedIn = authState.maybeWhen(
                  authenticated: (_) => true,
                  orElse: () => false,
                );
                if (!isLoggedIn) return const SizedBox.shrink();

                return BlocBuilder<CompareCubit, CompareState>(
                  builder: (context, compareState) {
                    final inCompare = compareState.contains(_product!.id);
                    return Padding(
                      padding: EdgeInsets.all(AppSpacing.sm),
                      child: CircleAvatar(
                        backgroundColor: inCompare
                            ? AppColors.primaryLight
                            : AppColors.surface,
                        child: IconButton(
                          icon: Icon(
                            LucideIcons.columns3,
                            color: inCompare
                                ? AppColors.primary
                                : AppColors.textPrimary,
                            size: 18.sp,
                          ),
                          onPressed: () {
                            final cubit = context.read<CompareCubit>();
                            final wasSelected = cubit.state.contains(
                              _product!.id,
                            );
                            final err = cubit.toggle(_product!);
                            if (!context.mounted) return;
                            if (err != null) {
                              showErrorSnackBar(context, err.tr());
                              return;
                            }
                            if (!wasSelected) {
                              context.push('/compare-products');
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.sm),
              child: ProductLikeButton(
                productId: _product!.id,
                size: 18,
                backgroundColor: AppColors.surface,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.sm),
              child: CircleAvatar(
                backgroundColor: AppColors.surface,
                child: IconButton(
                  icon: Icon(
                    LucideIcons.share2,
                    color: AppColors.textPrimary,
                    size: 18.sp,
                  ),
                  onPressed: () => ProductShareHelper.shareProduct(_product!),
                ),
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                PageView.builder(
                  itemCount: galleryCount,
                  onPageChanged: (index) =>
                      setState(() => _currentImageIndex = index),
                  itemBuilder: (context, index) {
                    if (hasVideo && index == 0) {
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          ProductVideoPlayer(
                            videoUrl: p.videoUrl!,
                            height: 350.h,
                          ),
                          Positioned(
                            top: AppSpacing.md12,
                            right: AppSpacing.md12,
                            child: Material(
                              color: AppColors.black.withValues(alpha: 0.55),
                              borderRadius: BorderRadius.circular(
                                AppRadius.button,
                              ),
                              child: InkWell(
                                onTap: () => ProductVideoPlayer.openFullscreen(
                                  context,
                                  p.videoUrl!,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.button,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppSpacing.sm10,
                                    vertical: 6.h,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        LucideIcons.maximize2,
                                        color: AppColors.surface,
                                        size: 14.sp,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        'marketplace.video_fullscreen'.tr(),
                                        style: TextStyle(
                                          color: AppColors.surface,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    final imageIndex = hasVideo ? index - 1 : index;
                    return BisaNetworkImage(
                      imageUrl: images[imageIndex],
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          Container(color: AppColors.grey100),
                    );
                  },
                ),
                // Image Indicator
                if (galleryCount > 1)
                  Positioned(
                    bottom: AppSpacing.lg,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(galleryCount, (entry) {
                        return Container(
                          width: AppSpacing.sm,
                          height: AppSpacing.sm,
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentImageIndex == entry
                                ? AppColors.primary
                                : AppColors.white.withValues(alpha: 0.5),
                          ),
                        );
                      }),
                    ),
                  ),
                // Shadow overlay for readability
                IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.black.withValues(alpha: 0.1),
                          AppColors.transparent,
                          AppColors.black.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppSpacing.xxlPx.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductSummary(p),
                SizedBox(height: AppSpacing.md12),
                Divider(color: AppColors.grey100, thickness: 1.h, height: 1.h),
                _buildSellerSection(p),
                Divider(color: AppColors.grey100, thickness: 1.h, height: 1.h),
                _buildProductRating(p),
                Divider(color: AppColors.grey100, thickness: 1.h, height: 1.h),
                _buildProductDescription(p),
                Divider(color: AppColors.grey100, thickness: 1.h, height: 1.h),
                ProductQaSection(product: p, cubit: _qaCubit),
              ],
            ),
          ),
        ),
        if (p.productMode == 'BIOMASS_MATERIAL')
          SliverToBoxAdapter(child: _buildPredictQualityEntry(p)),
        if (p.productMode == 'ORGANIC_PRODUCE' || p.technicalSpec != null)
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  top: BorderSide(color: AppColors.grey100, width: 1.h),
                ),
              ),
              child: _buildTechnicalSpecs(p),
            ),
          ),
        if (p.certificates.isNotEmpty)
          SliverToBoxAdapter(
            child: ProductCertificateSection(certificates: p.certificates),
          ),
        SliverToBoxAdapter(
          child: ProductRecommendationsSection(productId: p.id),
        ),

        SliverToBoxAdapter(
          child: Container(
            color: AppColors.background,
            padding: EdgeInsets.zero,
            child: HorizontalProductSection(
              title: _product?.productMode == 'ORGANIC_PRODUCE'
                  ? 'marketplace.rec_organic'.tr()
                  : 'marketplace.rec_product'.tr(),
              limit: 20,
              productMode: _product?.productMode,
              onShowAll: () {
                context.push(
                  '/collection-products',
                  extra: {
                    'title': _product?.productMode == 'ORGANIC_PRODUCE'
                        ? 'marketplace.rec_organic'.tr()
                        : 'marketplace.rec_product'.tr(),
                    'sortBy': 'createdAt',
                    'sortOrder': 'desc',
                    'productMode': _product?.productMode,
                  },
                );
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.pageGutter,
              AppSpacing.sectionGap,
              AppSpacing.pageGutter,
              AppSpacing.compact,
            ),
            child: Text(
              _product?.productMode == 'ORGANIC_PRODUCE'
                  ? 'marketplace.all_organic'.tr()
                  : 'marketplace.all_products'.tr(),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: BlocProvider(
            create: (context) =>
                sl<MarketplaceCubit>()
                  ..getProducts(productMode: _product?.productMode),
            child: BlocBuilder<MarketplaceCubit, MarketplaceState>(
              builder: (context, state) {
                return state.maybeWhen(
                  loading: () => ShimmerProductGridPlaceholder(
                    itemCount: 4,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.pageGutter,
                    ),
                  ),
                  loaded: (products, hasReachedMax) {
                    if (products.isEmpty) return const SizedBox.shrink();
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.pageGutter,
                      ),
                      child: MasonryGridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: AppSpacing.md12,
                        mainAxisSpacing: AppSpacing.md12,
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return ProductCard(product: products[index]);
                        },
                      ),
                    );
                  },
                  orElse: () => const SizedBox.shrink(),
                );
              },
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sectionGap)),
      ],
    );
  }

  Widget _buildProductSummary(ProductEntity p) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xl,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Label
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: p.productMode == 'ORGANIC_PRODUCE'
                  ? AppColors.primaryLight
                  : AppColors.primaryLight.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              p.productMode == 'ORGANIC_PRODUCE'
                  ? (p.cropType ?? 'marketplace.badge_mode_organic'.tr())
                        .toUpperCase()
                  : p.biomassaType.toUpperCase(),
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w900,
                color: p.productMode == 'ORGANIC_PRODUCE'
                    ? AppColors.primaryMedium
                    : AppColors.primary,
                letterSpacing: 1.0,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          // Product Name
          Text(
            p.name,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),

          SizedBox(height: 6.h),
          if (p.originalPrice != null && p.originalPrice! > p.pricePerUnit)
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 4.h),
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    formatMoneyDisplay(p.originalPrice!),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textOnPrimary,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: AppColors.textOnPrimary,
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Container(
                  margin: EdgeInsets.only(bottom: 4.h),
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    '${((p.originalPrice! - p.pricePerUnit) / p.originalPrice! * 100).round()}% OFF / ${p.unit}',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w900,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatMoneyDisplay(p.pricePerUnit),
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  letterSpacing: -1.0,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Text(
                  '/ ${p.unit}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textHint,
                  ),
                ),
              ),
            ],
          ),
          Builder(
            builder: (context) {
              final pricing = ProductPricingInfo.fromProduct(
                pricePerUnit: p.pricePerUnit,
                originalPrice: p.originalPrice,
                minOrder: p.minOrder,
                unit: p.unit,
              );
              if (!pricing.hasPromo && p.minOrder <= 1) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: EdgeInsets.only(top: AppSpacing.sm),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppSpacing.sm10),
                  decoration: BoxDecoration(
                    color: AppColors.grey50,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.grey200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (pricing.hasPromo) ...[
                        Text(
                          pricing.promoRuleSummary,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textSecondary,
                            height: 1.35,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          pricing.exampleForQuantity(p.minOrder),
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ] else
                        Text(
                          'marketplace.min_buy'.tr(
                            namedArgs: {
                              'qty': ProductPricingInfo.formatQty(p.minOrder),
                              'unit': p.unit,
                            },
                          ),
                          style: AppTextStyles.caption(
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: AppSpacing.md12),
          // Badges Row
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm10,
                  vertical: AppSpacing.xs6,
                ),
                decoration: BoxDecoration(
                  color: p.productMode == 'ORGANIC_PRODUCE'
                      ? AppColors.primaryLight
                      : AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
                child: Text(
                  p.productMode == 'ORGANIC_PRODUCE'
                      ? (p.cropType ?? 'marketplace.badge_mode_organic'.tr())
                            .toUpperCase()
                      : p.biomassaType.toUpperCase(),
                  style: TextStyle(
                    color: p.productMode == 'ORGANIC_PRODUCE'
                        ? AppColors.primaryMedium
                        : AppColors.primary,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (p.productMode == 'ORGANIC_PRODUCE') ...[
                if (p.isChemicalFree)
                  _buildSmallBadge(
                    LucideIcons.leaf,
                    'marketplace.badge_chemical_free'.tr(),
                    AppColors.primaryMedium,
                  ),
                if (p.fertilizerType != null && p.fertilizerType!.isNotEmpty)
                  _buildSmallBadge(
                    LucideIcons.sprout,
                    p.fertilizerType!.toUpperCase().contains('BIOCHAR')
                        ? 'marketplace.badge_biochar_soil'.tr()
                        : p.fertilizerType!,
                    AppColors.secondary,
                  ),
              ] else ...[
                if (p.grade != null)
                  _buildSmallBadge(
                    LucideIcons.medal,
                    'marketplace.badge_grade'.tr(
                      namedArgs: {'grade': '${p.grade}'},
                    ),
                    AppColors.warning,
                  ),
              ],
              if (p.isCertified)
                _buildSmallBadge(
                  LucideIcons.award,
                  'marketplace.badge_certified'.tr(),
                  AppColors.success,
                ),
              if (p.isIotMonitored)
                Tooltip(
                  message: 'marketplace.badge_iot_tooltip'.tr(),
                  child: _buildSmallBadge(
                    LucideIcons.cpu,
                    'marketplace.badge_iot'.tr(),
                    AppColors.info,
                  ),
                ),
              if (p.isEscrowProtected)
                _buildSmallBadge(
                  LucideIcons.shieldCheck,
                  'marketplace.badge_secure'.tr(),
                  AppColors.ocean,
                ),
            ],
          ),
          SizedBox(height: AppSpacing.md12),
          Divider(color: AppColors.grey100, thickness: 1.5.h, height: 2.h),
          // Quick Info Grid
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(
                color: AppColors.primaryLight.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickInfoItem(
                  LucideIcons.package,
                  'marketplace.stock_label'.tr(),
                  '${p.stock} ${p.unit}',
                ),
                _buildDivider(),
                _buildQuickInfoItem(
                  LucideIcons.shoppingCart,
                  'marketplace.min_order_label'.tr(),
                  '${p.minOrder} ${p.unit}',
                ),
                _buildDivider(),
                _buildQuickInfoItem(
                  LucideIcons.mapPin,
                  'marketplace.location_label'.tr(),
                  p.province,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() => Container(
    height: 30.h,
    width: 1.5.w,
    color: AppColors.primaryLight.withValues(alpha: 0.3),
  );

  Widget _buildQuickInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18.sp, color: AppColors.primary),
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: AppColors.textHint,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSellerSection(ProductEntity p) {
    return InkWell(
      onTap: () {
        context.push(
          '/supplier/${p.seller.id}',
          extra: {'name': p.seller.companyName ?? p.seller.name},
        );
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.md12,
          AppSpacing.xl,
          AppSpacing.sm10,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: AppRadius.pill,
              backgroundColor: AppColors.primaryLight,
              backgroundImage: resolveMediaImageProvider(p.seller.avatarUrl),
              child: p.seller.avatarUrl == null
                  ? Icon(
                      LucideIcons.user,
                      color: AppColors.primary,
                      size: 20.sp,
                    )
                  : null,
            ),
            SizedBox(width: AppSpacing.md12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          p.seller.companyName ?? p.seller.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (p.seller.isVerified) ...[
                        SizedBox(width: 4.w),
                        Icon(
                          LucideIcons.badgeCheck,
                          color: AppColors.info,
                          size: 14.sp,
                        ),
                      ],
                    ],
                  ),
                  Text(
                    p.regency ?? p.province,
                    style: AppTextStyles.caption(color: AppColors.textHint),
                  ),
                  if (p.seller.isVerified)
                    Row(
                      children: [
                        Icon(
                          LucideIcons.shieldCheck,
                          color: AppColors.info,
                          size: 11.sp,
                        ),
                        SizedBox(width: 4.w),
                        Flexible(
                          child: Text(
                            'marketplace.verified_supplier'.tr(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.info,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: AppColors.warning,
                        size: 14.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${p.averageRating}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'marketplace.partner_rating'.tr(),
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.textHint,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            FollowButton(userId: p.seller.id, compact: true),
            SizedBox(width: 4.w),
            Icon(
              LucideIcons.chevronRight,
              color: AppColors.textHint,
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductRating(ProductEntity p) {
    return InkWell(
      onTap: () {
        context.push('/product-reviews/${p.id}', extra: {'name': p.name});
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.sm,
          AppSpacing.xl,
          AppSpacing.md,
        ),
        child: Row(
          children: [
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < p.averageRating.floor()
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: AppColors.warning,
                  size: 18.sp,
                );
              }),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'marketplace.reviews_count'.tr(
                  namedArgs: {
                    'rating': '${p.averageRating}',
                    'count': '${p.totalReviews}',
                  },
                ),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              size: 18.sp,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDescription(ProductEntity p) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md12,
        AppSpacing.xl,
        AppSpacing.md12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'marketplace.about_product'.tr(),
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            p.description ?? 'marketplace.no_description'.tr(),
            maxLines: _isDescriptionExpanded ? null : 3,
            overflow: _isDescriptionExpanded ? null : TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          if ((p.description?.length ?? 0) > 100)
            InkWell(
              onTap: () {
                setState(() {
                  _isDescriptionExpanded = !_isDescriptionExpanded;
                });
              },
              child: Padding(
                padding: EdgeInsets.only(top: AppSpacing.sm),
                child: Text(
                  _isDescriptionExpanded
                      ? 'marketplace.show_less'.tr()
                      : 'marketplace.show_more'.tr(),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  ProductSpecsData _specsFromProduct(ProductEntity p) {
    return ProductSpecsData.fromProduct(p);
  }

  Widget _buildPredictQualityEntry(ProductEntity p) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md12,
        AppSpacing.xl,
        AppSpacing.sm,
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: () => PredictQualitySheet.show(
            context,
            initialBiomassaType: p.biomassaType,
          ),
          borderRadius: BorderRadius.circular(AppRadius.tile),
          child: Ink(
            padding: EdgeInsets.all(AppSpacing.section),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.12),
                  AppColors.primaryLight.withValues(alpha: 0.4),
                ],
              ),
              borderRadius: BorderRadius.circular(AppRadius.tile),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  LucideIcons.sparkles,
                  color: AppColors.primary,
                  size: 22.sp,
                ),
                SizedBox(width: AppSpacing.md12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ai.predict_entry_title'.tr(),
                        style: AppTextStyles.body(fontWeight: FontWeight.w800),
                      ),
                      Text(
                        'ai.predict_entry_subtitle'.tr(),
                        style: AppTextStyles.caption(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  color: AppColors.grey400,
                  size: 18.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTechnicalSpecs(ProductEntity p) {
    final isOrganic = p.productMode == 'ORGANIC_PRODUCE';
    if (!isOrganic && p.technicalSpec == null && p.specs.isEmpty) {
      return const SizedBox.shrink();
    }

    final entries = _specsFromProduct(p).entriesForMode(p.productMode);
    if (entries.isEmpty) return const SizedBox.shrink();

    final specs = entries
        .map((e) => {'label': e.key, 'value': e.value})
        .toList();
    final previewSpecs = specs.length > _specPreviewLimit
        ? specs.take(_specPreviewLimit).toList()
        : specs;
    final title = isOrganic
        ? 'marketplace.specs_organic'.tr()
        : 'marketplace.specs_technical'.tr();

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md12,
        AppSpacing.xl,
        isOrganic ? AppSpacing.xl : AppSpacing.md12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (specs.length > _specPreviewLimit)
                TextButton(
                  onPressed: () => _showAllSpecs(specs),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'marketplace.show_all'.tr(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: AppSpacing.md12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.grey100),
            ),
            child: Column(
              children: previewSpecs.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Column(
                  children: [
                    _buildSpecRow(item['label']!, item['value']!),
                    if (index != previewSpecs.length - 1)
                      Divider(color: AppColors.grey100, height: 1),
                  ],
                );
              }).toList(),
            ),
          ),
          if (isOrganic) ...[
            SizedBox(height: AppSpacing.lg),
            _buildOrganicEsgSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildOrganicEsgSection() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: AppColors.primaryLight.withValues(alpha: 0.4),
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.globe, color: AppColors.primary, size: 20.sp),
              SizedBox(width: AppSpacing.md12),
              Text(
                'marketplace.esg_title'.tr(),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'marketplace.esg_body'.tr(),
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              ProductSpecsMapper.displayLabel(label),
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textHint,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md12),
          Expanded(
            flex: 3,
            child: Text(
              ProductSpecsMapper.displayValue(value),
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAllSpecs(List<Map<String, String>> specs) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        final maxH = MediaQuery.sizeOf(context).height * 0.75;
        return Container(
          constraints: BoxConstraints(maxHeight: maxH),
          padding: EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.md12,
            AppSpacing.xl,
            AppSpacing.xl + systemBottomInset(context),
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSpacing.xxlPx.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              Text(
                'marketplace.all_specs'.tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Flexible(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: AppColors.grey100),
                    ),
                    child: Column(
                      children: specs.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        return Column(
                          children: [
                            _buildSpecRow(item['label']!, item['value']!),
                            if (index != specs.length - 1)
                              Divider(color: AppColors.grey100, height: 1),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomAction() {
    final p = _product!;
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isAuthenticated = state.maybeWhen(
          authenticated: (_) => true,
          orElse: () => false,
        );

        return Container(
          color: AppColors.surface,
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(color: AppColors.grey200, height: 1, thickness: 1),
                if (p.allowsSample && p.minOrder > 1)
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.xl,
                      AppSpacing.md12,
                      AppSpacing.xl,
                      0,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: AppSpacing.buttonHeight,
                      child: OutlinedButton.icon(
                        onPressed: _isSampleOrdering
                            ? null
                            : () {
                                if (!isAuthenticated) {
                                  AuthSheet.show(context);
                                  return;
                                }
                                _orderSample(p);
                              },
                        icon: _isSampleOrdering
                            ? SizedBox(
                                width: AppSpacing.md,
                                height: AppSpacing.md,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(LucideIcons.flaskConical, size: 18.sp),
                        label: Text('product.sample_order_cta'.tr()),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                if (p.status == 'ACTIVE' && p.stock >= p.minOrder)
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.xl,
                      AppSpacing.md12,
                      AppSpacing.xl,
                      0,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: AppSpacing.buttonHeight,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          if (!isAuthenticated) {
                            AuthSheet.show(context);
                            return;
                          }
                          showBookingCreateSheet(context: context, product: p);
                        },
                        icon: Icon(LucideIcons.calendarClock, size: 18.sp),
                        label: Text('booking.cta'.tr()),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.secondary,
                          side: BorderSide(color: AppColors.secondary),
                        ),
                      ),
                    ),
                  ),
                // Bar aksi gaya Shopee: chat + nego + keranjang menempel tanpa gap.
                Padding(
                  padding: EdgeInsets.only(top: AppSpacing.md12),
                  child: SizedBox(
                    height: AppSpacing.buttonHeightLg,
                    width: double.infinity,
                    child: Row(
                      children: [
                        // Chat penjual
                        SizedBox(
                          width: 64.w,
                          height: double.infinity,
                          child: Material(
                            color: AppColors.primaryLight,
                            child: InkWell(
                              onTap: () {
                                ProductSellerChat.open(
                                  context: context,
                                  product: p,
                                );
                              },
                              child: Icon(
                                LucideIcons.messageSquare,
                                color: AppColors.primary,
                                size: 20.sp,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          color: AppColors.primary.withValues(alpha: 0.15),
                        ),
                        // Nego harga
                        Expanded(
                          child: SizedBox(
                            height: double.infinity,
                            child: Material(
                              color: AppColors.primaryLight,
                              child: InkWell(
                                onTap: () {
                                  if (!isAuthenticated) {
                                    AuthSheet.show(context);
                                    return;
                                  }
                                  _showNegotiationSheet();
                                },
                                child: Center(
                                  child: Text(
                                    'marketplace.nego_price'.tr(),
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Tambah keranjang (solid, tanpa gap dari nego)
                        Expanded(
                          child: SizedBox(
                            height: double.infinity,
                            child: Material(
                              color: AppColors.primary,
                              child: InkWell(
                                onTap: () async {
                                  if (!isAuthenticated) {
                                    AuthSheet.show(context);
                                    return;
                                  }
                                  final ok = await context
                                      .read<CommerceCubit>()
                                      .addToCart(p.id, p.minOrder);
                                  if (context.mounted && ok) {
                                    showCustomSnackBar(
                                      context,
                                      content: Text(
                                        'marketplace.added_to_cart'.tr(
                                          namedArgs: {
                                            'qty': '${p.minOrder.toInt()}',
                                            'unit': p.unit,
                                          },
                                        ),
                                      ),
                                      backgroundColor: AppColors.success,
                                      action: SnackBarAction(
                                        label: 'marketplace.view_cart'.tr(),
                                        onPressed: () => context.push('/cart'),
                                      ),
                                    );
                                  }
                                },
                                child: Center(
                                  child: Text(
                                    'marketplace.cart_btn'.tr(),
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textOnPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSmallBadge(IconData icon, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm10,
        vertical: AppSpacing.xs6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.button),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: color),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
