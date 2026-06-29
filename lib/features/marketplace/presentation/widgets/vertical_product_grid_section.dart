import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/i18n/failure_messages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:mobile_bisa/core/constants/app_layout.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/features/marketplace/presentation/bloc/marketplace_cubit.dart';
import 'package:mobile_bisa/features/marketplace/presentation/bloc/category_cubit.dart';
import 'package:mobile_bisa/features/marketplace/presentation/bloc/category_state.dart';
import 'package:mobile_bisa/features/marketplace/data/models/category_model.dart';
import 'package:mobile_bisa/features/marketplace/presentation/widgets/product_card.dart';
import 'package:mobile_bisa/features/marketplace/presentation/widgets/filter_bottom_sheet.dart';
import 'package:mobile_bisa/features/marketplace/presentation/marketplace_i18n.dart';
import 'package:mobile_bisa/injection_container.dart';
import 'package:mobile_bisa/shared/widgets/bisa_filter_chip.dart';
import 'package:mobile_bisa/shared/widgets/shimmer_loading.dart';

class VerticalProductGridSection extends StatefulWidget {
  final String title;
  final String? sortBy;
  final String? sortOrder;
  final String? productMode;

  const VerticalProductGridSection({
    super.key,
    required this.title,
    this.sortBy,
    this.sortOrder,
    this.productMode,
  });

  @override
  State<VerticalProductGridSection> createState() =>
      _VerticalProductGridSectionState();
}

class _VerticalProductGridSectionState
    extends State<VerticalProductGridSection> {
  late final MarketplaceCubit _cubit;
  late final CategoryCubit _categoryCubit;
  CategoryModel? _selectedCategory;
  
  // Filters
  double? _minPrice;
  double? _maxPrice;
  double? _minRating;
  late String _sortBy;

  @override
  void initState() {
    super.initState();
    _cubit = sl<MarketplaceCubit>();
    _categoryCubit = sl<CategoryCubit>()..getCategories(productMode: widget.productMode);
    _sortBy = widget.sortBy ?? 'createdAt';
    _fetchData();
  }

  void _fetchData({bool refresh = true}) {
    String? sortBy;
    String? sortOrder = widget.sortOrder;

    if (_sortBy == 'priceAsc') {
      sortBy = 'pricePerUnit';
      sortOrder = 'asc';
    } else if (_sortBy == 'priceDesc') {
      sortBy = 'pricePerUnit';
      sortOrder = 'desc';
    } else if (_sortBy == 'sold') {
      sortBy = 'averageRating';
      sortOrder = 'desc';
    } else {
      sortBy = _sortBy;
    }

    _cubit.getProducts(
      sortBy: sortBy,
      sortOrder: sortOrder,
      categoryId: _selectedCategory?.id,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      minRating: _minRating,
      refresh: refresh,
      limit: 20, // Load 20 at a time for smoother infinite scroll
      productMode: widget.productMode,
    );
  }

  @override
  void didUpdateWidget(covariant VerticalProductGridSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.productMode != widget.productMode) {
      _selectedCategory = null;
      _categoryCubit.getCategories(productMode: widget.productMode);
      _fetchData();
    }
  }

  @override
  void dispose() {
    _cubit.close();
    _categoryCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _cubit),
        BlocProvider.value(value: _categoryCubit),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 16.h,
            ),
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          _buildCategoryBar(),
          BlocBuilder<MarketplaceCubit, MarketplaceState>(
            builder: (context, state) {
              return state.maybeWhen(
                initial: () => const SizedBox.shrink(),
                loading: () => ShimmerProductGridPlaceholder(
                  itemCount: 4,
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                ),
                error: (message) => Center(child: Text(message.localizedFailure)),
                loaded: (products, hasReachedMax) {
                  if (products.isEmpty) {
                    return Container(
                      height: 200.h,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LucideIcons.packageSearch, size: 48.sp, color: AppColors.grey200),
                          SizedBox(height: AppSpacing.md12),
                          Text('marketplace.no_products_found'.tr(), style: TextStyle(color: AppColors.textSecondary)),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        child: MasonryGridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: AppSpacing.md,
                          crossAxisSpacing: AppSpacing.md12,
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return ProductCard(product: products[index]);
                          },
                        ),
                      ),
                      if (!hasReachedMax)
                        VisibilityDetector(
                          key: const Key('load_more_trigger'),
                          onVisibilityChanged: (visibilityInfo) {
                            if (visibilityInfo.visibleFraction > 0.1) {
                              _fetchData(refresh: false);
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 30.h),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: AppSpacing.lg),
                    ],
                  );
                },
                orElse: () => const SizedBox.shrink(),
              );
            },
          ),
        ],
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
          height: 44.h,
          margin: EdgeInsets.only(bottom: AppSpacing.sm),
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
                      child: Center(
                        child: BisaFilterChip(
                          label: isAll ? 'marketplace.category_all'.tr() : cat!.name,
                          isSelected: isSel,
                          onTap: () {
                            setState(() => _selectedCategory = cat);
                            _fetchData();
                          },
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
                      categories: categories.map((c) => c.name).toList(),
                      onApply: (sortBy, category, minPrice, maxPrice, minRating) {
                        setState(() {
                          _sortBy = sortBy;
                          if (category == kMarketplaceFilterAllCategory) {
                            _selectedCategory = null;
                          } else {
                            try {
                              _selectedCategory = categories.firstWhere(
                                (c) => c.name == category,
                              );
                            } catch (_) {}
                          }
                          _minPrice = minPrice;
                          _maxPrice = maxPrice;
                          _minRating = minRating;
                        });
                        _fetchData();
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
                          color: AppColors.primary.withOpacity(0.3),
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
}
