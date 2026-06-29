import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_layout.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/utils/media_url_utils.dart';
import 'package:mobile_bisa/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:mobile_bisa/features/marketplace/presentation/bloc/review_cubit.dart';
import 'package:mobile_bisa/features/marketplace/presentation/bloc/review_state.dart';
import 'package:mobile_bisa/shared/widgets/bisa_app_bar.dart';
import 'package:mobile_bisa/shared/widgets/shimmer_loading.dart';
import 'package:mobile_bisa/injection_container.dart';
import 'package:mobile_bisa/features/marketplace/data/models/review_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProductReviewsPage extends StatelessWidget {
  final String productId;
  final String productName;

  const ProductReviewsPage({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReviewCubit>()..getProductReviews(productId),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BisaAppBar(
          title: 'marketplace.product_reviews_title'.tr(),
          backgroundColor: AppColors.surface,
        ),
        body: BlocBuilder<ReviewCubit, ReviewState>(
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => const Center(
                child: const ShimmerListPlaceholder(itemCount: 5, itemHeight: 88),
              ),
              error: (message) => Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.circleAlert,
                        size: 48.sp,
                        color: AppColors.error,
                      ),
                      SizedBox(height: AppSpacing.md12),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              loaded: (reviews) {
                if (reviews.isEmpty) return _buildEmptyState();
                return ListView.separated(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  itemCount: reviews.length,
                  separatorBuilder: (_, __) => SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    return _ReviewCard(review: reviews[index], productId: productId);
                  },
                );
              },
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.star, size: 64.sp, color: AppColors.grey200),
          SizedBox(height: AppSpacing.md),
          Text(
            'marketplace.no_reviews_product'.tr(),
            style: TextStyle(color: AppColors.textHint, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ReviewModel review;
  final String productId;

  const _ReviewCard({required this.review, required this.productId});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    final isSupplier = authState.maybeWhen(
      authenticated: (user) => user.role == 'SUPPLIER',
      orElse: () => false,
    );

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundImage: resolveMediaImageProvider(review.userAvatar),
                child: review.userAvatar == null ? const Icon(LucideIcons.user, size: 18) : null,
              ),
              SizedBox(width: AppSpacing.md12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14.sp),
                    ),
                    Text(
                      timeago.format(review.createdAt),
                      style: TextStyle(color: AppColors.textHint, fontSize: 10.sp),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.rating ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: AppColors.warning,
                    size: 16.sp,
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md12),
          Text(
            review.comment,
            style: TextStyle(fontSize: 13.sp, color: AppColors.textPrimary),
          ),
          if ((review as dynamic).reply != null) ...[
            SizedBox(height: AppSpacing.md12),
            Container(
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
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11.sp, color: AppColors.primary),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    (review as dynamic).reply!,
                    style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
          if (isSupplier && (review as dynamic).reply == null) ...[
            SizedBox(height: AppSpacing.md12),
            TextButton.icon(
              onPressed: () => _showReplyDialog(context),
              icon: const Icon(LucideIcons.reply, size: 16),
              label: Text('marketplace.reply_review'.tr()),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showReplyDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dContext) => AlertDialog(
        title: Text('marketplace.reply_review'.tr()),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(hintText: 'marketplace.reply_hint'.tr()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dContext), child:  Text('batal'.tr())),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Navigator.pop(dContext);
                context.read<ReviewCubit>().replyReview(
                  reviewId: review.id,
                  productId: productId,
                  reply: controller.text,
                );
              }
            },
            child: Text('kirim'.tr()),
          ),
        ],
      ),
    );
  }
}
