import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_bisa/core/constants/app_layout.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/features/marketplace/presentation/bloc/marketplace_cubit.dart';
import 'package:mobile_bisa/features/marketplace/presentation/widgets/product_card.dart';
import 'package:mobile_bisa/shared/widgets/product_card_skeleton.dart';
import 'package:mobile_bisa/injection_container.dart';

class HorizontalProductSection extends StatefulWidget {
  final String title;
  final VoidCallback onShowAll;
  final String? sortBy;
  final String? sortOrder;
  final int limit;
  final String? collectionSlug;
  final String? productMode;
  final String? biomassaType;
  final String? categoryId;

  const HorizontalProductSection({
    super.key,
    required this.title,
    required this.onShowAll,
    this.sortBy,
    this.sortOrder,
    this.limit = 10,
    this.collectionSlug,
    this.productMode,
    this.biomassaType,
    this.categoryId,
  });

  @override
  State<HorizontalProductSection> createState() =>
      _HorizontalProductSectionState();
}

class _HorizontalProductSectionState extends State<HorizontalProductSection> {
  late final MarketplaceCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<MarketplaceCubit>();
    _fetchData();
  }

  void _fetchData() {
    if (widget.collectionSlug != null) {
      _cubit.getProductsByCollection(
        widget.collectionSlug!,
        limit: widget.limit,
      );
    } else {
      _cubit.getProducts(
        sortBy: widget.sortBy,
        sortOrder: widget.sortOrder,
        limit: widget.limit,
        productMode: widget.productMode,
        biomassaType: widget.productMode == 'BIOMASS_MATERIAL'
            ? widget.biomassaType
            : null,
        categoryId: widget.categoryId,
      );
    }
  }

  @override
  void didUpdateWidget(covariant HorizontalProductSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.productMode != widget.productMode ||
        oldWidget.biomassaType != widget.biomassaType ||
        oldWidget.categoryId != widget.categoryId ||
        oldWidget.sortBy != widget.sortBy ||
        oldWidget.sortOrder != widget.sortOrder) {
      _fetchData();
    }
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Widget _buildHorizontalCard({required Widget child}) {
    return SizedBox(
      width: ProductCard.horizontalWidth,
      height: ProductCard.horizontalViewportHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<MarketplaceCubit, MarketplaceState>(
        builder: (context, state) {
          return state.maybeWhen(
            initial: () => const SizedBox.shrink(),
            loading: () => SizedBox(
              height: ProductCard.horizontalViewportHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                itemCount: 3,
                separatorBuilder: (_, __) => SizedBox(width: AppSpacing.sm),
                itemBuilder: (_, __) => _buildHorizontalCard(
                  child: ProductCardSkeleton(
                    imageHeight: ProductCard.horizontalImageHeight,
                    showSellerInfo: true,
                  ),
                ),
              ),
            ),
            loaded: (products, _) {
              if (products.isEmpty) return const SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.onShowAll,
                          child: Text(
                            'marketplace.show_all'.tr(),
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
                  SizedBox(
                    height: ProductCard.horizontalViewportHeight,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      itemCount: products.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(width: AppSpacing.sm),
                      itemBuilder: (context, i) => _buildHorizontalCard(
                        child: ProductCard(
                          product: products[i],
                          imageHeight: ProductCard.horizontalImageHeight,
                          compact: true,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm10),
                ],
              );
            },
            error: (message) => Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: Text(
                message,
                style: TextStyle(fontSize: 12.sp, color: AppColors.error),
              ),
            ),
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
