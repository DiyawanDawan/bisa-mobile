import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../home/presentation/pages/main_screen.dart';
import '../../../marketplace/domain/entities/product_entity.dart';
import '../../../marketplace/presentation/bloc/marketplace_cubit.dart';
import '../../../marketplace/presentation/widgets/product_card.dart';
import '../bloc/commerce_cubit.dart';
import '../widgets/mode_product_catalog.dart';
import '../../../../shared/widgets/shimmer_loading.dart';

/// Halaman Favorit — favorit difilter per mode, rekomendasi, lalu katalog
/// semua produk Biomassa & Hasil Tani di bawahnya.
class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  late final MarketplaceCubit _recommendationCubit;
  String _favoriteModeFilter = 'ALL';

  @override
  void initState() {
    super.initState();
    context.read<CommerceCubit>().loadWishlist();
    _recommendationCubit = sl<MarketplaceCubit>();
    _fetchRecommendations();
  }

  void _fetchRecommendations() {
    _recommendationCubit.getProducts(
      sortBy: 'averageRating',
      sortOrder: 'desc',
      limit: 12,
    );
  }

  @override
  void dispose() {
    _recommendationCubit.close();
    super.dispose();
  }

  Future<void> _refresh() async {
    await Future.wait<void>([
      context.read<CommerceCubit>().loadWishlist(),
      _recommendationCubit.getProducts(
        sortBy: 'averageRating',
        sortOrder: 'desc',
        limit: 12,
      ),
    ]);
  }

  List<ProductEntity> _filterByMode(List<ProductEntity> items, String mode) {
    return items.where((p) => p.productMode == mode).toList();
  }

  Widget _buildFavoriteSections(List<ProductEntity> products) {
    final biomass = _filterByMode(products, 'BIOMASS_MATERIAL');
    final organic = _filterByMode(products, 'ORGANIC_PRODUCE');

    if (_favoriteModeFilter == 'BIOMASS_MATERIAL') {
      return WishlistModeProductGrid(
        products: biomass,
        title: 'Favorit Biomassa',
        emptyHint: 'Belum ada favorit Biomassa.',
      );
    }
    if (_favoriteModeFilter == 'ORGANIC_PRODUCE') {
      return WishlistModeProductGrid(
        products: organic,
        title: 'Favorit Hasil Tani',
        emptyHint: 'Belum ada favorit Hasil Tani.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WishlistModeProductGrid(
          products: biomass,
          title: 'Favorit Biomassa (${biomass.length})',
          emptyHint: biomass.isEmpty ? 'Belum ada favorit Biomassa.' : null,
        ),
        WishlistModeProductGrid(
          products: organic,
          title: 'Favorit Hasil Tani (${organic.length})',
          emptyHint: organic.isEmpty ? 'Belum ada favorit Hasil Tani.' : null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BisaAppBar(
        title: 'Favorit Saya',
        backgroundColor: Colors.white,
      ),
      body: BlocBuilder<CommerceCubit, CommerceState>(
        builder: (context, state) {
          final products = state.wishlistProducts ?? [];
          final wishlistLoading = state.isLoading && state.wishlistProducts == null;
          final excludeIds = products.map((p) => p.id).toSet();

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: _refresh,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: ProductModeTabSelector(
                    includeAllTab: true,
                    selectedMode: _favoriteModeFilter,
                    onModeChanged: (mode) {
                      setState(() => _favoriteModeFilter = mode);
                    },
                  ),
                ),
                if (wishlistLoading)
                  SliverToBoxAdapter(
                    child: ShimmerProductGridPlaceholder(itemCount: 6),
                  )
                else if (products.isEmpty)
                  SliverToBoxAdapter(child: _EmptyState())
                else
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 4.h),
                          child: Row(
                            children: [
                              Icon(
                                LucideIcons.heart,
                                size: 14.sp,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                '${products.length} produk favorit',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              if (state.isLoading) ...[
                                SizedBox(width: 8.w),
                                SizedBox(
                                  width: 14.w,
                                  height: 14.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        _buildFavoriteSections(products),
                      ],
                    ),
                  ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Divider(height: 1, color: AppColors.grey100),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _RecommendationSection(
                    cubit: _recommendationCubit,
                    excludeIds: excludeIds,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Divider(height: 1, color: AppColors.grey100),
                  ),
                ),
                SliverToBoxAdapter(
                  child: DualModeProductCatalog(
                    excludeIds: excludeIds,
                    limitPerMode: 20,
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 32.h)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.heart,
              size: 48.sp,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            'Belum ada produk favorit',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Tekan ikon hati pada produk untuk menyimpannya ke daftar favorit.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationSection extends StatelessWidget {
  final MarketplaceCubit cubit;
  final Set<String> excludeIds;

  const _RecommendationSection({
    required this.cubit,
    required this.excludeIds,
  });

  void _goToMarketplace(BuildContext context) {
    final scope = MainShellScope.maybeOf(context);
    if (scope != null) {
      scope.selectTab(0);
      context.pop();
    } else {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: BlocBuilder<MarketplaceCubit, MarketplaceState>(
        builder: (context, state) {
          return state.maybeWhen(
            initial: () => _shell(
              context,
              subtitle: 'Memuat rekomendasi...',
              child: _spinner(),
            ),
            loading: () => _shell(
              context,
              subtitle: 'Memuat rekomendasi...',
              child: _spinner(),
            ),
            error: (msg) => _shell(
              context,
              subtitle: 'Gagal memuat rekomendasi',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(msg, style: TextStyle(fontSize: 12.sp)),
              ),
            ),
            loaded: (products, _) {
              final filtered = products
                  .where((p) => !excludeIds.contains(p.id))
                  .toList();
              if (filtered.isEmpty) {
                return _shell(
                  context,
                  subtitle: 'Belum ada rekomendasi tersedia',
                  child: const SizedBox.shrink(),
                );
              }
              return _shell(
                context,
                subtitle: 'Populer di Biomassa & Hasil Tani',
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
                  child: MasonryGridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12.h,
                    crossAxisSpacing: 10.w,
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: filtered[index]);
                    },
                  ),
                ),
              );
            },
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  Widget _spinner() => const ShimmerProductGridPlaceholder(itemCount: 4);

  Widget _shell(
    BuildContext context, {
    required String subtitle,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
          child: Row(
            children: [
              Icon(LucideIcons.sparkles, size: 16.sp, color: AppColors.primary),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  'Mungkin Anda Suka',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _goToMarketplace(context),
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
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
          child: Text(
            subtitle,
            style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
          ),
        ),
        child,
      ],
    );
  }
}
