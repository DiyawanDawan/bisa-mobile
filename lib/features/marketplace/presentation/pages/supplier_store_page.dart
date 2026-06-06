import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/readiness/readiness_gate.dart';
import '../../../../core/utils/extensions.dart';
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
        appBar: BisaAppBar(title: 'Manajemen Toko'),
        body: const Center(child: Text('Silakan masuk terlebih dahulu')),
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
        title: 'Manajemen Toko',
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
                  SizedBox(height: 10.h),
                  _StoreHeader(
                    user: user,
                    onEdit: () => _openEditProfile(context),
                  ),
                  SizedBox(height: 12.h),
                  _StoreStats(products: products, isLoading: isLoading),
                  SizedBox(height: 14.h),
                  _StoreProductPreview(
                    products: products,
                    isLoading: isLoading,
                    previewLimit: previewLimit,
                    onViewAll: () => context.push('/product-management'),
                    onProductTap: (product) =>
                        context.push('/product-manage/${product.id}'),
                  ),
                  SizedBox(height: 14.h),
                  Supplier3DSectionCard(
                    title: 'Kelola Toko',
                    child: Column(
                      children: [
                        Supplier3DMenuTile(
                          icon: LucideIcons.pencil,
                          title: 'Ubah Nama & Profil Toko',
                          subtitle: 'Nama toko, foto profil, dan nomor telepon',
                          color: AppColors.primaryDark,
                          onTap: () => _openEditProfile(context),
                        ),
                        SizedBox(height: 8.h),
                        Supplier3DMenuTile(
                          icon: LucideIcons.package,
                          title: 'Kelola Produk',
                          subtitle: 'Atur daftar, stok, dan status produk',
                          color: AppColors.primary,
                          onTap: () => context.push('/product-management'),
                        ),
                        SizedBox(height: 8.h),
                        Supplier3DMenuTile(
                          icon: LucideIcons.plus,
                          title: 'Tambah Produk',
                          subtitle: 'Publikasikan produk baru ke marketplace',
                          color: AppColors.success,
                          onTap: () => ReadinessGate.pushAddProduct(context),
                        ),
                        SizedBox(height: 8.h),
                        Supplier3DMenuTile(
                          icon: LucideIcons.eye,
                          title: 'Pratinjau Toko Publik',
                          subtitle: 'Lihat tampilan toko seperti pembeli',
                          color: AppColors.grey600,
                          onTap: () => context.push(
                            '/supplier/${user.id}',
                            extra: {'name': _storeDisplayName, 'preview': true},
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Supplier3DSectionCard(
                    title: 'Kelola Bisnis',
                    child: Column(
                      children: [
                        Supplier3DMenuTile(
                          icon: LucideIcons.chartBar,
                          title: 'Analitik Penjualan',
                          subtitle: 'Pantau performa dan tren penjualan',
                          color: AppColors.info,
                          onTap: () => context.push('/sales-analytics'),
                        ),
                        SizedBox(height: 8.h),
                        Supplier3DMenuTile(
                          icon: LucideIcons.heart,
                          title: 'Minat Produk',
                          subtitle: 'Produk disukai & di keranjang pembeli',
                          color: AppColors.error,
                          onTap: () => context.push('/product-engagement'),
                        ),
                        SizedBox(height: 8.h),
                        Supplier3DMenuTile(
                          icon: LucideIcons.wallet,
                          title: 'Dompet BISA',
                          subtitle: 'Saldo, penarikan, dan riwayat transaksi',
                          color: AppColors.warning,
                          onTap: () => context.push('/wallet'),
                        ),
                      ],
                    ),
                  ),
                  if (!user.isVerified) ...[
                    SizedBox(height: 14.h),
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
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20.r),
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
              border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
            ),
            child: CircleAvatar(
              radius: 32.r,
              backgroundColor: Colors.white.withOpacity(0.2),
              backgroundImage: resolveMediaImageProvider(user.avatar),
              child: user.avatar == null
                  ? Icon(LucideIcons.store, color: Colors.white, size: 28.sp)
                  : null,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  storeName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  hasStoreName ? 'Pemilik: ${user.name}' : user.email,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (!hasStoreName) ...[
                  SizedBox(height: 6.h),
                  Text(
                    'Atur nama toko agar tampil di marketplace',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 11.sp,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 6.w,
                  runSpacing: 6.h,
                  children: [
                    _HeaderBadge(
                      icon: user.isVerified
                          ? LucideIcons.badgeCheck
                          : LucideIcons.shieldAlert,
                      label: user.isVerified ? 'Terverifikasi' : 'Belum Verifikasi',
                      filled: user.isVerified,
                    ),
                    _HeaderBadge(
                      icon: LucideIcons.calendar,
                      label:
                          'Bergabung ${DateFormat('MMM yyyy').format(user.createdAt)}',
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Material(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(12.r),
            child: InkWell(
              onTap: onEdit,
              borderRadius: BorderRadius.circular(12.r),
              child: Padding(
                padding: EdgeInsets.all(10.r),
                child: Icon(
                  LucideIcons.pencil,
                  color: Colors.white,
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
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: filled
            ? Colors.white.withOpacity(0.25)
            : Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: Colors.white),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
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
          'Ringkasan Produk',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 10.h),
        if (isLoading && products.isEmpty)
          const Center(child: ShimmerListPlaceholder(itemCount: 3, itemHeight: 72))
        else
          Row(
            children: [
              Expanded(
                child: Supplier3DStatCard(
                  label: 'Total',
                  value: '$total',
                  color: AppColors.primary,
                  icon: LucideIcons.layers,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Supplier3DStatCard(
                  label: 'Aktif',
                  value: '$active',
                  color: AppColors.success,
                  icon: LucideIcons.circleCheck,
                ),
              ),
            ],
          ),
        if (!isLoading || products.isNotEmpty) ...[
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: Supplier3DStatCard(
                  label: 'Draft',
                  value: '$draft',
                  color: AppColors.warning,
                  icon: LucideIcons.filePen,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Supplier3DStatCard(
                  label: 'Stok Habis',
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
                'Produk Toko',
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
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  hasMore ? 'Lihat semua produk' : 'Kelola produk',
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
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.grey100),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
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
              SizedBox(width: 10.w),
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
                      product.pricePerUnit.toRupiah,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Stok ${product.stock.toStringAsFixed(0)} ${product.unit}',
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
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        children: [
          Icon(LucideIcons.packageOpen, size: 32.sp, color: AppColors.grey300),
          SizedBox(height: 8.h),
          Text(
            'Belum ada produk',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          TextButton(onPressed: onAdd, child: const Text('Tambah Produk')),
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
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.all(14.r),
          child: Row(
            children: [
              Icon(LucideIcons.shieldAlert, color: AppColors.warning, size: 22.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verifikasi Toko',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Lengkapi verifikasi agar toko lebih dipercaya pembeli',
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
