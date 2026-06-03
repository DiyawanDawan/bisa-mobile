import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  const HorizontalProductSection({
    super.key,
    required this.title,
    required this.onShowAll,
    this.sortBy,
    this.sortOrder,
    this.limit = 10,
    this.collectionSlug,
    this.productMode,
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
      );
    }
  }

  @override
  void didUpdateWidget(covariant HorizontalProductSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.productMode != widget.productMode) {
      _fetchData();
    }
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
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
              height: 220.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: 3,
                separatorBuilder: (_, __) => SizedBox(width: 12.w),
                itemBuilder: (_, __) => SizedBox(
                  width: 160.w,
                  child: const ProductCardSkeleton(showSellerInfo: true),
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var i = 0; i < products.length; i++) ...[
                            if (i > 0) SizedBox(width: 8.w),
                            SizedBox(
                              width: 165.w,
                              child: ProductCard(
                                product: products[i],
                                imageHeight: 120.h,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              );
            },
            error: (message) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
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
