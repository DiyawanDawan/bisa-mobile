import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../bloc/marketplace_cubit.dart';
import '../bloc/category_cubit.dart';
import '../bloc/category_state.dart';
import '../../data/models/category_model.dart';
import '../widgets/supplier_product_tile.dart';
import '../../../../shared/widgets/supplier_product_tile_skeleton.dart';
import '../widgets/supplier_product_filter_sheet.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/bisa_search_field.dart';
import '../../../../shared/widgets/notification_bell_button.dart';

class SupplierProductListPage extends StatefulWidget {
  const SupplierProductListPage({super.key});

  @override
  State<SupplierProductListPage> createState() =>
      _SupplierProductListPageState();
}

class _SupplierProductListPageState extends State<SupplierProductListPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedStatus;
  String? _selectedCategoryId;
  String _sortKey = 'newest';
  Timer? _debounce;

  static const _statusLabels = <String?, String>{
    null: 'Semua Status',
    'ACTIVE': 'Aktif',
    'DRAFT': 'Draft',
    'OUT_OF_STOCK': 'Stok Habis',
    'INACTIVE': 'Non-aktif',
  };

  static const _sortLabels = <String, String>{
    'newest': 'Terbaru',
    'priceAsc': 'Harga Terendah',
    'priceDesc': 'Harga Tertinggi',
    'sold': 'Terlaris',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CategoryCubit>().getCategories();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _reloadProducts(
    BuildContext blocContext,
    String? userId, {
    bool refresh = true,
  }) {
    final sort = resolveSupplierProductSort(_sortKey);
    blocContext.read<MarketplaceCubit>().getProducts(
          userId: userId,
          search: _searchController.text,
          status: _selectedStatus,
          categoryId: _selectedCategoryId,
          sortBy: sort.sortBy,
          sortOrder: sort.sortOrder,
          refresh: refresh,
        );
  }

  void _onSearchChanged(BuildContext blocContext, String? userId) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!blocContext.mounted) return;
      _reloadProducts(blocContext, userId);
    });
  }

  void _openFilterSheet(BuildContext blocContext, String? userId) {
    final categories = blocContext.read<CategoryCubit>().state;
    final list = categories is CategoryLoaded
        ? categories.categories
        : <CategoryModel>[];

    SupplierProductFilterSheet.show(
      blocContext,
      status: _selectedStatus,
      categoryId: _selectedCategoryId,
      sortKey: _sortKey,
      categories: list,
      onApply: ({required status, required categoryId, required sortKey}) {
        setState(() {
          _selectedStatus = status;
          _selectedCategoryId = categoryId;
          _sortKey = sortKey;
        });
        _reloadProducts(blocContext, userId);
      },
    );
  }

  int get _activeFilterCount => countActiveSupplierProductFilters(
        status: _selectedStatus,
        categoryId: _selectedCategoryId,
        sortKey: _sortKey,
      );

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u,
          orElse: () => null,
        );

    return BlocProvider(
      create: (context) =>
          sl<MarketplaceCubit>()..getProducts(userId: user?.id),
      child: Builder(
        builder: (blocContext) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: BisaAppBar(
              backgroundColor: AppColors.surface,
              title: 'Semua Produk',
              actions: [
                const NotificationBellButton(),
                BisaAppBarAction(
                  icon: LucideIcons.plus,
                  onTap: () => blocContext.push('/add-product'),
                  iconColor: AppColors.primary,
                ),
              ],
            ),
            body: Column(
              children: [
                _buildFilters(blocContext, user?.id),
                Expanded(
                  child: BlocBuilder<MarketplaceCubit, MarketplaceState>(
                    builder: (context, state) {
                      return state.when(
                        initial: () => const SizedBox.shrink(),
                        loading: () => ListView.separated(
                          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
                          itemCount: 5,
                          separatorBuilder: (_, __) => SizedBox(height: 10.h),
                          itemBuilder: (_, __) =>
                              const SupplierProductTileSkeleton(),
                        ),
                        error: (message) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(message, textAlign: TextAlign.center),
                            TextButton(
                              onPressed: () =>
                                  _reloadProducts(blocContext, user?.id),
                              child: Text('coba_lagi'.tr()),
                            ),
                          ],
                        ),
                        suppliersLoaded: (_) => const SizedBox.shrink(),
                        collectionsLoaded: (_) => const SizedBox.shrink(),
                        loaded: (products, hasReachedMax) {
                          if (products.isEmpty) {
                            return RefreshIndicator(
                              onRefresh: () async => _reloadProducts(
                                blocContext,
                                user?.id,
                                refresh: false,
                              ),
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Container(
                                  height: 0.6.sh,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        LucideIcons.packageSearch,
                                        size: 64.r,
                                        color: AppColors.grey200,
                                      ),
                                      SizedBox(height: 16.h),
                                      Text(
                                        'Belum ada produk'.tr(),
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          return RefreshIndicator(
                            onRefresh: () async => _reloadProducts(
                              blocContext,
                              user?.id,
                              refresh: false,
                            ),
                            child: ListView.separated(
                              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
                              itemCount: products.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: 10.h),
                              itemBuilder: (context, index) {
                                final product = products[index];
                                return SupplierProductTile(
                                  product: product,
                                  onTap: () async {
                                    await blocContext.push(
                                      '/product-manage/${product.id}',
                                    );
                                    if (blocContext.mounted) {
                                      _reloadProducts(
                                        blocContext,
                                        user?.id,
                                      );
                                    }
                                  },
                                  onEdit: () => blocContext.push(
                                    '/edit-product',
                                    extra: product,
                                  ),
                                  onDelete: () =>
                                      showSupplierDeleteProductDialog(
                                    context: blocContext,
                                    product: product,
                                    onConfirm: () => blocContext
                                        .read<MarketplaceCubit>()
                                        .deleteProduct(product.id),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilters(BuildContext blocContext, String? userId) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: BisaSearchField(
                  controller: _searchController,
                  hint: 'Cari produk Anda...',
                  onChanged: (_) => _onSearchChanged(blocContext, userId),
                ),
              ),
              SizedBox(width: 10.w),
              _FilterMenuButton(
                activeCount: _activeFilterCount,
                onTap: () => _openFilterSheet(blocContext, userId),
              ),
            ],
          ),
          if (_activeFilterCount > 0) ...[
            SizedBox(height: 8.h),
            _buildActiveFilterSummary(blocContext, userId),
          ],
        ],
      ),
    );
  }

  Widget _buildActiveFilterSummary(BuildContext blocContext, String? userId) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        final categories =
            state is CategoryLoaded ? state.categories : const [];
        final chips = <Widget>[];

        if (_selectedStatus != null) {
          chips.add(
            _ActiveFilterChip(
              label: _statusLabels[_selectedStatus] ?? _selectedStatus!,
              onClear: () {
                setState(() => _selectedStatus = null);
                _reloadProducts(blocContext, userId);
              },
            ),
          );
        }

        if (_selectedCategoryId != null) {
          String? categoryName;
          for (final c in categories) {
            if (c.id == _selectedCategoryId) {
              categoryName = c.name;
              break;
            }
          }
          if (categoryName != null) {
            chips.add(
              _ActiveFilterChip(
                label: categoryName,
                onClear: () {
                  setState(() => _selectedCategoryId = null);
                  _reloadProducts(blocContext, userId);
                },
              ),
            );
          }
        }

        if (_sortKey != 'newest') {
          chips.add(
            _ActiveFilterChip(
              label: _sortLabels[_sortKey] ?? _sortKey,
              onClear: () {
                setState(() => _sortKey = 'newest');
                _reloadProducts(blocContext, userId);
              },
            ),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: chips),
        );
      },
    );
  }
}

class _FilterMenuButton extends StatelessWidget {
  const _FilterMenuButton({
    required this.activeCount,
    required this.onTap,
  });

  final int activeCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.28),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              LucideIcons.listFilter,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
          if (activeCount > 0)
            Positioned(
              top: -4.h,
              right: -4.w,
              child: Container(
                padding: EdgeInsets.all(4.r),
                constraints: BoxConstraints(minWidth: 18.w, minHeight: 18.h),
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$activeCount',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ActiveFilterChip extends StatelessWidget {
  const _ActiveFilterChip({
    required this.label,
    required this.onClear,
  });

  final String label;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.primaryLight.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
            SizedBox(width: 4.w),
            GestureDetector(
              onTap: onClear,
              child: Icon(
                LucideIcons.x,
                size: 14.sp,
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
