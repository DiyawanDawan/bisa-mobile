import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/readiness/readiness_gate.dart';
import '../../../../core/utils/money_format.dart';
import '../../../../core/utils/media_url_utils.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/product_entity.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../profile/presentation/bloc/profile_cubit.dart';
import '../bloc/marketplace_cubit.dart';
import '../bloc/store_banner_cubit.dart';
import '../widgets/store_banner_section.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import '../../../../shared/widgets/supplier_3d_widgets.dart';
import '../../../../shared/widgets/notification_bell_button.dart';

class SupplierStorePage extends StatelessWidget {
  const SupplierStorePage({super.key});

  static const _previewLimit = 4;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().state.maybeWhen(
      authenticated: (u) => u,
      orElse: () => null,
    );

    if (user == null) {
      return Scaffold(
        appBar: BisaAppBar(title: 'marketplace.store_management_title'.tr()),
        body: Center(child: Text('marketplace.login_required'.tr())),
      );
    }

    return BlocProvider(
      create: (_) => sl<ProfileCubit>()..getProfile(),
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          state.maybeWhen(
            success: (_) {
              context.read<ProfileCubit>().getProfile();
              context.read<AuthCubit>().checkAuth();
            },
            orElse: () {},
          );
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, profileState) {
            final storeUser = profileState.maybeWhen(
              loaded: (u) => u,
              orElse: () => user,
            );

            return BlocProvider(
              create: (_) =>
                  sl<MarketplaceCubit>()..getProducts(userId: storeUser.id, limit: 100),
              child: BlocProvider(
                create: (_) => sl<StoreBannerCubit>()..loadMyBanners(),
                child: _StoreManagementBody(
                  user: storeUser,
                  previewLimit: _previewLimit,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StoreManagementBody extends StatelessWidget {
  const _StoreManagementBody({
    required this.user,
    required this.previewLimit,
  });

  final UserEntity user;
  final int previewLimit;

  String get _storeDisplayName => user.companyName ?? user.name;

  Future<void> _openEditProfile(BuildContext context) async {
    await context.push('/edit-profile', extra: user);
    if (!context.mounted) return;
    context.read<ProfileCubit>().getProfile();
    context.read<AuthCubit>().checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        backgroundColor: AppColors.surface,
        title: 'marketplace.store_management_title'.tr(),
        actions: const [NotificationBellButton()],
      ),
      body: BlocBuilder<MarketplaceCubit, MarketplaceState>(
        builder: (context, state) {
          final products = state.maybeWhen<List<ProductEntity>>(
            loaded: (items, _) => items,
            orElse: () => <ProductEntity>[],
          );
          final isLoading = state.maybeWhen(
            loading: () => true,
            orElse: () => false,
          );

          return RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                context.read<MarketplaceCubit>().getProducts(
                  userId: user.id,
                  limit: 100,
                ),
                context.read<StoreBannerCubit>().loadMyBanners(),
                context.read<ProfileCubit>().getProfile(),
              ]);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StoreBannerSection(),
                  SizedBox(height: AppSpacing.sm10),
                  _StoreHeader(
                    user: user,
                    onEdit: () => _openEditProfile(context),
                  ),
                  SizedBox(height: AppSpacing.md12),
                  _StoreStats(products: products, isLoading: isLoading),
                  SizedBox(height: AppSpacing.section),
                  _StoreProductPreview(
                    products: products,
                    isLoading: isLoading,
                    previewLimit: previewLimit,
                    onViewAll: () => context.push('/product-management'),
                    onProductTap: (product) =>
                        context.push('/product-manage/${product.id}'),
                  ),
                  SizedBox(height: AppSpacing.section),
                  Supplier3DSectionCard(
                    title: 'marketplace.store_section_manage'.tr(),
                    child: Column(
                      children: [
                        Supplier3DMenuTile(
                          icon: LucideIcons.pencil,
                          title: 'marketplace.store_edit_profile'.tr(),
                          subtitle: 'marketplace.store_edit_profile_sub'.tr(),
                          color: AppColors.primaryDark,
                          onTap: () => _openEditProfile(context),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Supplier3DMenuTile(
                          icon: LucideIcons.package,
                          title: 'marketplace.store_manage_products'.tr(),
                          subtitle: 'marketplace.store_manage_products_sub'.tr(),
                          color: AppColors.primary,
                          onTap: () => context.push('/product-management'),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Supplier3DMenuTile(
                          icon: LucideIcons.plus,
                          title: 'marketplace.add_product'.tr(),
                          subtitle: 'marketplace.store_add_product_sub'.tr(),
                          color: AppColors.success,
                          onTap: () => ReadinessGate.pushAddProduct(context),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Supplier3DMenuTile(
                          icon: LucideIcons.eye,
                          title: 'marketplace.store_preview_public'.tr(),
                          subtitle: 'marketplace.store_preview_public_sub'.tr(),
                          color: AppColors.grey600,
                          onTap: () => context.push(
                            '/supplier/${user.id}',
                            extra: {'name': _storeDisplayName, 'preview': true},
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.section),
                  Supplier3DSectionCard(
                    title: 'marketplace.store_section_business'.tr(),
                    child: Column(
                      children: [
                        Supplier3DMenuTile(
                          icon: LucideIcons.chartBar,
                          title: 'marketplace.store_sales_analytics'.tr(),
                          subtitle: 'marketplace.store_sales_analytics_sub'.tr(),
                          color: AppColors.info,
                          onTap: () => context.push('/sales-analytics'),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Supplier3DMenuTile(
                          icon: LucideIcons.heart,
                          title: 'marketplace.action_product_engagement'.tr(),
                          subtitle: 'marketplace.store_engagement_sub'.tr(),
                          color: AppColors.error,
                          onTap: () => context.push('/product-engagement'),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Supplier3DMenuTile(
                          icon: LucideIcons.wallet,
                          title: 'marketplace.store_wallet'.tr(),
                          subtitle: 'marketplace.store_wallet_sub'.tr(),
                          color: AppColors.warning,
                          onTap: () => context.push('/wallet'),
                        ),
                      ],
                    ),
                  ),
                  if (!user.isVerified) ...[
                    SizedBox(height: AppSpacing.section),
                    _VerificationBanner(
                      onTap: () => context.push('/verification'),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StoreHeader extends StatelessWidget {
  const _StoreHeader({
    required this.user,
    required this.onEdit,
  });

  final UserEntity user;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final storeName = user.companyName ?? user.name;
    final hasStoreName =
        user.companyName != null && user.companyName!.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white.withOpacity(0.4), width: 2),
            ),
            child: CircleAvatar(
              radius: AppSpacing.xxlPx.r,
              backgroundColor: AppColors.surface.withOpacity(0.2),
              backgroundImage: resolveMediaImageProvider(user.avatar),
              child: user.avatar == null
                  ? Icon(LucideIcons.store, color: AppColors.textOnPrimary, size: 28.sp)
                  : null,
            ),
          ),
          SizedBox(width: AppSpacing.section),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  storeName,
                  style: TextStyle(
                    color: AppColors.surface,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  hasStoreName
                      ? 'marketplace.store_owner'.tr(namedArgs: {'name': user.name})
                      : user.email,
                  style: TextStyle(
                    color: AppColors.textOnPrimary.withOpacity(0.85),
                    fontSize: 12.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (!hasStoreName) ...[
                  SizedBox(height: 6.h),
                  Text(
                    'marketplace.store_name_hint'.tr(),
                    style: TextStyle(
                      color: AppColors.textOnPrimary.withOpacity(0.75),
                      fontSize: 11.sp,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: 6.w,
                  runSpacing: 6.h,
                  children: [
                    _HeaderBadge(
                      icon: user.isVerified
                          ? LucideIcons.badgeCheck
                          : LucideIcons.shieldAlert,
                      label: user.isVerified
                          ? 'marketplace.verified'.tr()
                          : 'marketplace.not_verified'.tr(),
                      filled: user.isVerified,
                    ),
                    _HeaderBadge(
                      icon: LucideIcons.calendar,
                      label:
                          'marketplace.joined'.tr(namedArgs: {
                            'date': DateFormat('MMM yyyy').format(user.createdAt),
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Material(
            color: AppColors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: InkWell(
              onTap: onEdit,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.sm10),
                child: Icon(
                  LucideIcons.pencil,
                  color: AppColors.surface,
                  size: 18.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderBadge extends StatelessWidget {
  const _HeaderBadge({
    required this.icon,
    required this.label,
    this.filled = false,
  });

  final IconData icon;
  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: filled
            ? AppColors.white.withOpacity(0.25)
            : AppColors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppRadius.button),
        border: Border.all(color: AppColors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: AppColors.white),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              color: AppColors.surface,
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreStats extends StatelessWidget {
  const _StoreStats({required this.products, required this.isLoading});

  final List<ProductEntity> products;
  final bool isLoading;

  int _count(String status) =>
      products.where((p) => p.status.toUpperCase() == status).length;

  @override
  Widget build(BuildContext context) {
    final total = products.length;
    final active = _count('ACTIVE');
    final draft = _count('DRAFT');
    final outOfStock = _count('OUT_OF_STOCK');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'marketplace.product_summary'.tr(),
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSpacing.sm10),
        if (isLoading && products.isEmpty)
          const Center(child: ShimmerListPlaceholder(itemCount: 3, itemHeight: 72))
        else
          Row(
            children: [
              Expanded(
                child: Supplier3DStatCard(
                  label: 'marketplace.stat_total'.tr(),
                  value: '$total',
                  color: AppColors.primary,
                  icon: LucideIcons.layers,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Supplier3DStatCard(
                  label: 'marketplace.stat_active'.tr(),
                  value: '$active',
                  color: AppColors.success,
                  icon: LucideIcons.circleCheck,
                ),
              ),
            ],
          ),
        if (!isLoading || products.isNotEmpty) ...[
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Supplier3DStatCard(
                  label: 'marketplace.stat_draft'.tr(),
                  value: '$draft',
                  color: AppColors.warning,
                  icon: LucideIcons.filePen,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Supplier3DStatCard(
                  label: 'marketplace.stat_out_of_stock'.tr(),
                  value: '$outOfStock',
                  color: AppColors.error,
                  icon: LucideIcons.packageX,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _StoreProductPreview extends StatelessWidget {
  const _StoreProductPreview({
    required this.products,
    required this.isLoading,
    required this.previewLimit,
    required this.onViewAll,
    required this.onProductTap,
  });

  final List<ProductEntity> products;
  final bool isLoading;
  final int previewLimit;
  final VoidCallback onViewAll;
  final ValueChanged<ProductEntity> onProductTap;

  @override
  Widget build(BuildContext context) {
    final preview = products.take(previewLimit).toList();
    final hasMore = products.length > previewLimit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'marketplace.store_products'.tr(),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (products.isNotEmpty)
              TextButton(
                onPressed: onViewAll,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  hasMore
                      ? 'marketplace.view_all_products'.tr()
                      : 'marketplace.manage_products_link'.tr(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 6.h),
        if (isLoading && products.isEmpty)
          const Center(child: ShimmerListPlaceholder(itemCount: 3, itemHeight: 72))
        else if (products.isEmpty)
          _EmptyProducts(onAdd: () => ReadinessGate.pushAddProduct(context))
        else
          Column(
            children: [
              for (int i = 0; i < preview.length; i++) ...[
                if (i > 0) SizedBox(height: 6.h),
                _ProductPreviewTile(
                  product: preview[i],
                  onTap: () => onProductTap(preview[i]),
                ),
              ],
            ],
          ),
      ],
    );
  }
}

class _ProductPreviewTile extends StatelessWidget {
  const _ProductPreviewTile({required this.product, required this.onTap});

  final ProductEntity product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: EdgeInsets.all(AppSpacing.sm10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.grey100),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.button),
                child: product.thumbnailUrl != null &&
                        product.thumbnailUrl!.isNotEmpty
                    ? BisaNetworkImage(
                        imageUrl: product.thumbnailUrl,
                        width: 52.w,
                        height: 52.w,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => _thumbPlaceholder(),
                      )
                    : _thumbPlaceholder(),
              ),
              SizedBox(width: AppSpacing.sm10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      formatMoneyDisplay(product.pricePerUnit),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'marketplace.stock_line'.tr(namedArgs: {
                        'stock': product.stock.toStringAsFixed(0),
                        'unit': product.unit,
                      }),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                size: 16.sp,
                color: AppColors.grey400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _thumbPlaceholder() {
    return Container(
      width: 52.w,
      height: 52.w,
      color: AppColors.grey100,
      child: Icon(LucideIcons.package, size: 20.sp, color: AppColors.grey300),
    );
  }
}

class _EmptyProducts extends StatelessWidget {
  const _EmptyProducts({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        children: [
          Icon(LucideIcons.packageOpen, size: 32.sp, color: AppColors.grey300),
          SizedBox(height: AppSpacing.sm),
          Text(
            'marketplace.no_products_yet'.tr(),
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: onAdd,
            child: Text('marketplace.add_product'.tr()),
          ),
        ],
      ),
    );
  }
}

class _VerificationBanner extends StatelessWidget {
  const _VerificationBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.warning.withOpacity(0.1),
      borderRadius: BorderRadius.circular(AppRadius.tile),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.section),
          child: Row(
            children: [
              Icon(LucideIcons.shieldAlert, color: AppColors.warning, size: 22.sp),
              SizedBox(width: AppSpacing.md12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'marketplace.verify_store_title'.tr(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'marketplace.verify_store_body'.tr(),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(LucideIcons.chevronRight, color: AppColors.warning, size: 18.sp),
            ],
          ),
        ),
      ),
    );
  }
}
