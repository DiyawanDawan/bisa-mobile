import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/safe_area_utils.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/product_pricing.dart';
import '../../../../core/utils/rupiah_input_formatter.dart';
import '../../../negotiation/domain/models/negotiation_offer_draft.dart';
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
import 'supplier_profile_page.dart';
import 'product_reviews_page.dart';
import '../../../../shared/widgets/auth_sheet.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../../../core/utils/media_url_utils.dart';
import '../../../commerce/presentation/bloc/commerce_cubit.dart';
import '../../../commerce/presentation/widgets/product_like_button.dart';
import '../../../follow/presentation/widgets/follow_button.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';

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
                  setState(() => _product = products.first);
                }
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => _buildLoadingSkeleton(),
              error: (message) => Center(child: Text(message)),
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
          child: BisaMediaSkeleton(
            width: double.infinity,
            height: 350.h,
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(16.w),
          sliver: SliverToBoxAdapter(
            child: ShimmerLoading(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Bone.multiText(lines: 2),
                  SizedBox(height: 16.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Bone.circle(size: 44.w),
                      SizedBox(width: 12.w),
                      Expanded(child: Bone.multiText(lines: 2)),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Bone(width: double.infinity, height: 56.h),
                  SizedBox(height: 12.h),
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
    return name.isNotEmpty ? name : 'Toko';
  }

  Future<void> _openNegotiationPreview(NegotiationOfferDraft draft) async {
    if (!await ReadinessGate.ensureBuyerReady(context)) return;
    if (!mounted) return;
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
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final maxHeight = MediaQuery.sizeOf(sheetContext).height * 0.92;
        return Padding(
          padding: sheetBottomPadding(sheetContext),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Container(
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
              ),
              child: StatefulBuilder(
                builder: (context, setSheetState) {
                  final requestedQty = double.tryParse(quantityController.text);
                  final outOfStock =
                      NegotiationQuantityRules.isOutOfStock(p.stock);
                  return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tawar Harga',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(sheetContext),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                NegotiationSellerChip(
                  displayName:
                      prefill?.sellerDisplayName ?? _sellerDisplayName(p),
                  avatarUrl: prefill?.sellerAvatarUrl ?? p.seller.avatarUrl,
                  isVerified:
                      prefill?.sellerIsVerified ?? p.seller.isVerified,
                ),
                SizedBox(height: 10.h),
                NegotiationProductPreview(
                  name: p.name,
                  thumbnailUrl: p.thumbnailUrl,
                  priceLabel: p.pricePerUnit.toRupiah,
                  subtitle: 'Harga di katalog',
                ),
                SizedBox(height: 10.h),
                NegotiationStockBanner(
                  stock: p.stock,
                  minOrder: p.minOrder,
                  unit: p.unit,
                  requestedQty: requestedQty,
                ),
                SizedBox(height: 12.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        LucideIcons.messageCircle,
                        size: 18.sp,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          'Isi jumlah & harga yang Anda inginkan. '
                          'Penjual akan membalas di chat negosiasi.',
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
                SizedBox(height: 20.h),
                Text(
                  '1. Berapa yang Anda butuhkan?',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  label: 'Jumlah (${p.unit})',
                  hint:
                      'Min ${ProductPricingInfo.formatQty(p.minOrder)} · maks ${ProductPricingInfo.formatQty(p.stock)}',
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  prefixIcon: LucideIcons.package,
                  onChanged: (_) => setSheetState(() {}),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Wajib diisi';
                    return NegotiationQuantityRules.validate(
                      quantity: double.tryParse(value),
                      minOrder: p.minOrder,
                      stock: p.stock,
                      unit: p.unit,
                    );
                  },
                ),
                SizedBox(height: 20.h),
                Text(
                  '2. Harga yang Anda tawarkan',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Harga di katalog: ${p.pricePerUnit.toRupiah} / ${p.unit}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  label: 'Harga tawaran (per ${p.unit})',
                  hint: formatRupiahInput(p.pricePerUnit),
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  prefixIcon: LucideIcons.banknote,
                  inputFormatters: [RupiahInputFormatter()],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Wajib diisi';
                    }
                    if (parseRupiahInput(value) == null) {
                      return 'Nominal tidak valid';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                Text(
                  '3. Catatan untuk penjual (opsional)',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  label: 'pesantambahanopsional'.tr().tr(),
                  hint: 'tulispesanuntukpenjual'.tr().tr(),
                  controller: _messageController,
                  maxLines: 3,
                  prefixIcon: LucideIcons.messageSquare,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Foto pendukung (opsional)',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 12.h),
                InkWell(
                  onTap: _pickImage,
                  child: Container(
                    height: 100.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.grey50,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.grey200, width: 1),
                    ),
                    child: _imageFile != null
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.r),
                                child: Image.file(
                                  _imageFile!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8.r,
                                right: 8.r,
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => _imageFile = null),
                                  child: CircleAvatar(
                                    radius: 12.r,
                                    backgroundColor: Colors.black.withValues(
                                      alpha: 0.5,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      size: 14.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LucideIcons.imagePlus,
                                color: AppColors.grey400,
                                size: 32.sp,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Klik untuk tambah gambar',
                                style: TextStyle(
                                  color: AppColors.textHint,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                SizedBox(height: 32.h),
                CustomButton(
                  text: outOfStock
                      ? 'Stok habis'
                      : 'Lihat ringkasan penawaran',
                  useGradient: true,
                  onPressed: outOfStock
                      ? null
                      : () {
                    if (!formKey.currentState!.validate()) return;
                    final qty = double.tryParse(quantityController.text);
                    final price = parseRupiahInput(priceController.text);
                    if (qty == null || price == null) return;
                    final qtyError = NegotiationQuantityRules.validate(
                      quantity: qty,
                      minOrder: p.minOrder,
                      stock: p.stock,
                      unit: p.unit,
                    );
                    if (qtyError != null) return;

                    final draft = NegotiationOfferDraft.fromProduct(
                      p,
                      quantity: qty,
                      offerPricePerUnit: price,
                      message: _messageController.text.trim().isEmpty
                          ? null
                          : _messageController.text.trim(),
                      localImagePath: _imageFile?.path,
                    );

                    Navigator.pop(sheetContext);
                    _openNegotiationPreview(draft);
                  },
                ),
                SizedBox(height: 16.h),
                    ],
                  ),
                ),
              );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  int _currentImageIndex = 0;

  Widget _buildContent() {
    final p = _product!;
    final List<String> images = p.images != null && p.images!.isNotEmpty
        ? p.images!.map((e) => e.url).toList()
        : [p.thumbnailUrl ?? ''];

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          expandedHeight: 350.h,
          pinned: true,
          elevation: 0,
          backgroundColor: AppColors.white,
          leading: Padding(
            padding: EdgeInsets.all(8.r),
            child: CircleAvatar(
              backgroundColor: Colors.white,
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
                    padding: EdgeInsets.all(8.r),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
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
              padding: EdgeInsets.all(8.r),
              child: CircleAvatar(
                backgroundColor: Colors.white,
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
            Padding(
              padding: EdgeInsets.all(8.r),
              child: ProductLikeButton(
                productId: _product!.id,
                size: 18,
                backgroundColor: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.r),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(
                    LucideIcons.share2,
                    color: AppColors.textPrimary,
                    size: 18.sp,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                PageView.builder(
                  itemCount: images.length,
                  onPageChanged: (index) =>
                      setState(() => _currentImageIndex = index),
                  itemBuilder: (context, index) {
                    return BisaNetworkImage(
                      imageUrl: images[index],
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          Container(color: AppColors.grey100),
                    );
                  },
                ),
                // Image Indicator
                if (images.length > 1)
                  Positioned(
                    bottom: 20.h,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: images.asMap().entries.map((entry) {
                        return Container(
                          width: 8.w,
                          height: 8.w,
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentImageIndex == entry.key
                                ? AppColors.primary
                                : Colors.white.withValues(alpha: 0.5),
                          ),
                        );
                      }).toList(),
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
                          Colors.black.withValues(alpha: 0.1),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.05),
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
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductSummary(p),
                SizedBox(height: 12.h),
                Divider(color: AppColors.grey100, thickness: 1.h, height: 1.h),
                _buildSellerSection(p),
                Divider(color: AppColors.grey100, thickness: 1.h, height: 1.h),
                _buildProductRating(p),
                Divider(color: AppColors.grey100, thickness: 1.h, height: 1.h),
                _buildProductDescription(p),
              ],
            ),
          ),
        ),
        if (p.productMode == 'ORGANIC_PRODUCE' || p.technicalSpec != null)
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border(
                  top: BorderSide(color: AppColors.grey100, width: 1.h),
                ),
              ),
              child: _buildTechnicalSpecs(p),
            ),
          ),

        SliverToBoxAdapter(
          child: Container(
            color: AppColors.background,
            padding: EdgeInsets.only(top: 24.h),
            child: HorizontalProductSection(
              title: _product?.productMode == 'ORGANIC_PRODUCE'
                  ? 'Rekomendasi Hasil Tani'
                  : 'Rekomendasi Produk',
              limit: 20,
              productMode: _product?.productMode,
              onShowAll: () {
                context.push(
                  '/collection-products',
                  extra: {
                    'title': _product?.productMode == 'ORGANIC_PRODUCE'
                        ? 'Rekomendasi Hasil Tani'
                        : 'Rekomendasi Produk',
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
            padding: EdgeInsets.fromLTRB(20.w, 32.h, 20.w, 16.h),
            child: Text(
              _product?.productMode == 'ORGANIC_PRODUCE'
                  ? 'Semua Hasil Tani Organik'
                  : 'Semua Produk',
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
            create: (context) => sl<MarketplaceCubit>()
              ..getProducts(productMode: _product?.productMode),
            child: BlocBuilder<MarketplaceCubit, MarketplaceState>(
              builder: (context, state) {
                return state.maybeWhen(
                  loading: () => ShimmerProductGridPlaceholder(
                    itemCount: 4,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                  ),
                  loaded: (products, hasReachedMax) {
                    if (products.isEmpty) return const SizedBox.shrink();
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: MasonryGridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
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
        SliverToBoxAdapter(child: SizedBox(height: 100.h)),
      ],
    );
  }

  Widget _buildProductSummary(ProductEntity p) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Label
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: p.productMode == 'ORGANIC_PRODUCE'
                  ? AppColors.primaryLight
                  : AppColors.primaryLight.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              p.productMode == 'ORGANIC_PRODUCE'
                  ? (p.cropType ?? 'Hasil Tani').toUpperCase()
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
          SizedBox(height: 8.h),
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
                    p.originalPrice!.toRupiah,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  margin: EdgeInsets.only(bottom: 4.h),
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(color: AppColors.error.withValues(alpha: 0.5)),
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
                p.pricePerUnit.toRupiah,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  letterSpacing: -1.0,
                ),
              ),
              SizedBox(width: 8.w),
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
                padding: EdgeInsets.only(top: 8.h),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: AppColors.grey50,
                    borderRadius: BorderRadius.circular(10.r),
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
                          'Min. beli ${ProductPricingInfo.formatQty(p.minOrder)} ${p.unit}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 12.h),
          // Badges Row
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: p.productMode == 'ORGANIC_PRODUCE'
                      ? AppColors.primaryLight
                      : AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  p.productMode == 'ORGANIC_PRODUCE'
                      ? (p.cropType ?? 'Hasil Tani').toUpperCase()
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
                    'Bebas Kimia',
                    AppColors.primaryMedium,
                  ),
                if (p.fertilizerType != null && p.fertilizerType!.isNotEmpty)
                  _buildSmallBadge(
                    LucideIcons.sprout,
                    p.fertilizerType!.toUpperCase().contains('BIOCHAR')
                        ? 'Tanah Biochar'
                        : p.fertilizerType!,
                    AppColors.secondary,
                  ),
              ] else ...[
                if (p.grade != null)
                  _buildSmallBadge(
                    LucideIcons.medal,
                    'Grade ${p.grade}',
                    AppColors.warning,
                  ),
              ],
              if (p.isCertified)
                _buildSmallBadge(
                  LucideIcons.award,
                  'Certified',
                  AppColors.success,
                ),
              if (p.isIotMonitored)
                _buildSmallBadge(LucideIcons.cpu, 'IoT', AppColors.info),
              if (p.isEscrowProtected)
                _buildSmallBadge(
                  LucideIcons.shieldCheck,
                  'Secure',
                  AppColors.ocean,
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(color: AppColors.grey100, thickness: 1.5.h, height: 2.h),
          // Quick Info Grid
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppColors.primaryLight.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickInfoItem(
                  LucideIcons.package,
                  'Stok',
                  '${p.stock} ${p.unit}',
                ),
                _buildDivider(),
                _buildQuickInfoItem(
                  LucideIcons.shoppingCart,
                  'Min. Order',
                  '${p.minOrder} ${p.unit}',
                ),
                _buildDivider(),
                _buildQuickInfoItem(LucideIcons.mapPin, 'Lokasi', p.province),
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
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18.sp, color: AppColors.primary),
        ),
        SizedBox(height: 8.h),
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
        padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 10.h),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20.r,
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
            SizedBox(width: 12.w),
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
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textHint,
                    ),
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
                            'Supplier Terverifikasi',
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
                        color: Colors.amber,
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
                        'Rating Mitra',
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
        padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 16.h),
        child: Row(
          children: [
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < p.averageRating.floor()
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: Colors.amber,
                  size: 18.sp,
                );
              }),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                '${p.averageRating} (${p.totalReviews} ulasan)',
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
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tentang Produk',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            p.description ?? 'Tidak ada deskripsi tersedia untuk produk ini.',
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
                padding: EdgeInsets.only(top: 8.h),
                child: Text(
                  _isDescriptionExpanded ? 'Sembunyikan' : 'Lihat Selengkapnya',
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
    final title =
        isOrganic ? 'Spesifikasi Hasil Tani' : 'Spesifikasi Teknis';

    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, isOrganic ? 24.h : 12.h),
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
                    'Lihat Semua',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12.r),
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
            SizedBox(height: 20.h),
            _buildOrganicEsgSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildOrganicEsgSection() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16.r),
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
              Icon(
                LucideIcons.globe,
                color: AppColors.primary,
                size: 20.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                'Dampak Keberlanjutan (ESG Impact)',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Setiap pembelian produk ini mendukung perekonomian petani lokal mandiri yang melestarikan tanah dengan teknik regeneratif. Dengan mengonsumsi pangan bebas bahan kimia, Anda berkontribusi mengurangi emisi nitrogen oksida global & penyerapan karbon di lapisan tanah.',
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
        horizontal: 16.w,
        vertical: 12.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textHint,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            flex: 3,
            child: Text(
              value,
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
      backgroundColor: Colors.transparent,
      builder: (context) {
        final maxH = MediaQuery.sizeOf(context).height * 0.75;
        return Container(
          constraints: BoxConstraints(maxHeight: maxH),
          padding: EdgeInsets.fromLTRB(
            24.w,
            12.h,
            24.w,
            24.h + systemBottomInset(context),
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              Text(
                'Semua Spesifikasi',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 16.h),
              Flexible(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12.r),
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
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 16.h),
                  child: Row(
                    children: [
                      // Minimal Floating Chat Button
                      Container(
                        height: 56.h,
                        width: 56.h,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: AppColors.grey100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            LucideIcons.messageSquare,
                            color: AppColors.primary,
                          ),
                          onPressed: () {
                            ProductSellerChat.open(
                              context: context,
                              product: p,
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Nego Button
                      Expanded(
                        child: Container(
                          height: 56.h,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                          ),
                          child: TextButton(
                            onPressed: () {
                              if (!isAuthenticated) {
                                AuthSheet.show(context);
                                return;
                              }
                              _showNegotiationSheet();
                            },
                            child: Text(
                              'Nego Harga',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Floating Buy Button
                      Expanded(
                        child: Container(
                          height: 56.h,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (!isAuthenticated) {
                                AuthSheet.show(context);
                                return;
                              }
                              final ok = await context
                                  .read<CommerceCubit>()
                                  .addToCart(p.id, p.minOrder);
                              if (context.mounted && ok) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Ditambahkan ke keranjang (${p.minOrder.toInt()} ${p.unit})',
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    action: SnackBarAction(
                                      label: 'Lihat',
                                      onPressed: () => context.push('/cart'),
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            child: Text(
                              'Keranjang',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
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

