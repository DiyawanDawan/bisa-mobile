import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/i18n/failure_messages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:async';
import 'package:mobile_bisa/core/constants/app_layout.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/utils/safe_area_utils.dart';
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
import 'package:mobile_bisa/features/marketplace/presentation/marketplace_i18n.dart';
import 'package:mobile_bisa/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:mobile_bisa/shared/widgets/shimmer_loading.dart';

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
                category: _selectedCategory?.name ?? kMarketplaceFilterAllCategory,
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
                    if (category == kMarketplaceFilterAllCategory) {
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
                          padding: EdgeInsets.only(bottom: AppSpacing.md12),
                          child: MarketplaceBanner(productMode: _activeProductMode),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            AppSpacing.md,
                            0,
                            AppSpacing.md,
                            AppSpacing.md12,
                          ),
                          child: _buildSupplierDirectoryEntry(context),
                        ),
                      ),
                      if (user != null && user.role == 'BUYER')
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: AppSpacing.md12),
                            child: _buildBuyerProductsBanner(context),
                          ),
                        ),
                      SliverToBoxAdapter(child: _buildProductModeSelector()),
                      SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
                      if (_activeProductMode == 'BIOMASS_MATERIAL')
                        SliverToBoxAdapter(child: _buildBiomassaTypeBar()),
                      SliverToBoxAdapter(
                        child: HorizontalProductSection(
                          title: _activeProductMode == 'ORGANIC_PRODUCE'
                              ? 'marketplace.new_rec_organic'.tr()
                              : 'marketplace.new_rec_biochar'.tr(),
                          sortBy: 'createdAt',
                          sortOrder: 'desc',
                          limit: 20,
                          productMode: _activeProductMode,
                          onShowAll: () {
                            context.push(
                              '/collection-products',
                              extra: {
                                'title': _activeProductMode == 'ORGANIC_PRODUCE'
                                    ? 'marketplace.new_rec_organic'.tr()
                                    : 'marketplace.new_rec_biochar'.tr(),
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
                              ? 'marketplace.cheapest_organic'.tr()
                              : 'marketplace.cheapest_biochar'.tr(),
                          sortBy: 'pricePerUnit',
                          sortOrder: 'asc',
                          limit: 10,
                          productMode: _activeProductMode,
                          onShowAll: () {
                            context.push(
                              '/collection-products',
                              extra: {
                                'title': _activeProductMode == 'ORGANIC_PRODUCE'
                                    ? 'marketplace.cheapest_organic'.tr()
                                    : 'marketplace.cheapest_biochar'.tr(),
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
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.sm,
                          ),
                          child: Text(
                            _activeProductMode == 'ORGANIC_PRODUCE'
                                ? 'marketplace.all_organic'.tr()
                                : 'marketplace.all_products'.tr(),
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
                            loading: () => SliverToBoxAdapter(
                              child: ShimmerProductGridPlaceholder(
                                itemCount: 6,
                                showSellerInfo: false,
                                padding: EdgeInsets.fromLTRB(
                                  AppSpacing.md12,
                                  0,
                                  AppSpacing.md12,
                                  mainShellBottomPadding(
                                    context,
                                    kind: MainShellScrollKind.grid,
                                  ),
                                ),
                              ),
                            ),
                            error: (message) => SliverFillRemaining(
                              child: Center(child: Text(message.localizedFailure)),
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
                                  AppSpacing.md12,
                                  0,
                                  AppSpacing.md12,
                                  mainShellBottomPadding(
                                  context,
                                  kind: MainShellScrollKind.grid,
                                ),
                                ),
                                sliver: SliverMasonryGrid.count(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: AppSpacing.md,
                                  crossAxisSpacing: AppSpacing.md12,
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
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: kBiomassaTypeValues.length,
        itemBuilder: (context, index) {
          final type = kBiomassaTypeValues[index];
          final isSel = _selectedBiomassaType == type;
          return Padding(
            padding: EdgeInsets.only(right: AppSpacing.sm),
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
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.section),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSel ? AppColors.primary.withValues(alpha: 0.12) : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
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
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
                      padding: EdgeInsets.only(right: AppSpacing.sm),
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedCategory = cat);
                          _fetchProducts();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSel
                                ? AppColors.primary
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            border: Border.all(
                              color: isSel
                                  ? AppColors.primary
                                  : AppColors.grey200,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            isAll ? 'marketplace.category_all'.tr() : cat!.name,
                            style: TextStyle(
                              color: isSel
                                  ? AppColors.textOnPrimary
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
                padding: EdgeInsets.only(right: AppSpacing.lg),
                child: GestureDetector(
                  onTap: () {
                    FilterBottomSheet.show(
                      context,
                      sortBy: _sortBy,
                      category: _selectedCategory?.name ?? kMarketplaceFilterAllCategory,
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
                              if (category == kMarketplaceFilterAllCategory) {
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
                    padding: EdgeInsets.all(AppSpacing.sm10),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
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
                      color: AppColors.surface,
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
          SizedBox(height: AppSpacing.lg),
          Text(
            'marketplace.no_products_found'.tr(),
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
            color: AppColors.black.withOpacity(0.3),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.1),
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
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.md12,
      ),
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildModeTab(
                label: 'marketplace.mode_biomass'.tr(),
                icon: LucideIcons.package,
                mode: 'BIOMASS_MATERIAL',
              ),
            ),
            Expanded(
              child: _buildModeTab(
                label: 'marketplace.mode_organic'.tr(),
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
          color: isSelected ? AppColors.primary : AppColors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.xl),
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
              color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
            ),
            SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupplierDirectoryEntry(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: () => context.push('/supplier-directory'),
        borderRadius: BorderRadius.circular(AppRadius.tile),
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.section,
            vertical: AppSpacing.md12,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.tile),
            border: Border.all(color: AppColors.grey200),
            boxShadow: AppColors.softShadow,
          ),
          child: Row(
            children: [
              Icon(LucideIcons.building2, color: AppColors.primary, size: 22.sp),
              SizedBox(width: AppSpacing.md12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'marketplace.supplier_directory'.tr(),
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'marketplace.supplier_directory_hint'.tr(),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(LucideIcons.chevronRight, color: AppColors.grey400, size: 18.sp),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBuyerProductsBanner(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: () => context.push('/buyer-products'),
          borderRadius: BorderRadius.circular(AppRadius.tile),
          child: Ink(
            padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.section,
            vertical: AppSpacing.md12,
          ),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppRadius.tile),
              boxShadow: AppColors.mediumShadow,
            ),
            child: Row(
              children: [
                Icon(LucideIcons.package, color: AppColors.textOnPrimary, size: 22.sp),
                SizedBox(width: AppSpacing.md12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'marketplace.buyer_products_title'.tr(),
                        style: TextStyle(
                          color: AppColors.surface,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'marketplace.buyer_products_subtitle'.tr(),
                        style: TextStyle(
                          color: AppColors.textOnPrimary.withOpacity(0.85),
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(LucideIcons.chevronRight, color: AppColors.textOnPrimary, size: 18.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
