import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../injection_container.dart';
import '../../../home/presentation/pages/main_screen.dart';
import '../../../marketplace/domain/entities/product_entity.dart';
import '../../../marketplace/presentation/bloc/marketplace_cubit.dart';
import '../../../marketplace/presentation/widgets/product_card.dart';
import '../../../../shared/widgets/shimmer_loading.dart';

/// Tab pemilih mode Biomassa / Hasil Tani.
class ProductModeTabSelector extends StatelessWidget {
  final String selectedMode;
  final ValueChanged<String> onModeChanged;
  final bool includeAllTab;

  const ProductModeTabSelector({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
    this.includeAllTab = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md12),
      child: Container(
        height: 46.h,
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(AppRadius.tile),
        ),
        child: Row(
          children: [
            if (includeAllTab)
              Expanded(
                child: _ModeTab(
                  label: 'commerce.tab_all'.tr(),
                  icon: LucideIcons.layoutGrid,
                  mode: 'ALL',
                  selectedMode: selectedMode,
                  onModeChanged: onModeChanged,
                ),
              ),
            Expanded(
              child: _ModeTab(
                label: 'commerce.tab_biomass'.tr(),
                icon: LucideIcons.flame,
                mode: 'BIOMASS_MATERIAL',
                selectedMode: selectedMode,
                onModeChanged: onModeChanged,
              ),
            ),
            Expanded(
              child: _ModeTab(
                label: 'commerce.tab_organic'.tr(),
                icon: LucideIcons.sprout,
                mode: 'ORGANIC_PRODUCE',
                selectedMode: selectedMode,
                onModeChanged: onModeChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final String mode;
  final String selectedMode;
  final ValueChanged<String> onModeChanged;

  const _ModeTab({
    required this.label,
    required this.icon,
    required this.mode,
    required this.selectedMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedMode == mode;
    return GestureDetector(
      onTap: () => onModeChanged(mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.tile),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14.sp,
              color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
            ),
            SizedBox(width: 4.w),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Grid produk per mode — fetch sendiri via [MarketplaceCubit].
class ModeProductGridSection extends StatefulWidget {
  final String productMode;
  final String title;
  final String subtitle;
  final Set<String> excludeIds;
  final int limit;
  final bool showSeeAll;

  const ModeProductGridSection({
    super.key,
    required this.productMode,
    required this.title,
    this.subtitle = '',
    this.excludeIds = const {},
    this.limit = 20,
    this.showSeeAll = true,
  });

  @override
  State<ModeProductGridSection> createState() => _ModeProductGridSectionState();
}

class _ModeProductGridSectionState extends State<ModeProductGridSection> {
  late final MarketplaceCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<MarketplaceCubit>();
    _fetch();
  }

  @override
  void didUpdateWidget(covariant ModeProductGridSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.productMode != widget.productMode ||
        oldWidget.limit != widget.limit) {
      _fetch();
    }
  }

  void _fetch() {
    _cubit.getProducts(
      productMode: widget.productMode,
      sortBy: 'totalSold',
      sortOrder: 'desc',
      limit: widget.limit,
    );
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  IconData get _modeIcon => widget.productMode == 'ORGANIC_PRODUCE'
      ? LucideIcons.sprout
      : LucideIcons.flame;

  Color get _modeColor => widget.productMode == 'ORGANIC_PRODUCE'
      ? AppColors.success
      : AppColors.warning;

  void _openMarketplace() {
    MarketplaceCubit.activeProductMode = widget.productMode;
    final scope = MainShellScope.maybeOf(context);
    if (scope != null) {
      scope.selectTab(0);
      if (context.canPop()) context.pop();
    } else {
      context.go('/?tab=0');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<MarketplaceCubit, MarketplaceState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.xs),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: _modeColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppRadius.button),
                      ),
                      child: Icon(_modeIcon, size: 14.sp, color: _modeColor),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (widget.subtitle.isNotEmpty)
                            Text(
                              widget.subtitle,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (widget.showSeeAll)
                      GestureDetector(
                        onTap: _openMarketplace,
                        child: Text(
                          'commerce.see_all'.tr(),
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
              state.maybeWhen(
                initial: () => _loadingBox(),
                loading: () => _loadingBox(),
                error: (_) => _retryBox(),
                loaded: (products, _) {
                  final filtered = products
                      .where((p) => !widget.excludeIds.contains(p.id))
                      .toList();
                  if (filtered.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                      child: Text(
                        'commerce.no_products_mode'.tr(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xs),
                    child: MasonryGridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: AppSpacing.md12,
                      crossAxisSpacing: AppSpacing.sm10,
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: filtered[index]);
                      },
                    ),
                  );
                },
                orElse: () => const SizedBox.shrink(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _loadingBox() {
    return const ShimmerProductGridPlaceholder(
      itemCount: 4,
      crossAxisCount: 2,
    );
  }

  Widget _retryBox() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: TextButton(
        onPressed: _fetch,
        child: Text('coba_lagi'.tr()),
      ),
    );
  }
}

/// Dua section katalog: Biomassa + Hasil Tani (di bawah rekomendasi).
class DualModeProductCatalog extends StatelessWidget {
  final Set<String> excludeIds;
  final int limitPerMode;

  const DualModeProductCatalog({
    super.key,
    this.excludeIds = const {},
    this.limitPerMode = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ModeProductGridSection(
          productMode: 'BIOMASS_MATERIAL',
          title: 'commerce.catalog_biomass_title'.tr(),
          subtitle: 'commerce.catalog_biomass_subtitle'.tr(),
          excludeIds: excludeIds,
          limit: limitPerMode,
        ),
        SizedBox(height: AppSpacing.sm),
        ModeProductGridSection(
          productMode: 'ORGANIC_PRODUCE',
          title: 'commerce.catalog_organic_title'.tr(),
          subtitle: 'commerce.catalog_organic_subtitle'.tr(),
          excludeIds: excludeIds,
          limit: limitPerMode,
        ),
      ],
    );
  }
}

/// Grid favorit statis (client-side filter by mode).
class WishlistModeProductGrid extends StatelessWidget {
  final List<ProductEntity> products;
  final String title;
  final String? emptyHint;

  const WishlistModeProductGrid({
    super.key,
    required this.products,
    required this.title,
    this.emptyHint,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      if (emptyHint == null) return const SizedBox.shrink();
      return Padding(
        padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xs),
        child: Text(
          emptyHint!,
          style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md12, AppSpacing.md, AppSpacing.sm),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: MasonryGridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.md12,
            crossAxisSpacing: AppSpacing.sm10,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(product: products[index]);
            },
          ),
        ),
      ],
    );
  }
}
