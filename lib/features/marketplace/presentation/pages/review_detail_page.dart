import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/utils/money_format.dart';
import '../../../../core/utils/safe_area_utils.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/bisa_avatar.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../../commerce/presentation/bloc/commerce_cubit.dart';
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
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: BisaAppBar(
              title: 'marketplace.review_detail_title'.tr(),
              backgroundColor: AppColors.surface,
            ),
            bottomNavigationBar: _BottomActionBar(productId: review.productId),
            body: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ReviewSection(review: review),
                  SizedBox(height: 8.h),
                  _ProductSection(
                    productId: review.productId,
                    productName: productName,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Bar aksi sticky gaya Shopee: outline "Lihat Produk" + solid "+ Keranjang".
class _BottomActionBar extends StatelessWidget {
  final String productId;

  const _BottomActionBar({required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketplaceCubit, MarketplaceState>(
      builder: (context, state) {
        final product = state.maybeWhen(
          loaded: (products, _) => products.isEmpty ? null : products.first,
          orElse: () => null,
        );

        return Material(
          color: AppColors.surface,
          elevation: 12,
          shadowColor: AppColors.black.withValues(alpha: 0.08),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm10,
                AppSpacing.md,
                AppSpacing.sm10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: AppSpacing.buttonHeight,
                      child: OutlinedButton.icon(
                        onPressed: () => context.push('/product/$productId'),
                        icon: Icon(LucideIcons.eye, size: 16.sp),
                        label: Text(
                          'marketplace.view_product'.tr(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          textStyle: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm10),
                  Expanded(
                    child: SizedBox(
                      height: AppSpacing.buttonHeight,
                      child: ElevatedButton.icon(
                        onPressed: product == null
                            ? null
                            : () async {
                                final ok = await context
                                    .read<CommerceCubit>()
                                    .addToCart(product.id, product.minOrder);
                                if (!context.mounted) return;
                                showBisaSnackBarMessage(
                                  context,
                                  ok
                                      ? 'commerce.add_to_cart_success'.tr()
                                      : 'commerce.add_to_cart_failed'.tr(),
                                  isError: !ok,
                                );
                              },
                        icon: Icon(LucideIcons.shoppingCart, size: 16.sp),
                        label: Text(
                          'marketplace.add_to_cart_short'.tr(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textOnPrimary,
                          disabledBackgroundColor: AppColors.grey200,
                          elevation: 0,
                          textStyle: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
      color: AppColors.surface,
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BisaAvatar(
                imageUrl: review.userAvatar,
                radius: 16.r,
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
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < review.rating.round()
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: AppColors.warning,
                          size: 14.sp,
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Text(
                timeago.format(review.createdAt),
                style: TextStyle(
                  color: AppColors.textHint,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm10),
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
          if (review.images != null && review.images!.isNotEmpty) ...[
            SizedBox(height: AppSpacing.sm10),
            _ReviewImageGrid(images: review.images!),
          ],
          if (review.reply != null) ...[
            SizedBox(height: AppSpacing.sm10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSpacing.md12),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'marketplace.seller_reply'.tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 11.sp,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    review.reply!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                      height: 1.4,
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

/// Grid foto ulasan 3 kolom gaya Shopee (kotak besar, rata lebar).
class _ReviewImageGrid extends StatelessWidget {
  final List<String> images;

  const _ReviewImageGrid({required this.images});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gap = 6.w;
        final size = (constraints.maxWidth - gap * 2) / 3;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: images.map((url) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: SizedBox(
                width: size,
                height: size,
                child: BisaNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                ),
              ),
            );
          }).toList(),
        );
      },
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
            return Material(
              color: AppColors.surface,
              child: InkWell(
                onTap: () => context.push('/product/$productId'),
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'marketplace.reviewed_product'.tr(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm10),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            child: SizedBox(
                              width: 64.w,
                              height: 64.w,
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
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    height: 1.3,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  '${formatMoneyDisplay(product.pricePerUnit)} / ${product.unit}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            LucideIcons.chevronRight,
                            size: 18.sp,
                            color: AppColors.textHint,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          loading: () => Container(
            color: AppColors.surface,
            padding: EdgeInsets.all(AppSpacing.xl),
            child: const Center(child: CircularProgressIndicator()),
          ),
          error: (message) => Material(
            color: AppColors.surface,
            child: InkWell(
              onTap: () => context.push('/product/$productId'),
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'marketplace.reviewed_product'.tr(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            productName,
                            style: TextStyle(fontSize: 13.sp),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      LucideIcons.chevronRight,
                      size: 18.sp,
                      color: AppColors.textHint,
                    ),
                  ],
                ),
              ),
            ),
          ),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }
}
