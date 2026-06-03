import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:async';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/injection_container.dart';
import 'package:mobile_bisa/features/marketplace/presentation/bloc/marketplace_cubit.dart';
import 'package:mobile_bisa/features/marketplace/presentation/bloc/category_cubit.dart';
import 'package:mobile_bisa/features/marketplace/presentation/bloc/category_state.dart';
import 'package:mobile_bisa/features/marketplace/data/models/category_model.dart';
import 'package:mobile_bisa/features/marketplace/presentation/widgets/product_card.dart';
import 'package:mobile_bisa/features/marketplace/presentation/widgets/marketplace_header.dart';
import 'package:mobile_bisa/features/marketplace/presentation/widgets/filter_bottom_sheet.dart';
import 'package:mobile_bisa/features/marketplace/presentation/widgets/marketplace_banner.dart';
import 'package:mobile_bisa/features/marketplace/presentation/widgets/horizontal_product_section.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_bisa/features/marketplace/presentation/widgets/category_search_picker.dart';
import 'package:mobile_bisa/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:mobile_bisa/shared/widgets/product_card_skeleton.dart';

class MarketplacePage extends StatefulWidget {
  final ValueChanged<String>? onProductModeChanged;

  const MarketplacePage({super.key, this.onProductModeChanged});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  CategoryModel? _selectedCategory;
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  final _scrollController = ScrollController();
  bool _isSearching = false;

  // Mode: BIOMASS_MATERIAL or ORGANIC_PRODUCE
  String _activeProductMode = MarketplaceCubit.activeProductMode;
  String _selectedBiomassaType = 'BIOCHAR';

  // Filters
  double? _minPrice;
  double? _maxPrice;
  double? _minRating;
  String _sortBy = 'createdAt';

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearching = _searchFocusNode.hasFocus;
      });
    });
    _scrollController.addListener(_onScroll);
    // Ensure initial fetch happens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarketplaceCubit>().getCollections();
      context.read<CategoryCubit>().getCategories(
        productMode: _activeProductMode,
        biomassaType: _activeProductMode == 'BIOMASS_MATERIAL'
            ? _selectedBiomassaType
            : null,
      );
      _fetchProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchProducts();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      _fetchProducts(refresh: false);
    }
  }

  void _fetchProducts({bool refresh = true}) {
    String? sortBy;
    String? sortOrder;

    switch (_sortBy) {
      case 'priceAsc':
        sortBy = 'pricePerUnit';
        sortOrder = 'asc';
        break;
      case 'priceDesc':
        sortBy = 'pricePerUnit';
        sortOrder = 'desc';
        break;
      case 'sold':
        sortBy = 'soldCount';
        sortOrder = 'desc';
        break;
      case 'createdAt':
      default:
        sortBy = 'createdAt';
        sortOrder = 'desc';
    }

    context.read<MarketplaceCubit>().getProducts(
      search: _searchController.text.trim(),
      categoryId: _selectedCategory?.id,
      biomassaType: _activeProductMode == 'BIOMASS_MATERIAL'
          ? _selectedBiomassaType
          : null,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      minRating: _minRating,
      productMode: _activeProductMode,
      sortBy: sortBy,
      sortOrder: sortOrder,
      refresh: refresh,
    );
  }

  // _buildCollectionBar removed as we now use HorizontalProductSections

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<AuthCubit>().state;
    final user = userState.maybeWhen(
      authenticated: (u) => u,
      orElse: () => null,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          MarketplaceHeader(
            userName: user?.name,
            searchController: _searchController,
            searchFocusNode: _searchFocusNode,
            onSearchChanged: _onSearchChanged,
            productMode: _activeProductMode,
            onSearchSubmitted: (_) {
              _searchFocusNode.unfocus();
              _fetchProducts();
            },
            onFilterTapped: () {
              FilterBottomSheet.show(
                context,
                sortBy: _sortBy,
                category: _selectedCategory?.name ?? 'Semua',
                minPrice: _minPrice,
                maxPrice: _maxPrice,
                minRating: _minRating,
                categories:
                    (context.read<CategoryCubit>().state is CategoryLoaded)
                    ? (context.read<CategoryCubit>().state as CategoryLoaded)
                          .categories
                          .map((c) => c.name)
                          .toList()
                    : [],
                onApply: (sortBy, category, minPrice, maxPrice, minRating) {
                  setState(() {
                    _sortBy = sortBy;
                    if (category == 'Semua') {
                      _selectedCategory = null;
                    } else {
                      final catState = context.read<CategoryCubit>().state;
                      if (catState is CategoryLoaded) {
                        try {
                          _selectedCategory = catState.categories.firstWhere(
                            (c) => c.name == category,
                          );
                        } catch (_) {
                          // Keep existing or handle unknown category
                        }
                      }
                    }
                    _minPrice = minPrice;
                    _maxPrice = maxPrice;
                    _minRating = minRating;
                  });
                  _fetchProducts();
                },
              );
            },
          ),
          Expanded(
            child: Stack(
              children: [
                RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async => _fetchProducts(),
                  child: CustomScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: MarketplaceBanner(productMode: _activeProductMode),
                        ),
                      ),
                      if (user != null && user.role == 'BUYER')
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: _buildBuyerProductsBanner(context),
                          ),
                        ),
                      SliverToBoxAdapter(child: _buildProductModeSelector()),
                      SliverToBoxAdapter(child: SizedBox(height: 8.h)),
                      if (_activeProductMode == 'BIOMASS_MATERIAL')
                        SliverToBoxAdapter(child: _buildBiomassaTypeBar()),
                      SliverToBoxAdapter(
                        child: HorizontalProductSection(
                          title: _activeProductMode == 'ORGANIC_PRODUCE'
                              ? 'Rekomendasi Hasil Tani Baru'
                              : 'Rekomendasi Produk Baru',
                          sortBy: 'createdAt',
                          sortOrder: 'desc',
                          limit: 20,
                          productMode: _activeProductMode,
                          onShowAll: () {
                            context.push(
                              '/collection-products',
                              extra: {
                                'title': _activeProductMode == 'ORGANIC_PRODUCE'
                                    ? 'Rekomendasi Hasil Tani Baru'
                                    : 'Rekomendasi Produk Baru',
                                'sortBy': 'createdAt',
                                'sortOrder': 'desc',
                                'productMode': _activeProductMode,
                              },
                            );
                          },
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: HorizontalProductSection(
                          title: _activeProductMode == 'ORGANIC_PRODUCE'
                              ? 'Hasil Tani Termurah'
                              : 'Produk Termurah',
                          sortBy: 'pricePerUnit',
                          sortOrder: 'asc',
                          limit: 10,
                          productMode: _activeProductMode,
                          onShowAll: () {
                            context.push(
                              '/collection-products',
                              extra: {
                                'title': _activeProductMode == 'ORGANIC_PRODUCE'
                                    ? 'Hasil Tani Termurah'
                                    : 'Produk Termurah',
                                'sortBy': 'pricePerUnit',
                                'sortOrder': 'asc',
                                'productMode': _activeProductMode,
                              },
                            );
                          },
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                          child: Text(
                            _activeProductMode == 'ORGANIC_PRODUCE'
                                ? 'Semua Hasil Tani Organik'
                                : 'Semua Produk',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(child: _buildCategoryBar()),
                      BlocBuilder<MarketplaceCubit, MarketplaceState>(
                        builder: (context, state) {
                          return state.maybeWhen(
                            initial: () => const SliverToBoxAdapter(
                              child: SizedBox.shrink(),
                            ),
                            loading: () => SliverPadding(
                              padding: EdgeInsets.fromLTRB(
                                12.w,
                                0,
                                12.w,
                                160.h,
                              ),
                              sliver: SliverMasonryGrid.count(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16.h,
                                crossAxisSpacing: 12.w,
                                childCount: 6,
                                itemBuilder: (_, __) =>
                                    const ProductCardSkeleton(),
                              ),
                            ),
                            error: (message) => SliverFillRemaining(
                              child: Center(child: Text(message)),
                            ),
                            suppliersLoaded: (_) => const SliverToBoxAdapter(
                              child: SizedBox.shrink(),
                            ),
                            loaded: (products, hasReachedMax) {
                              if (products.isEmpty) {
                                return SliverFillRemaining(
                                  child: _buildEmptyState(),
                                );
                              }
                              return SliverPadding(
                                padding: EdgeInsets.fromLTRB(
                                  12.w,
                                  0,
                                  12.w,
                                  160.h,
                                ),
                                sliver: SliverMasonryGrid.count(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16.h,
                                  crossAxisSpacing: 12.w,
                                  itemBuilder: (context, index) =>
                                      ProductCard(product: products[index]),
                                  childCount: products.length,
                                ),
                              );
                            },
                            orElse: () => const SliverToBoxAdapter(
                              child: SizedBox.shrink(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                if (_isSearching && _searchController.text.isNotEmpty)
                  _buildSearchSuggestions(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiomassaTypeBar() {
    return Container(
      height: 44.h,
      margin: EdgeInsets.only(bottom: 4.h),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: kBiomassaTypeValues.length,
        itemBuilder: (context, index) {
          final type = kBiomassaTypeValues[index];
          final isSel = _selectedBiomassaType == type;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: GestureDetector(
              onTap: () {
                if (_selectedBiomassaType == type) return;
                setState(() {
                  _selectedBiomassaType = type;
                  _selectedCategory = null;
                });
                context.read<CategoryCubit>().getCategories(
                  productMode: 'BIOMASS_MATERIAL',
                  biomassaType: type,
                );
                _fetchProducts();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSel ? AppColors.primary.withValues(alpha: 0.12) : AppColors.surface,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSel ? AppColors.primary : AppColors.grey200,
                  ),
                ),
                child: Text(
                  biomassaTypeLabel(type),
                  style: TextStyle(
                    color: isSel ? AppColors.primary : AppColors.textSecondary,
                    fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryBar() {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        List<CategoryModel> categories = [];
        if (state is CategoryLoaded) {
          categories = state.categories;
        }

        return Container(
          height: 70.h,
          padding: EdgeInsets.symmetric(vertical: 15.h),
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: categories.length + 1,
                  itemBuilder: (context, index) {
                    final bool isAll = index == 0;
                    final cat = isAll ? null : categories[index - 1];
                    final isSel = isAll
                        ? _selectedCategory == null
                        : _selectedCategory?.id == cat?.id;

                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedCategory = cat);
                          _fetchProducts();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSel
                                ? AppColors.primary
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: isSel
                                  ? AppColors.primary
                                  : AppColors.grey200,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            isAll ? 'Semua' : cat!.name,
                            style: TextStyle(
                              color: isSel
                                  ? Colors.white
                                  : AppColors.textSecondary,
                              fontWeight: isSel
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: GestureDetector(
                  onTap: () {
                    FilterBottomSheet.show(
                      context,
                      sortBy: _sortBy,
                      category: _selectedCategory?.name ?? 'Semua',
                      minPrice: _minPrice,
                      maxPrice: _maxPrice,
                      minRating: _minRating,
                      categories:
                          (context.read<CategoryCubit>().state
                              is CategoryLoaded)
                          ? (context.read<CategoryCubit>().state
                                    as CategoryLoaded)
                                .categories
                                .map((c) => c.name)
                                .toList()
                          : [],
                      onApply:
                          (sortBy, category, minPrice, maxPrice, minRating) {
                            setState(() {
                              _sortBy = sortBy;
                              if (category == 'Semua') {
                                _selectedCategory = null;
                              } else {
                                final catState = context
                                    .read<CategoryCubit>()
                                    .state;
                                if (catState is CategoryLoaded) {
                                  try {
                                    _selectedCategory = catState.categories
                                        .firstWhere((c) => c.name == category);
                                  } catch (_) {}
                                }
                              }
                              _minPrice = minPrice;
                              _maxPrice = maxPrice;
                              _minRating = minRating;
                            });
                            _fetchProducts();
                          },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      LucideIcons.slidersHorizontal,
                      color: Colors.white,
                      size: 18.sp,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.packageSearch,
            size: 64.sp,
            color: AppColors.grey200,
          ),
          SizedBox(height: 20.h),
          Text(
            'Produk tidak ditemukan',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        List<String> suggestions = _activeProductMode == 'ORGANIC_PRODUCE'
            ? [
                'Beras Organik',
                'Sayur Segar',
                'Buah-buahan',
              ]
            : [
                'Biochar Premium',
                'Arang Batok',
                'Sekam Padi',
              ];

        if (state is CategoryLoaded) {
          suggestions = state.categories.map((e) => e.name).toList();
        }

        return GestureDetector(
          onTap: () => setState(() => _isSearching = false),
          child: Container(
            color: Colors.black.withOpacity(0.3),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: suggestions.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(LucideIcons.search, size: 18),
                        title: Text(
                          suggestions[index],
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        onTap: () {
                          _searchController.text = suggestions[index];
                          _fetchProducts();
                          setState(() => _isSearching = false);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductModeSelector() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 12.h),
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildModeTab(
                label: 'Bahan Baku Biomassa',
                icon: LucideIcons.package,
                mode: 'BIOMASS_MATERIAL',
              ),
            ),
            Expanded(
              child: _buildModeTab(
                label: 'Hasil Tani Organik',
                icon: LucideIcons.sprout,
                mode: 'ORGANIC_PRODUCE',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeTab({
    required String label,
    required IconData icon,
    required String mode,
  }) {
    final bool isSelected = _activeProductMode == mode;
    return GestureDetector(
      onTap: () {
        if (_activeProductMode != mode) {
          setState(() {
            _activeProductMode = mode;
            MarketplaceCubit.activeProductMode = mode;
            _selectedCategory = null;
            if (mode == 'BIOMASS_MATERIAL') {
              _selectedBiomassaType = 'BIOCHAR';
            }
          });
          context.read<CategoryCubit>().getCategories(
            productMode: mode,
            biomassaType: mode == 'BIOMASS_MATERIAL' ? _selectedBiomassaType : null,
          );
          _fetchProducts();
          // Notify parent (MainScreen) so other tabs update
          widget.onProductModeChanged?.call(mode);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBuyerProductsBanner(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 4.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/buyer-products'),
          borderRadius: BorderRadius.circular(14.r),
          child: Ink(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: AppColors.mediumShadow,
            ),
            child: Row(
              children: [
                Icon(LucideIcons.package, color: Colors.white, size: 22.sp),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Produk Saya',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Lihat produk dibeli, nego, & favorit',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(LucideIcons.chevronRight, color: Colors.white, size: 18.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
