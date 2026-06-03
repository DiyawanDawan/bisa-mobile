import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/features/marketplace/domain/entities/product_entity.dart';
import 'package:mobile_bisa/features/marketplace/domain/entities/product_stats_entity.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/product_pricing.dart';
import '../../../../core/utils/extensions.dart';
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Produk berhasil dihapus'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            duplicated: (product) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Produk berhasil diduplikasi'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              context.pushReplacement('/product-manage/${product.id}');
            },
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            orElse: () {},
          );
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: BisaAppBar(
              title: 'Kelola Produk',
              backgroundColor: AppColors.surface,
            ),
            body: state.maybeWhen(
              loading: () => const ShimmerProductDetailPlaceholder(),
              error: (message) => Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.triangleAlert,
                        size: 64.r,
                        color: AppColors.grey200,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      TextButton(
                        onPressed: () => context
                            .read<ProductManagementCubit>()
                            .getProductDetail(productId),
                        child: const Text('Coba Lagi'),
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
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.shieldOff, size: 64.r, color: AppColors.grey200),
            SizedBox(height: 16.h),
            Text(
              'Akses Ditolak',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Anda tidak memiliki akses untuk mengelola produk ini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            SizedBox(height: 20.h),
            CustomButton(
              text: 'Kembali',
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
          _section(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _rowHeader('Informasi Produk', onEdit: () => _editTitle(context, p)),
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
                _rowHeader('Stok & Harga', onEdit: () => _editStock(context, p)),
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
                _rowHeader('Deskripsi', onEdit: () => _editDescription(context, p)),
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
                  _rowHeader('Spesifikasi', onEdit: () => _editSpecs(context, p)),
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
                  _rowHeader('Spesifikasi', onEdit: () => _editSpecs(context, p)),
                  SizedBox(height: 6.h),
                  Text(
                    'Belum ada spesifikasi — tap edit untuk menambahkan',
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
          SizedBox(height: 16.h),
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
          height: 14.h,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),
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
            borderRadius: BorderRadius.circular(8.r),
            child: InkWell(
              onTap: onEdit,
              borderRadius: BorderRadius.circular(8.r),
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
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
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
      padding: EdgeInsets.fromLTRB(_hPad.w, 10.h, _hPad.w, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Stack(
          children: [
            _ProductImageCarousel(images: images),
            Positioned(
              top: 12.h,
              right: 12.w,
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
                          Colors.black.withOpacity(0.35),
                          Colors.transparent,
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
        borderRadius: BorderRadius.circular(8.r),
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
        label = 'Aktif';
        break;
      case 'DRAFT':
        color = AppColors.warning;
        label = 'Draft';
        break;
      case 'OUT_OF_STOCK':
        color = AppColors.error;
        label = 'Stok Habis';
        break;
      case 'INACTIVE':
        color = AppColors.grey500;
        label = 'Non-aktif';
        break;
      default:
        color = AppColors.grey500;
        label = status;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.92),
        borderRadius: BorderRadius.circular(8.r),
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

  Widget _buildQuickActions(BuildContext context, ProductEntity p) {
    final isActive = p.status.toUpperCase() == 'ACTIVE';
    return Padding(
      padding: EdgeInsets.fromLTRB(_hPad.w, 10.h, _hPad.w, 6.h),
      child: Row(
        children: [
          Expanded(
            child: _actionBtn(
              LucideIcons.pencil,
              'Edit',
              AppColors.primary,
              () => context.push('/edit-product', extra: p),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _actionBtn(
              LucideIcons.copy,
              'Duplikat',
              AppColors.info,
              () => _confirmDuplicate(context, p),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _actionBtn(
              isActive ? LucideIcons.eyeOff : LucideIcons.eye,
              isActive ? 'Nonaktif' : 'Aktifkan',
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
      borderRadius: BorderRadius.circular(12.r),
      elevation: 0,
      shadowColor: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: color.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
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
            ? (p.cropType ?? 'Hasil Tani')
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
        SizedBox(height: 8.h),
        Wrap(
          spacing: 6.w,
          runSpacing: 6.h,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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
              'Grade: ${p.grade ?? '-'}',
              AppColors.grey500,
            ),
            _metaChip(
              LucideIcons.mapPin,
              p.regency ?? p.province,
              AppColors.info,
            ),
          ],
        ),
        SizedBox(height: 8.h),
        _dotRow('Dibuat: ${_formatDate(p.createdAt)}'),
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
          spacing: 8.w,
          runSpacing: 6.h,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            Text(
              pricing.pricePerUnit.toRupiah,
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
                pricing.originalPrice!.toRupiah,
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
        SizedBox(height: 10.h),
        Wrap(
          spacing: 6.w,
          runSpacing: 6.h,
          children: [
            _metaChip(
              LucideIcons.package,
              'Stok ${p.stock.toInt()} ${p.unit}',
              AppColors.info,
            ),
            _metaChip(
              LucideIcons.shoppingCart,
              'Min. beli ${ProductPricingInfo.formatQty(p.minOrder)} ${p.unit}',
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
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aturan harga',
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
      child: Row(children: [Container(width: 5.w, height: 5.w, decoration: BoxDecoration(color: AppColors.grey200, shape: BoxShape.circle)), SizedBox(width: 8.w), Text(text, style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary))]),
    );
  }

  Widget _buildDescriptionBody(ProductEntity p) {
    return Text(
      p.description?.isNotEmpty == true ? p.description! : 'Belum ada deskripsi',
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
              if (i > 0) SizedBox(width: 8.w),
              Expanded(child: cards[i]),
            ],
          ],
        );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _hPad.w),
      child: Column(
        children: [
          row([
            _statCard(LucideIcons.eye, '${stats?.viewCount ?? 0}', 'Dilihat', AppColors.info),
            _statCard(LucideIcons.shoppingBag, '${stats?.totalSold ?? p.totalSold}', 'Terjual', AppColors.success),
            _statCard(LucideIcons.handshake, '${stats?.activeNegotiations ?? 0}', 'Nego Aktif', AppColors.warning),
          ]),
          SizedBox(height: 8.h),
          row([
            _statCard(LucideIcons.star, '${p.averageRating}', 'Rating', AppColors.warning),
            _statCard(LucideIcons.package, '${p.stock.toInt()}', 'Stok', AppColors.primary),
            _statCard(
              p.isCertified ? LucideIcons.award : LucideIcons.shield,
              p.isCertified ? 'Ya' : 'Tidak',
              'Certified',
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
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
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
                  _rowHeader('Negosiasi Aktif (${active.length})'),
                  SizedBox(height: 8.h),
                  if (active.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Text(
                        'Belum ada negosiasi aktif untuk produk ini',
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
      padding: EdgeInsets.only(bottom: 8.h),
      child: InkWell(
        onTap: () => NegotiationStatusDisplay.openFromList(context, n),
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: AppColors.grey50,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.grey100),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16.r,
                backgroundColor: AppColors.grey200,
                backgroundImage:
                    resolveMediaImageProvider(n.buyer.avatarUrl),
                child: n.buyer.avatarUrl == null
                    ? Icon(LucideIcons.user, size: 14.sp, color: AppColors.grey500)
                    : null,
              ),
              SizedBox(width: 10.w),
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
                      '${n.quantity.toInt()} ${n.product.unit} · ${n.pricePerUnit.toRupiah}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                      ),
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
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
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
              style: TextStyle(fontSize: 9.sp, color: AppColors.textHint),
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
                    _rowHeader('Ulasan'),
                    SizedBox(height: 8.h),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Column(
                          children: [
                            Icon(
                              LucideIcons.messageSquare,
                              size: 40.r,
                              color: AppColors.grey200,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Belum ada ulasan',
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
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              child: const ShimmerListPlaceholder(itemCount: 2, itemHeight: 56),
            ),
          ),
          orElse: () => _section(
            child: Text(
              'Gagal memuat ulasan',
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
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.04),
          borderRadius: BorderRadius.circular(14.r),
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
                SizedBox(width: 8.w),
                Text(
                  'Zona Berbahaya',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              'Menghapus produk bersifat permanen dan tidak dapat dibatalkan.',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            SizedBox(height: 12.h),
            CustomButton(
              text: 'Hapus Produk',
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
      title: 'Edit Judul Produk',
      fields: [
        CustomTextField(
          label: 'Nama Produk',
          hint: 'Masukkan nama produk',
          controller: ctrl,
        ),
      ],
      onSave: () async {
        final error = await context.read<ProductManagementCubit>().updateField(
              p.id,
              {'name': ctrl.text.trim()},
            );
        if (error != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
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
      title: 'Edit Stok & Harga',
      scrollable: true,
      fields: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: AppColors.grey50,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.grey200),
          ),
          child: Text(
            'Diskon promo = per 1 ${p.unit}. Total order = qty × harga jual. '
            'Min. order terpisah — bukan diskon bertingkat (2 ${p.unit} ≠ 20% + 20%).',
            style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary, height: 1.35),
          ),
        ),
        SizedBox(height: 12.h),
        CustomTextField(
          label: 'Harga jual per ${p.unit}',
          hint: '0',
          controller: priceCtrl,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 12.h),
        CustomTextField(
          label: 'Harga coret per ${p.unit} (opsional)',
          hint: 'Kosongkan jika tanpa promo',
          controller: originalCtrl,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 12.h),
        CustomTextField(
          label: 'Stok (${p.unit})',
          hint: '0',
          controller: stockCtrl,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 12.h),
        CustomTextField(
          label: 'Minimal pembelian (${p.unit})',
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Harga coret harus lebih tinggi dari harga jual'),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              return false;
            }
            data['originalPrice'] = orig;
          }
        }

        if (data.isEmpty) return true;

        final error = await context.read<ProductManagementCubit>().updateField(p.id, data);
        if (error != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
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
      title: 'Edit Deskripsi',
      fields: [
        CustomTextField(
          label: 'Deskripsi',
          hint: 'Deskripsi produk',
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _confirmDuplicate(BuildContext context, ProductEntity p) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: const Text('Duplikat Produk?'),
        content: Text('Salin "${p.name}" sebagai produk baru (status Draft)?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ProductManagementCubit>().duplicateProduct(p.id);
            },
            child: Text('Duplikat', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
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
        title: Text(isActive ? 'Nonaktifkan Produk?' : 'Aktifkan Produk?'),
        content: Text(isActive ? 'Produk tidak akan muncul di marketplace.' : 'Produk akan muncul kembali di marketplace.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(onPressed: () { Navigator.pop(ctx); context.read<ProductManagementCubit>().toggleStatus(p.id, p.status); }, child: Text(isActive ? 'Nonaktifkan' : 'Aktifkan', style: TextStyle(color: isActive ? AppColors.warning : AppColors.success, fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, ProductEntity p) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Produk'),
        content: Text('Hapus "${p.name}"? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final error = await context.read<ProductManagementCubit>().deleteProduct(p.id);
              if (error != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error),
                    backgroundColor: AppColors.error,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Hapus', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) { const m = ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des']; return '${date.day} ${m[date.month-1]} ${date.year}'; }
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
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxDialogH),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
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
                  SizedBox(height: 14.h),
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
                  SizedBox(height: 16.h),
                  CustomButton(
                    text: 'Simpan',
                    height: 46.h,
                    onPressed: () async {
                      if (await onSave() && ctx.mounted) Navigator.pop(ctx);
                    },
                  ),
                  SizedBox(height: 8.h),
                  CustomButton(
                    text: 'Batal',
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
              bottom: 12.h,
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
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                  ),
                ),
              ),
            ),
          if (images.length > 1)
            Positioned(
              top: 12.h,
              left: 12.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${_current + 1}/${images.length}',
                  style: TextStyle(
                    color: Colors.white,
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
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
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
                height: 14.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Ulasan (${widget.totalReviews})',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
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
          SizedBox(height: 14.h),

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
              SizedBox(width: 8.w),
              Text('${e.value}', style: TextStyle(fontSize: 10.sp, color: AppColors.textHint)),
            ]),
          ),
        )),
        SizedBox(height: 8.h),

        // Filter chips
        Wrap(
          spacing: 6.w,
          runSpacing: 6.h,
          children: [
            _reviewChip(
              'Semua',
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
              'Ada Foto',
              _hasImageOnly,
              () => setState(() => _hasImageOnly = !_hasImageOnly),
              icon: LucideIcons.image,
            ),
          ],
        ),
        SizedBox(height: 12.h),

        if (filtered.isEmpty)
          Padding(padding: EdgeInsets.symmetric(vertical: 20.h), child: Center(child: Text('Tidak ada ulasan dengan filter ini', style: TextStyle(fontSize: 12.sp, color: AppColors.textHint))))
        else
          ...filtered.take(10).map((r) => _buildReviewCard(r)),
        if (filtered.length > 10)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Center(
              child: TextButton(
                onPressed: () => context.push(
                  '/product-reviews/${widget.productId}',
                  extra: {'name': ''},
                ),
                child: Text(
                  'Lihat semua ${filtered.length} ulasan',
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
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.grey50,
          borderRadius: BorderRadius.circular(20.r),
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
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16.r,
                backgroundColor: AppColors.grey200,
                backgroundImage:
                    resolveMediaImageProvider(r.userAvatar),
                child: r.userAvatar == null
                    ? Icon(LucideIcons.user, size: 14.sp, color: AppColors.grey500)
                    : null,
              ),
              SizedBox(width: 10.w),
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
        if (r.comment.isNotEmpty) ...[SizedBox(height: 6.h), Text(r.comment, style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary), maxLines: 3, overflow: TextOverflow.ellipsis)],
        if (r.images != null && r.images!.isNotEmpty) ...[SizedBox(height: 6.h), SizedBox(height: 50.h, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: r.images!.length, separatorBuilder: (_, __) => SizedBox(width: 6.w), itemBuilder: (_, i) => ClipRRect(borderRadius: BorderRadius.circular(6.r), child: BisaNetworkImage(imageUrl: r.images![i], width: 50.w, height: 50.h, fit: BoxFit.cover))))],
        SizedBox(height: 4.h),
        Text(timeago.format(r.createdAt), style: TextStyle(fontSize: 9.sp, color: AppColors.textHint)),
      ]),
    );
  }
}
