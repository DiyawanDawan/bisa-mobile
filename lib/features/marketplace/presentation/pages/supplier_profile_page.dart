import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/media_url_utils.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/bisa_search_field.dart';
import '../../../../shared/widgets/supplier_3d_widgets.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../bloc/marketplace_cubit.dart';
import '../bloc/store_banner_cubit.dart';
import '../widgets/store_banner_section.dart';
import '../../domain/entities/product_entity.dart';
import '../widgets/product_card.dart';
import '../widgets/supplier_trade_history_section.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import '../../../follow/presentation/widgets/follow_button.dart';

class SupplierProfilePage extends StatefulWidget {
  final String supplierId;
  final String supplierName;
  final bool previewAsOwner;

  const SupplierProfilePage({
    super.key,
    required this.supplierId,
    required this.supplierName,
    this.previewAsOwner = false,
  });

  @override
  State<SupplierProfilePage> createState() => _SupplierProfilePageState();
}

class _SupplierProfilePageState extends State<SupplierProfilePage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'ALL';
  UserEntity? _supplier;

  static const _filterAll = 'ALL';
  static const _filterNewest = 'NEWEST';
  static const _filterPriceLow = 'PRICE_LOW';
  static const _filterPriceHigh = 'PRICE_HIGH';
  static const _filterRatingHigh = 'RATING_HIGH';

  List<Map<String, String>> _filterOptions() => [
        {'value': _filterAll, 'label': 'marketplace.filter_all'.tr()},
        {'value': _filterNewest, 'label': 'marketplace.sort_newest'.tr()},
        {'value': _filterPriceLow, 'label': 'marketplace.sort_price_low'.tr()},
        {'value': _filterPriceHigh, 'label': 'marketplace.sort_price_high'.tr()},
        {
          'value': _filterRatingHigh,
          'label': 'marketplace.sort_rating_high'.tr(),
        },
      ];

  @override
  void initState() {
    super.initState();
    _loadSupplierProfile();
    WidgetsBinding.instance.addPostFrameCallback((_) => _redirectOwnerToStoreManagement());
  }

  void _redirectOwnerToStoreManagement() {
    if (!mounted || widget.previewAsOwner) return;

    final currentUser = context.read<AuthCubit>().state.maybeWhen(
      authenticated: (u) => u,
      orElse: () => null,
    );
    if (currentUser != null && currentUser.id == widget.supplierId) {
      context.pushReplacement('/store-management');
    }
  }

  Future<void> _loadSupplierProfile() async {
    final result = await sl<AuthRepository>().getPublicProfile(widget.supplierId);
    result.fold(
      (_) {},
      (user) {
        if (mounted) setState(() => _supplier = user);
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ProductEntity> _applyFilters(List<ProductEntity> products) {
    var filtered = products.where((p) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return p.name.toLowerCase().contains(q) ||
          (p.description?.toLowerCase().contains(q) ?? false) ||
          p.biomassaType.toLowerCase().contains(q);
    }).toList();

    switch (_selectedFilter) {
      case _filterNewest:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case _filterPriceLow:
        filtered.sort((a, b) => a.pricePerUnit.compareTo(b.pricePerUnit));
        break;
      case _filterPriceHigh:
        filtered.sort((a, b) => b.pricePerUnit.compareTo(a.pricePerUnit));
        break;
      case _filterRatingHigh:
        filtered.sort((a, b) => b.averageRating.compareTo(a.averageRating));
        break;
    }

    return filtered;
  }

  /// Pastikan kartu punya avatar/nama toko (sama seperti home), dari produk atau profil supplier.
  ProductEntity _enrichProductForCard(ProductEntity product) {
    final profile = _supplier;
    if (profile == null) return product;

    final seller = product.seller;

    return product.copyWith(
      seller: seller.copyWith(
        id: seller.id.isNotEmpty ? seller.id : profile.id,
        name: seller.name.trim().isNotEmpty ? seller.name : profile.name,
        companyName: seller.companyName ?? profile.companyName,
        avatarUrl: seller.avatarUrl ?? profile.avatar,
        isVerified: seller.isVerified || profile.isVerified,
      ),
    );
  }

  String _locationLabel() {
    final address = _supplier?.address?.trim();
    if (address != null && address.isNotEmpty) return address;
    return 'Indonesia';
  }

  String _joinLabel() {
    final created = _supplier?.createdAt;
    if (created == null) return '-';
    final years = DateTime.now().difference(created).inDays ~/ 365;
    if (years >= 1) return '$years Thn';
    final months = DateTime.now().difference(created).inDays ~/ 30;
    if (months >= 1) return '$months Bln';
    return 'Baru';
  }

  double _avgRating(List<ProductEntity> products) {
    if (products.isEmpty) return 0;
    final sum = products.fold<double>(0, (s, p) => s + p.averageRating);
    return sum / products.length;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<MarketplaceCubit>()..getProducts(userId: widget.supplierId),
      child: BlocProvider(
        create: (_) =>
            sl<StoreBannerCubit>()..loadUserBanners(widget.supplierId),
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: BisaAppBar(
            title: widget.previewAsOwner
                ? 'marketplace.store_preview_buyer'.tr()
                : widget.supplierName,
            backgroundColor: AppColors.surface,
          ),
          body: Column(
            children: [
              if (widget.previewAsOwner)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm10),
                  color: AppColors.primaryLight.withValues(alpha: 0.35),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.eye,
                        size: 16.sp,
                        color: AppColors.primaryDark,
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'marketplace.supplier_buyer_preview'.tr(
                            namedArgs: {'name': widget.supplierName},
                          ),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: BlocBuilder<MarketplaceCubit, MarketplaceState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                loading: () => const ShimmerProductGridPlaceholder(
                  itemCount: 6,
                  showSellerInfo: false,
                ),
                error: (message) => Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.circleAlert,
                          size: 48.sp,
                          color: AppColors.error,
                        ),
                        SizedBox(height: AppSpacing.md12),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                loaded: (products, hasReachedMax) {
                  final filtered = _applyFilters(products);
                  final avgRating = _avgRating(products);

                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            StoreBannerCarousel(height: 168.h),
                            Transform.translate(
                              offset: Offset(0, -28.h),
                              child: _buildSupplierHeader(
                                productCount: products.length,
                                avgRating: avgRating,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SupplierTradeHistorySection(
                          supplierId: widget.supplierId,
                        ),
                      ),
                      SliverToBoxAdapter(child: _buildSearchFilterCard()),
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 40.h),
                        sliver: filtered.isEmpty
                            ? SliverToBoxAdapter(child: _buildEmptyState())
                            : SliverToBoxAdapter(
                                child: MasonryGridView.count(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 2,
                                  mainAxisSpacing: AppSpacing.md,
                                  crossAxisSpacing: AppSpacing.md12,
                                  itemCount: filtered.length,
                                  itemBuilder: (context, index) {
                                    return ProductCard(
                                      product: _enrichProductForCard(
                                        filtered[index],
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                    ],
                  );
                },
                orElse: () => const SizedBox.shrink(),
              );
            },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchFilterCard() {
    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.xs),
      child: Container(
        padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 12.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BisaSearchField(
              controller: _searchController,
              hint: 'marketplace.search_supplier_products'.tr(),
              onChanged: (value) => setState(() => _searchQuery = value),
              onClear: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
            ),
            SizedBox(height: AppSpacing.sm10),
            SizedBox(
              height: 36.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _filterOptions().length,
                separatorBuilder: (_, __) => SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final filter = _filterOptions()[index];
                  final value = filter['value']!;
                  final label = filter['label']!;
                  final isSelected = _selectedFilter == value;
                  return FilterChip(
                    label: Text(
                      label,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight:
                            isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected
                            ? AppColors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                    selected: isSelected,
                    showCheckmark: false,
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.grey50,
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.grey200,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    onSelected: (_) =>
                        setState(() => _selectedFilter = value),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupplierHeader({
    required int productCount,
    required double avgRating,
  }) {
    final isVerified = _supplier?.isVerified ?? true;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.9),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(3.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                ),
                child: CircleAvatar(
                  radius: 34.r,
                  backgroundColor: AppColors.primaryLight,
                  backgroundImage: resolveMediaImageProvider(_supplier?.avatar),
                  child: _supplier?.avatar == null
                      ? Icon(
                          LucideIcons.store,
                          color: AppColors.primary,
                          size: 30.sp,
                        )
                      : null,
                ),
              ),
              SizedBox(width: AppSpacing.md12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _supplier?.companyName ??
                                widget.supplierName,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isVerified)
                          Icon(
                            LucideIcons.badgeCheck,
                            color: AppColors.info,
                            size: 20.sp,
                          ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    if (isVerified)
                      Row(
                        children: [
                          Icon(
                            LucideIcons.shieldCheck,
                            color: AppColors.info,
                            size: 13.sp,
                          ),
                          SizedBox(width: 4.w),
                          Flexible(
                            child: Text(
                              'marketplace.verified_supplier'.tr(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.sp,
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
                          LucideIcons.mapPin,
                          size: 12.sp,
                          color: AppColors.textHint,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            _locationLabel(),
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              FollowButton(userId: widget.supplierId, compact: true),
            ],
          ),
          SizedBox(height: AppSpacing.md12),
          UserFollowStatsRow(userId: widget.supplierId),
          SizedBox(height: AppSpacing.md12),
          Row(
            children: [
              Expanded(
                child: Supplier3DStatCard(
                  label: 'marketplace.products_label'.tr(),
                  value: '$productCount',
                  color: AppColors.primary,
                  icon: LucideIcons.package,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Supplier3DStatCard(
                  label: 'marketplace.rating_label'.tr(),
                  value: avgRating > 0
                      ? avgRating.toStringAsFixed(1)
                      : '-',
                  color: AppColors.warning,
                  icon: LucideIcons.star,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Supplier3DStatCard(
                  label: 'marketplace.joined_label'.tr(),
                  value: _joinLabel(),
                  color: AppColors.success,
                  icon: LucideIcons.calendar,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.section),
          _buildPartnershipAction(context),
          SizedBox(height: AppSpacing.sm10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(LucideIcons.messageSquare, size: 18.sp),
                  label: Text('chat'.tr()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textOnPrimary,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.tile),
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.sm10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(LucideIcons.share2, size: 18.sp),
                  label: Text('bagikan'.tr()),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md12),
                    side: BorderSide(
                      color: AppColors.primary.withValues(alpha: 0.35),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.tile),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPartnershipAction(BuildContext context) {
    if (widget.previewAsOwner) return const SizedBox.shrink();

    final currentUser = context.watch<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u,
          orElse: () => null,
        );
    if (currentUser == null || currentUser.role == 'SUPPLIER') {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          context.push(
            '/partnerships/create/${widget.supplierId}',
            extra: {'name': widget.supplierName},
          );
        },
        icon: Icon(LucideIcons.handshake, size: 18.sp),
        label: Text('buat_kontrak_kerjasama'.tr()),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.success,
          padding: EdgeInsets.symmetric(vertical: AppSpacing.md12),
          side: BorderSide(color: AppColors.success.withValues(alpha: 0.45)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.tile),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 48.h),
        child: Column(
          children: [
            Icon(LucideIcons.package, size: 48.sp, color: AppColors.grey200),
            SizedBox(height: AppSpacing.md),
            Text(
              _searchQuery.isNotEmpty
                  ? 'marketplace.supplier_search_not_found'.tr()
                  : 'marketplace.supplier_no_products'.tr(),
              style: TextStyle(color: AppColors.textHint, fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }
}
