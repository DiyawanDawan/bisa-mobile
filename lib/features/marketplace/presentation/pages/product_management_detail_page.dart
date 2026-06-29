import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/i18n/locale_formatters.dart';
import 'package:mobile_bisa/features/marketplace/domain/entities/product_entity.dart';
import 'package:mobile_bisa/features/marketplace/domain/entities/product_stats_entity.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/product_pricing.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/utils/money_format.dart';
import '../../../../core/utils/media_url_utils.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/product_detail_skeleton.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../negotiation/domain/entities/negotiation_entity.dart';
import '../../../negotiation/presentation/bloc/negotiation_cubit.dart';
import '../../../negotiation/presentation/utils/negotiation_status_ui.dart';
import '../../data/models/review_model.dart';
import '../bloc/product_management_cubit.dart';
import '../bloc/review_cubit.dart';
import '../bloc/review_state.dart';
import '../widgets/product_image_manager_section.dart';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import '../../../../shared/widgets/product_video_player.dart';
import '../widgets/product_specs_sheet.dart';

class ProductManagementDetailPage extends StatelessWidget {
  final String productId;

  const ProductManagementDetailPage({super.key, required this.productId});

  static const _hPad = 16.0;
  static const _secGap = 10.0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ProductManagementCubit>()..getProductDetail(productId)),
        BlocProvider(create: (_) => sl<ReviewCubit>()..getProductReviews(productId)),
        BlocProvider(create: (_) => sl<NegotiationCubit>()..getIncomingOffers()),
      ],
      child: BlocConsumer<ProductManagementCubit, ProductManagementState>(
        listener: (context, state) {
          state.maybeWhen(
            deleted: () {
              context.pop();
              showSuccessSnackBar(context, 'marketplace.product_deleted'.tr());
            },
            duplicated: (product) {
              showSuccessSnackBar(context, 'marketplace.product_duplicated'.tr());
              context.pushReplacement('/product-manage/${product.id}');
            },
            error: (message) {
              showFailureSnackBarFromMessage(context, message);
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: BisaAppBar(
              title: 'marketplace.manage_product_title'.tr(),
              backgroundColor: AppColors.surface,
            ),
            body: state.maybeWhen(
              loading: () => const ShimmerProductDetailPlaceholder(),
              error: (message) => Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.triangleAlert,
                        size: 64.r,
                        color: AppColors.grey200,
                      ),
                      SizedBox(height: AppSpacing.md),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body(color: AppColors.textSecondary),
                      ),
                      SizedBox(height: AppSpacing.md),
                      TextButton(
                        onPressed: () => context
                            .read<ProductManagementCubit>()
                            .getProductDetail(productId),
                        child: Text('marketplace.try_again'.tr()),
                      ),
                    ],
                  ),
                ),
              ),
              loaded: (product, stats) {
                final userId = context.read<AuthCubit>().state.maybeWhen(
                  authenticated: (u) => u.id,
                  orElse: () => null,
                );
                if (userId == null || product.seller.id != userId) {
                  return _buildAccessDenied(context);
                }
                return _buildContent(context, product, stats: stats);
              },
              orElse: () => const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAccessDenied(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.shieldOff, size: 64.r, color: AppColors.grey200),
            SizedBox(height: AppSpacing.md),
            Text(
              'marketplace.access_denied'.tr(),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'marketplace.access_denied_body'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            CustomButton(
              text: 'marketplace.back'.tr(),
              width: 160.w,
              height: 48.h,
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ProductEntity p, {
    ProductStatsEntity? stats,
  }) {
    final bottomSafe = MediaQuery.paddingOf(context).bottom;
    final List<String> images = p.images != null && p.images!.isNotEmpty
        ? p.images!.map((e) => e.url).toList()
        : (p.thumbnailUrl != null ? [p.thumbnailUrl!] : <String>[]);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageSection(p, images),
          SizedBox(height: _secGap.h),
          ProductImageManagerSection(product: p),
          SizedBox(height: _secGap.h),
          _buildQuickActions(context, p),
          SizedBox(height: _secGap.h),
          _buildPromotionSection(context, p),
          SizedBox(height: _secGap.h),
          _buildVideoSection(context, p),
          _section(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _rowHeader('marketplace.section_product_info_short'.tr(), onEdit: () => _editTitle(context, p)),
                SizedBox(height: 6.h),
                _buildInfoGrid(context, p),
              ],
            ),
          ),
          SizedBox(height: _secGap.h),
          _section(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _rowHeader('marketplace.section_stock_price'.tr(), onEdit: () => _editStock(context, p)),
                SizedBox(height: 6.h),
                _buildStockGrid(context, p),
              ],
            ),
          ),
          SizedBox(height: _secGap.h),
          _section(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _rowHeader('marketplace.section_description'.tr(), onEdit: () => _editDescription(context, p)),
                SizedBox(height: 6.h),
                _buildDescriptionBody(p),
              ],
            ),
          ),
          if (_hasSpecs(p)) ...[
            SizedBox(height: _secGap.h),
            _section(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _rowHeader('marketplace.section_specs'.tr(), onEdit: () => _editSpecs(context, p)),
                  SizedBox(height: 6.h),
                  _buildSpecsBody(p),
                ],
              ),
            ),
          ] else ...[
            SizedBox(height: _secGap.h),
            _section(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _rowHeader('marketplace.section_specs'.tr(), onEdit: () => _editSpecs(context, p)),
                  SizedBox(height: 6.h),
                  Text(
                    'marketplace.no_specs_hint'.tr(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: _secGap.h),
          _buildStatsGrid(p, stats: stats),
          SizedBox(height: _secGap.h),
          _buildNegotiationsSection(context, p.id),
          SizedBox(height: _secGap.h),
          _buildReviewsSection(context, p),
          SizedBox(height: AppSpacing.md),
          _buildDangerZone(context, p),
          SizedBox(height: 24.h + bottomSafe),
        ],
      ),
    );
  }

  Widget _rowHeader(String title, {VoidCallback? onEdit}) {
    return Row(
      children: [
        Container(
          width: 3.w,
          height: AppSpacing.section,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (onEdit != null)
          Material(
            color: AppColors.primaryLight.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppRadius.button),
            child: InkWell(
              onTap: onEdit,
              borderRadius: BorderRadius.circular(AppRadius.button),
              child: Padding(
                padding: EdgeInsets.all(6.r),
                child: Icon(
                  LucideIcons.pencil,
                  size: 14.sp,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _section({required Widget child}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: _hPad.w),
      padding: EdgeInsets.all(AppSpacing.md12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.grey100),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildImageSection(ProductEntity p, List<String> images) {
    return Padding(
      padding: EdgeInsets.fromLTRB(_hPad.w, AppSpacing.sm10, _hPad.w, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Stack(
          children: [
            _ProductImageCarousel(images: images),
            Positioned(
              top: AppSpacing.md12,
              right: AppSpacing.md12,
              child: Wrap(
                spacing: 6.w,
                runSpacing: 6.h,
                children: [
                  _buildStatusBadge(p.status),
                  if (p.isCertified)
                    _iconPill(LucideIcons.award, AppColors.success),
                  if (p.isIotMonitored)
                    _iconPill(LucideIcons.cpu, AppColors.info),
                ],
              ),
            ),
            if (images.length > 1)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: IgnorePointer(
                  child: Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.black.withOpacity(0.35),
                          AppColors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _iconPill(IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(6.r),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppRadius.button),
        border: Border.all(color: color.withOpacity(0.35), width: 0.5),
      ),
      child: Icon(icon, size: 13.sp, color: color),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        color = AppColors.success;
        label = 'marketplace.status_active'.tr();
        break;
      case 'DRAFT':
        color = AppColors.warning;
        label = 'marketplace.status_draft'.tr();
        break;
      case 'OUT_OF_STOCK':
        color = AppColors.error;
        label = 'marketplace.status_out_of_stock'.tr();
        break;
      case 'INACTIVE':
        color = AppColors.grey500;
        label = 'marketplace.status_inactive'.tr();
        break;
      default:
        color = AppColors.grey500;
        label = status;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm10, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.92),
        borderRadius: BorderRadius.circular(AppRadius.button),
        border: Border.all(color: color.withOpacity(0.5), width: 0.5),
        boxShadow: AppColors.softShadow,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildPromotionSection(BuildContext context, ProductEntity p) {
    final active = p.isPromotionActive;
    return _section(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _rowHeader('marketplace.promote_section_title'.tr()),
          SizedBox(height: AppSpacing.sm),
          if (active && p.promotedUntil != null)
            Text(
              'marketplace.promote_active_until'.tr(
                namedArgs: {
                  'date': LocaleFormatters.formatDateTime(context, p.promotedUntil!),
                },
              ),
              style: TextStyle(fontSize: 12.sp, color: AppColors.success),
            ),
          if (p.promoImpressions > 0 || p.promoClicks > 0) ...[
            SizedBox(height: 6.h),
            Text(
              'marketplace.promote_stats'.tr(
                namedArgs: {
                  'impressions': '${p.promoImpressions}',
                  'clicks': '${p.promoClicks}',
                },
              ),
              style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
            ),
          ],
          SizedBox(height: AppSpacing.sm10),
          Text(
            'marketplace.promote_hint'.tr(),
            style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary, height: 1.4),
          ),
          SizedBox(height: AppSpacing.md12),
          CustomButton(
            text: active
                ? 'marketplace.promote_extend'.tr()
                : 'marketplace.promote_cta'.tr(),
            useGradient: true,
            onPressed: p.status.toUpperCase() == 'ACTIVE'
                ? () => _confirmPromote(context, p)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildVideoSection(BuildContext context, ProductEntity p) {
    final hasVideo = p.videoUrl != null && p.videoUrl!.isNotEmpty;
    return _section(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _rowHeader('marketplace.video_section_title'.tr()),
          SizedBox(height: AppSpacing.sm),
          Text(
            'marketplace.video_section_hint'.tr(),
            style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary, height: 1.4),
          ),
          if (hasVideo) ...[
            SizedBox(height: AppSpacing.md12),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: ProductVideoPlayer(videoUrl: p.videoUrl!, height: 180.h),
            ),
            SizedBox(height: AppSpacing.sm10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickAndUploadVideo(context, p),
                    icon: Icon(LucideIcons.refreshCw, size: 16.sp),
                    label: Text('marketplace.video_replace'.tr()),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _confirmDeleteVideo(context, p),
                    icon: Icon(LucideIcons.trash2, size: 16.sp, color: AppColors.error),
                    label: Text(
                      'marketplace.video_remove'.tr(),
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            SizedBox(height: AppSpacing.md12),
            CustomButton(
              text: 'marketplace.video_upload'.tr(),
              icon: LucideIcons.video,
              onPressed: () => _pickAndUploadVideo(context, p),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _pickAndUploadVideo(BuildContext context, ProductEntity p) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );
    final path = result?.files.single.path;
    if (path == null || !context.mounted) return;

    final err = await context.read<ProductManagementCubit>().uploadProductVideo(p.id, path);
    if (!context.mounted) return;
    if (err != null) {
      showFailureSnackBarFromMessage(context, err);
    } else {
      showSuccessSnackBar(context, 'marketplace.video_uploaded'.tr());
    }
  }

  Future<void> _confirmDeleteVideo(BuildContext context, ProductEntity p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('marketplace.video_remove_title'.tr()),
        content: Text('marketplace.video_remove_body'.tr()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('cancel'.tr())),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('marketplace.video_remove'.tr(), style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final err = await context.read<ProductManagementCubit>().deleteProductVideo(p.id);
    if (!context.mounted) return;
    if (err != null) {
      showFailureSnackBarFromMessage(context, err);
    }
  }

  Future<void> _confirmPromote(BuildContext context, ProductEntity p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('marketplace.promote_confirm_title'.tr()),
        content: Text('marketplace.promote_confirm_body'.tr()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('cancel'.tr())),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('marketplace.promote_cta'.tr(), style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final err = await context.read<ProductManagementCubit>().promoteProduct(p.id);
    if (!context.mounted) return;
    if (err != null) {
      showFailureSnackBarFromMessage(context, err);
    } else {
      showSuccessSnackBar(context, 'marketplace.promote_success'.tr());
    }
  }

  Widget _buildQuickActions(BuildContext context, ProductEntity p) {
    final isActive = p.status.toUpperCase() == 'ACTIVE';
    return Padding(
      padding: EdgeInsets.fromLTRB(_hPad.w, AppSpacing.sm10, _hPad.w, AppSpacing.xs6),
      child: Row(
        children: [
          Expanded(
            child: _actionBtn(
              LucideIcons.pencil,
              'marketplace.edit'.tr(),
              AppColors.primary,
              () => context.push('/edit-product', extra: p),
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _actionBtn(
              LucideIcons.copy,
              'marketplace.duplicate'.tr(),
              AppColors.info,
              () => _confirmDuplicate(context, p),
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _actionBtn(
              isActive ? LucideIcons.eyeOff : LucideIcons.eye,
              isActive ? 'marketplace.deactivate'.tr() : 'marketplace.activate'.tr(),
              isActive ? AppColors.warning : AppColors.success,
              () => _confirmToggleStatus(context, p),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      elevation: 0,
      shadowColor: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: color.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(7.r),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 16.sp),
                ),
                SizedBox(height: 5.h),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoGrid(BuildContext context, ProductEntity p) {
    final isOrganic = p.productMode == 'ORGANIC_PRODUCE';
    final typeLabel = (isOrganic
            ? (p.cropType ?? 'marketplace.badge_mode_organic'.tr())
            : p.biomassaType)
        .toUpperCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          p.name,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 6.w,
          runSpacing: 6.h,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
              decoration: BoxDecoration(
                color: isOrganic
                    ? AppColors.primaryLight.withOpacity(0.5)
                    : AppColors.primaryLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                typeLabel,
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w900,
                  color: isOrganic ? AppColors.secondary : AppColors.primary,
                ),
              ),
            ),
            _metaChip(
              LucideIcons.layers,
              'marketplace.grade_line'.tr(namedArgs: {'grade': p.grade ?? '-'}),
              AppColors.grey500,
            ),
            _metaChip(
              LucideIcons.mapPin,
              p.regency ?? p.province,
              AppColors.info,
            ),
          ],
        ),
        SizedBox(height: AppSpacing.sm),
        _dotRow('marketplace.created_at'.tr(namedArgs: {
          'date': context.formatDate(p.createdAt),
        })),
      ],
    );
  }

  Widget _metaChip(IconData icon, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11.sp, color: color),
          SizedBox(width: 4.w),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 160.w),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockGrid(BuildContext context, ProductEntity p) {
    final pricing = ProductPricingInfo.fromProduct(
      pricePerUnit: p.pricePerUnit,
      originalPrice: p.originalPrice,
      minOrder: p.minOrder,
      unit: p.unit,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: 6.h,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            Text(
              formatMoneyDisplay(pricing.pricePerUnit),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            Text(
              '/ ${p.unit}',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textHint,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (pricing.hasPromo) ...[
              Text(
                formatMoneyDisplay(pricing.originalPrice!),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.grey400,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Text(
                  '-${pricing.discountPercent}% / ${p.unit}',
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ],
        ),
        if (pricing.hasPromo) ...[
          SizedBox(height: 6.h),
          _buildPricingInfoBox(pricing),
        ],
        SizedBox(height: AppSpacing.sm10),
        Wrap(
          spacing: 6.w,
          runSpacing: 6.h,
          children: [
            _metaChip(
              LucideIcons.package,
              'marketplace.stock_chip'.tr(namedArgs: {
                'stock': '${p.stock.toInt()}',
                'unit': p.unit,
              }),
              AppColors.info,
            ),
            _metaChip(
              LucideIcons.shoppingCart,
              'marketplace.min_buy'.tr(namedArgs: {
                'qty': ProductPricingInfo.formatQty(p.minOrder),
                'unit': p.unit,
              }),
              AppColors.grey500,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPricingInfoBox(ProductPricingInfo pricing) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.sm10),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'marketplace.pricing_rules'.tr(),
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            pricing.promoRuleSummary,
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            pricing.exampleForQuantity(pricing.minOrder),
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dotRow(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: Row(children: [Container(width: 5.w, height: 5.w, decoration: BoxDecoration(color: AppColors.grey200, shape: BoxShape.circle)), SizedBox(width: AppSpacing.sm), Text(text, style: AppTextStyles.bodySecondary(color: AppColors.textSecondary))]),
    );
  }

  Widget _buildDescriptionBody(ProductEntity p) {
    return Text(
      p.description?.isNotEmpty == true ? p.description! : 'marketplace.no_description_short'.tr(),
      style: TextStyle(fontSize: 13.sp, color: p.description?.isNotEmpty == true ? AppColors.textSecondary : AppColors.textHint, height: 1.4),
    );
  }

  bool _hasSpecs(ProductEntity p) {
    return _specEntries(p).isNotEmpty;
  }

  ProductSpecsData _specsFromProduct(ProductEntity p) {
    return ProductSpecsData.fromProduct(p);
  }

  List<MapEntry<String, String>> _specEntries(ProductEntity p) {
    return _specsFromProduct(p).entriesForMode(p.productMode);
  }

  Widget _buildSpecsBody(ProductEntity p) {
    final entries = _specEntries(p);
    if (entries.isEmpty) return const SizedBox.shrink();
    return ProductSpecsKeyValueList(entries: entries);
  }

  Widget _buildStatsGrid(ProductEntity p, {ProductStatsEntity? stats}) {
    Widget row(List<Widget> cards) => Row(
          children: [
            for (int i = 0; i < cards.length; i++) ...[
              if (i > 0) SizedBox(width: AppSpacing.sm),
              Expanded(child: cards[i]),
            ],
          ],
        );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _hPad.w),
      child: Column(
        children: [
          row([
            _statCard(LucideIcons.eye, '${stats?.viewCount ?? 0}', 'marketplace.stat_views'.tr(), AppColors.info),
            _statCard(LucideIcons.shoppingBag, '${stats?.totalSold ?? p.totalSold}', 'marketplace.stat_sold'.tr(), AppColors.success),
            _statCard(LucideIcons.handshake, '${stats?.activeNegotiations ?? 0}', 'marketplace.stat_active_nego'.tr(), AppColors.warning),
          ]),
          SizedBox(height: AppSpacing.sm),
          row([
            _statCard(LucideIcons.star, '${p.averageRating}', 'marketplace.stat_rating'.tr(), AppColors.warning),
            _statCard(LucideIcons.package, '${p.stock.toInt()}', 'marketplace.stat_stock'.tr(), AppColors.primary),
            _statCard(
              p.isCertified ? LucideIcons.award : LucideIcons.shield,
              p.isCertified ? 'marketplace.yes'.tr() : 'marketplace.no'.tr(),
              'marketplace.badge_certified'.tr(),
              p.isCertified ? AppColors.success : AppColors.grey500,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildNegotiationsSection(BuildContext context, String productId) {
    return BlocBuilder<NegotiationCubit, NegotiationState>(
      builder: (context, state) {
        return state.maybeWhen(
          loading: () => _section(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
              child: const ShimmerListPlaceholder(itemCount: 2, itemHeight: 56),
            ),
          ),
          loaded: (negotiations) {
            final active = negotiations
                .where((n) =>
                    n.productId == productId &&
                    n.status.toUpperCase() == 'OPEN_NEGOTIATION')
                .toList();
            return _section(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _rowHeader('marketplace.active_negotiations'.tr(namedArgs: {
                    'count': '${active.length}',
                  })),
                  SizedBox(height: AppSpacing.sm),
                  if (active.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.md12),
                      child: Text(
                        'marketplace.no_active_negotiations'.tr(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textHint,
                        ),
                      ),
                    )
                  else
                    ...active.take(5).map((n) => _negotiationTile(context, n)),
                ],
              ),
            );
          },
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _negotiationTile(BuildContext context, NegotiationEntity n) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        onTap: () => NegotiationStatusDisplay.openFromList(context, n),
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          padding: EdgeInsets.all(AppSpacing.sm10),
          decoration: BoxDecoration(
            color: AppColors.grey50,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.grey100),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: AppRadius.xl,
                backgroundColor: AppColors.grey200,
                backgroundImage:
                    resolveMediaImageProvider(n.buyer.avatarUrl),
                child: n.buyer.avatarUrl == null
                    ? Icon(LucideIcons.user, size: 14.sp, color: AppColors.grey500)
                    : null,
              ),
              SizedBox(width: AppSpacing.sm10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      n.buyer.name,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${n.quantity.toInt()} ${n.product.unit} · ${formatMoneyDisplay(n.pricePerUnit)}',
                      style: AppTextStyles.caption(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Icon(LucideIcons.chevronRight, size: 16.sp, color: AppColors.grey300),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md12, horizontal: AppSpacing.xs),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: color.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 14.sp, color: color),
            ),
            SizedBox(height: 6.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              label,
              style: AppTextStyles.chip(fontSize: 9.sp, color: AppColors.textHint),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsSection(BuildContext context, ProductEntity p) {
    return BlocBuilder<ReviewCubit, ReviewState>(
      builder: (context, state) {
        return state.maybeWhen(
          loaded: (allReviews) {
            if (allReviews.isEmpty) {
              return _section(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _rowHeader('marketplace.reviews_section'.tr()),
                    SizedBox(height: AppSpacing.sm),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                        child: Column(
                          children: [
                            Icon(
                              LucideIcons.messageSquare,
                              size: 40.r,
                              color: AppColors.grey200,
                            ),
                            SizedBox(height: AppSpacing.sm),
                            Text(
                              'marketplace.no_reviews'.tr(),
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return _ReviewFilterSection(
              productId: productId,
              allReviews: allReviews,
              averageRating: p.averageRating,
              totalReviews: p.totalReviews,
            );
          },
          loading: () => _section(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
              child: const ShimmerListPlaceholder(itemCount: 2, itemHeight: 56),
            ),
          ),
          orElse: () => _section(
            child: Text(
              'marketplace.reviews_load_failed'.tr(),
              style: TextStyle(fontSize: 13.sp, color: AppColors.error),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDangerZone(BuildContext context, ProductEntity p) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _hPad.w),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.04),
          borderRadius: BorderRadius.circular(AppRadius.tile),
          border: Border.all(color: AppColors.error.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  LucideIcons.triangleAlert,
                  size: 18.sp,
                  color: AppColors.error,
                ),
                SizedBox(width: AppSpacing.sm),
                Text(
                  'marketplace.danger_zone'.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'marketplace.delete_permanent_warning'.tr(),
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            SizedBox(height: AppSpacing.md12),
            CustomButton(
              text: 'marketplace.delete_product'.tr(),
              height: 48.h,
              backgroundColor: AppColors.error,
              onPressed: () => _showDeleteDialog(context, p),
            ),
          ],
        ),
      ),
    );
  }

  // ── Edit Dialogs ──

  void _editTitle(BuildContext context, ProductEntity p) {
    final ctrl = TextEditingController(text: p.name);
    _showManagementEditDialog(
      context,
      title: 'marketplace.edit_product_title'.tr(),
      fields: [
        CustomTextField(
          label: 'marketplace.product_name_label'.tr(),
          hint: 'marketplace.product_name_hint'.tr(),
          controller: ctrl,
        ),
      ],
      onSave: () async {
        final error = await context.read<ProductManagementCubit>().updateField(
              p.id,
              {'name': ctrl.text.trim()},
            );
        if (error != null && context.mounted) {
          showFailureSnackBarFromMessage(context, error);
          return false;
        }
        return true;
      },
    );
  }

  void _editStock(BuildContext context, ProductEntity p) {
    final stockCtrl = TextEditingController(text: p.stock.toStringAsFixed(0));
    final minCtrl = TextEditingController(text: p.minOrder.toStringAsFixed(0));
    final priceCtrl = TextEditingController(text: p.pricePerUnit.toStringAsFixed(0));
    final originalCtrl = TextEditingController(
      text: p.originalPrice != null ? p.originalPrice!.toStringAsFixed(0) : '',
    );
    _showManagementEditDialog(
      context,
      title: 'marketplace.edit_stock_price'.tr(),
      scrollable: true,
      fields: [
        Container(
          padding: EdgeInsets.all(AppSpacing.sm10),
          decoration: BoxDecoration(
            color: AppColors.grey50,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.grey200),
          ),
          child: Text(
            'marketplace.promo_edit_hint'.tr(namedArgs: {'unit': p.unit}),
            style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary, height: 1.35),
          ),
        ),
        SizedBox(height: AppSpacing.md12),
        CustomTextField(
          label: 'marketplace.sell_price_per_unit'.tr(namedArgs: {'unit': p.unit}),
          hint: '0',
          controller: priceCtrl,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: AppSpacing.md12),
        CustomTextField(
          label: 'marketplace.strikethrough_price'.tr(namedArgs: {'unit': p.unit}),
          hint: 'marketplace.no_promo_hint'.tr(),
          controller: originalCtrl,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: AppSpacing.md12),
        CustomTextField(
          label: 'marketplace.stock_field'.tr(namedArgs: {'unit': p.unit}),
          hint: '0',
          controller: stockCtrl,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: AppSpacing.md12),
        CustomTextField(
          label: 'marketplace.min_purchase_field'.tr(namedArgs: {'unit': p.unit}),
          hint: '0',
          controller: minCtrl,
          keyboardType: TextInputType.number,
        ),
      ],
      onSave: () async {
        final data = <String, dynamic>{};
        final pr = double.tryParse(priceCtrl.text);
        final st = double.tryParse(stockCtrl.text);
        final mn = double.tryParse(minCtrl.text);
        if (pr != null) data['pricePerUnit'] = pr;
        if (st != null) data['stock'] = st;
        if (mn != null) data['minOrder'] = mn;

        final originalText = originalCtrl.text.trim();
        if (originalText.isEmpty) {
          data['originalPrice'] = '';
        } else {
          final orig = double.tryParse(originalText);
          if (orig != null) {
            if (pr != null && orig <= pr) {
              showErrorSnackBar(context, 'marketplace.strikethrough_must_exceed'.tr());
              return false;
            }
            data['originalPrice'] = orig;
          }
        }

        if (data.isEmpty) return true;

        final error = await context.read<ProductManagementCubit>().updateField(p.id, data);
        if (error != null && context.mounted) {
          showFailureSnackBarFromMessage(context, error);
          return false;
        }
        return true;
      },
    );
  }

  void _editDescription(BuildContext context, ProductEntity p) {
    final ctrl = TextEditingController(text: p.description ?? '');
    _showManagementEditDialog(
      context,
      title: 'marketplace.edit_description'.tr(),
      fields: [
        CustomTextField(
          label: 'marketplace.section_description'.tr(),
          hint: 'marketplace.description_hint'.tr(),
          controller: ctrl,
          maxLines: 5,
        ),
      ],
      onSave: () async {
        final error = await context.read<ProductManagementCubit>().updateField(
              p.id,
              {'description': ctrl.text.trim()},
            );
        if (error != null && context.mounted) {
          showFailureSnackBarFromMessage(context, error);
          return false;
        }
        return true;
      },
    );
  }

  void _editSpecs(BuildContext context, ProductEntity p) async {
    final result = await showProductSpecsSheet(
      context,
      productMode: p.productMode,
      initial: _specsFromProduct(p),
    );
    if (result == null || !context.mounted) return;

    final data = result.toApiPayload(p.productMode);
    final specs = data.remove('specs');
    data['specs'] = jsonEncode(specs ?? []);
    if (data.isNotEmpty) {
      final error = await context.read<ProductManagementCubit>().updateField(p.id, data);
      if (error != null && context.mounted) {
        showFailureSnackBarFromMessage(context, error);
      }
    }
  }

  void _confirmDuplicate(BuildContext context, ProductEntity p) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
        title: Text('marketplace.duplicate_confirm_title'.tr()),
        content: Text('marketplace.duplicate_confirm_body'.tr(namedArgs: {'name': p.name})),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('batal'.tr())),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ProductManagementCubit>().duplicateProduct(p.id);
            },
            child: Text('marketplace.duplicate'.tr(), style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _confirmToggleStatus(BuildContext context, ProductEntity p) {
    final isActive = p.status.toUpperCase() == 'ACTIVE';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isActive ? 'marketplace.deactivate_confirm_title'.tr() : 'marketplace.activate_confirm_title'.tr()),
        content: Text(isActive ? 'marketplace.deactivate_confirm_body'.tr() : 'marketplace.activate_confirm_body'.tr()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('batal'.tr())),
          TextButton(onPressed: () { Navigator.pop(ctx); context.read<ProductManagementCubit>().toggleStatus(p.id, p.status); }, child: Text(isActive ? 'marketplace.deactivate'.tr() : 'marketplace.activate'.tr(), style: TextStyle(color: isActive ? AppColors.warning : AppColors.success, fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, ProductEntity p) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('marketplace.delete_product'.tr()),
        content: Text('marketplace.delete_confirm_body'.tr(namedArgs: {'name': p.name})),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('batal'.tr())),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final error = await context.read<ProductManagementCubit>().deleteProduct(p.id);
              if (error != null && context.mounted) {
                showFailureSnackBarFromMessage(context, error);
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text('hapus'.tr(), style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

}

void _showManagementEditDialog(
  BuildContext context, {
  required String title,
  required List<Widget> fields,
  required Future<bool> Function() onSave,
  bool scrollable = false,
}) {
  showDialog(
    context: context,
    builder: (ctx) {
      final viewInsets = MediaQuery.viewInsetsOf(ctx);
      final screenH = MediaQuery.sizeOf(ctx).height;
      final maxDialogH = screenH - viewInsets.bottom - 48.h;

      return AnimatedPadding(
        padding: EdgeInsets.only(bottom: viewInsets.bottom),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxDialogH),
            child: Padding(
              padding: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.md),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.section),
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: fields,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  CustomButton(
                    text: 'marketplace.save'.tr(),
                    height: 46.h,
                    onPressed: () async {
                      if (await onSave() && ctx.mounted) Navigator.pop(ctx);
                    },
                  ),
                  SizedBox(height: AppSpacing.sm),
                  CustomButton(
                    text: 'batal'.tr(),
                    height: 46.h,
                    isOutlined: true,
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

// ── Product Image Carousel (dengan indikator titik) ──

class _ProductImageCarousel extends StatefulWidget {
  final List<String> images;
  const _ProductImageCarousel({required this.images});

  @override
  State<_ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<_ProductImageCarousel> {
  final PageController _controller = PageController();
  int _current = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.images;
    return SizedBox(
      height: 220.h,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            color: AppColors.grey100,
            child: images.isNotEmpty
                ? PageView.builder(
                    controller: _controller,
                    itemCount: images.length,
                    onPageChanged: (i) => setState(() => _current = i),
                    itemBuilder: (context, index) => BisaNetworkImage(
                      imageUrl: images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorWidget: (_, __, ___) =>
                          Container(color: AppColors.grey200),
                    ),
                  )
                : Center(
                    child: Icon(LucideIcons.image,
                        size: 48.sp, color: AppColors.grey400),
                  ),
          ),
          if (images.length > 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: AppSpacing.md12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    width: _current == i ? 18.w : 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      color: _current == i
                          ? AppColors.white
                          : AppColors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                  ),
                ),
              ),
            ),
          if (images.length > 1)
            Positioned(
              top: AppSpacing.md12,
              left: AppSpacing.md12,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.black.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  '${_current + 1}/${images.length}',
                  style: TextStyle(
                    color: AppColors.surface,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Review Filter Section ──

class _ReviewFilterSection extends StatefulWidget {
  final String productId;
  final List<ReviewModel> allReviews;
  final double averageRating;
  final int totalReviews;

  const _ReviewFilterSection({required this.productId, required this.allReviews, required this.averageRating, required this.totalReviews});

  @override
  State<_ReviewFilterSection> createState() => _ReviewFilterSectionState();
}

class _ReviewFilterSectionState extends State<_ReviewFilterSection> {
  int? _ratingFilter;
  bool _hasImageOnly = false;

  List<ReviewModel> get _filtered {
    var list = widget.allReviews;
    if (_ratingFilter != null) list = list.where((r) => r.rating.toInt() == _ratingFilter).toList();
    if (_hasImageOnly) list = list.where((r) => r.images != null && r.images!.isNotEmpty).toList();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final starCounts = <int, int>{5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final r in widget.allReviews) { final k = r.rating.toInt(); starCounts[k] = (starCounts[k] ?? 0) + 1; }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: ProductManagementDetailPage._hPad.w),
      padding: EdgeInsets.all(AppSpacing.md12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.grey100),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3.w,
                height: AppSpacing.section,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'marketplace.reviews_with_count'.tr(namedArgs: {
                    'count': '${widget.totalReviews}',
                  }),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.star,
                      color: AppColors.warning,
                      size: 14.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${widget.averageRating}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.section),

        // Rating bars
        ...starCounts.entries.map((e) => Padding(
          padding: EdgeInsets.only(bottom: 4.h),
          child: InkWell(
            onTap: () => setState(() => _ratingFilter = _ratingFilter == e.key ? null : e.key),
            child: Row(children: [
              SizedBox(width: 24.w, child: Text('${e.key}★', style: TextStyle(fontSize: 11.sp, color: _ratingFilter == e.key ? AppColors.primary : AppColors.textHint, fontWeight: _ratingFilter == e.key ? FontWeight.w800 : FontWeight.w500))),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2.r),
                  child: LinearProgressIndicator(
                    value: widget.totalReviews > 0
                        ? e.value / widget.totalReviews
                        : 0,
                    minHeight: 6.h,
                    backgroundColor: AppColors.grey100,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _ratingFilter == e.key
                          ? AppColors.primary
                          : AppColors.warning.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Text('${e.value}', style: TextStyle(fontSize: 10.sp, color: AppColors.textHint)),
            ]),
          ),
        )),
        SizedBox(height: AppSpacing.sm),

        // Filter chips
        Wrap(
          spacing: 6.w,
          runSpacing: 6.h,
          children: [
            _reviewChip(
              'marketplace.category_all'.tr(),
              _ratingFilter == null && !_hasImageOnly,
              () => setState(() {
                _ratingFilter = null;
                _hasImageOnly = false;
              }),
            ),
            ...List.generate(
              5,
              (i) => _reviewChip(
                '${5 - i}★',
                _ratingFilter == 5 - i,
                () => setState(
                  () => _ratingFilter =
                      _ratingFilter == 5 - i ? null : 5 - i,
                ),
              ),
            ),
            _reviewChip(
              'marketplace.filter_with_photo'.tr(),
              _hasImageOnly,
              () => setState(() => _hasImageOnly = !_hasImageOnly),
              icon: LucideIcons.image,
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md12),

        if (filtered.isEmpty)
          Padding(padding: EdgeInsets.symmetric(vertical: AppSpacing.lg), child: Center(child: Text('marketplace.no_reviews_filter'.tr(), style: AppTextStyles.bodySecondary(color: AppColors.textHint))))
        else
          ...filtered.take(10).map((r) => _buildReviewCard(r)),
        if (filtered.length > 10)
          Padding(
            padding: EdgeInsets.only(top: AppSpacing.sm),
            child: Center(
              child: TextButton(
                onPressed: () => context.push(
                  '/product-reviews/${widget.productId}',
                  extra: {'name': ''},
                ),
                child: Text(
                  'marketplace.view_all_reviews'.tr(namedArgs: {
                    'count': '${filtered.length}',
                  }),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewChip(
    String label,
    bool selected,
    VoidCallback onTap, {
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md12, vertical: AppSpacing.xs6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.grey50,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.grey200,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 12.sp,
                color: selected ? AppColors.white : AppColors.textSecondary,
              ),
              SizedBox(width: 4.w),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? AppColors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(ReviewModel r) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm10),
      padding: EdgeInsets.all(AppSpacing.md12),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: AppRadius.xl,
                backgroundColor: AppColors.grey200,
                backgroundImage:
                    resolveMediaImageProvider(r.userAvatar),
                child: r.userAvatar == null
                    ? Icon(LucideIcons.user, size: 14.sp, color: AppColors.grey500)
                    : null,
              ),
              SizedBox(width: AppSpacing.sm10),
              Expanded(
                child: Text(
                  r.userName,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < r.rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: i < r.rating
                        ? AppColors.warning
                        : AppColors.grey300,
                    size: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        if (r.comment.isNotEmpty) ...[SizedBox(height: 6.h), Text(r.comment, style: AppTextStyles.bodySecondary(color: AppColors.textSecondary), maxLines: 3, overflow: TextOverflow.ellipsis)],
        if (r.images != null && r.images!.isNotEmpty) ...[SizedBox(height: 6.h), SizedBox(height: 50.h, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: r.images!.length, separatorBuilder: (_, __) => SizedBox(width: 6.w), itemBuilder: (_, i) => ClipRRect(borderRadius: BorderRadius.circular(6.r), child: BisaNetworkImage(imageUrl: r.images![i], width: 50.w, height: 50.h, fit: BoxFit.cover))))],
        SizedBox(height: 4.h),
        Text(timeago.format(r.createdAt), style: AppTextStyles.chip(fontSize: 9.sp, color: AppColors.textHint)),
      ]),
    );
  }
}
