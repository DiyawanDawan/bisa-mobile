import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/utils/money_format.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/bisa_avatar.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../commerce/presentation/bloc/commerce_cubit.dart';
import '../../../commerce/presentation/widgets/product_add_to_cart_button.dart';
import '../../data/models/review_model.dart';
import '../bloc/marketplace_cubit.dart';

class ReviewDetailPage extends StatelessWidget {
  final ReviewModel review;
  final String productName;

  const ReviewDetailPage({
    super.key,
    required this.review,
    required this.productName,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<MarketplaceCubit>()..getProductById(review.productId),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BisaAppBar(
          title: 'marketplace.review_detail_title'.tr(),
          backgroundColor: AppColors.surface,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ReviewSection(review: review),
              SizedBox(height: AppSpacing.md),
              _ProductSection(
                productId: review.productId,
                productName: productName,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewSection extends StatelessWidget {
  final ReviewModel review;

  const _ReviewSection({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              BisaAvatar(
                imageUrl: review.userAvatar,
                radius: 20.r,
              ),
              SizedBox(width: AppSpacing.sm10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      timeago.format(review.createdAt),
                      style: TextStyle(
                        color: AppColors.textHint,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.rating.round()
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: AppColors.warning,
                    size: 18.sp,
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md12),
          Text(
            review.comment,
            style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
          ),
          if (review.images != null && review.images!.isNotEmpty) ...[
            SizedBox(height: AppSpacing.md12),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: review.images!.map((url) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  child: SizedBox(
                    width: 100.w,
                    height: 100.w,
                    child: BisaNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          if (review.reply != null) ...[
            SizedBox(height: AppSpacing.md12),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSpacing.md12),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'marketplace.seller_reply'.tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    review.reply!,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProductSection extends StatelessWidget {
  final String productId;
  final String productName;

  const _ProductSection({
    required this.productId,
    required this.productName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketplaceCubit, MarketplaceState>(
      builder: (context, state) {
        return state.maybeWhen(
          loaded: (products, _) {
            if (products.isEmpty) {
              return const SizedBox.shrink();
            }
            final product = products.first;
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'marketplace.reviewed_product'.tr(),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md12),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        child: SizedBox(
                          width: 72.w,
                          height: 72.w,
                          child: BisaNetworkImage(
                            imageUrl: product.thumbnailUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: AppSpacing.md12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '${formatMoneyDisplay(product.pricePerUnit)} / ${product.unit}',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ProductAddToCartButton(product: product, size: 18),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.push('/product/$productId'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.grey200),
                          ),
                          child: Text('marketplace.view_product'.tr()),
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm10),
                      Expanded(
                        child: CustomButton(
                          text: 'marketplace.add_to_cart'.tr(),
                          onPressed: () async {
                            final ok = await context
                                .read<CommerceCubit>()
                                .addToCart(product.id, product.minOrder);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  ok
                                      ? 'commerce.add_to_cart_success'.tr()
                                      : 'commerce.add_to_cart_failed'.tr(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (message) => Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(color: AppColors.grey200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'marketplace.reviewed_product'.tr(),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppSpacing.sm10),
                Text(productName, style: TextStyle(fontSize: 14.sp)),
                SizedBox(height: AppSpacing.md12),
                OutlinedButton(
                  onPressed: () => context.push('/product/$productId'),
                  child: Text('marketplace.view_product'.tr()),
                ),
              ],
            ),
          ),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }
}
