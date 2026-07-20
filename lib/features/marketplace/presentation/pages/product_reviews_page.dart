import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_layout.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/utils/media_url_utils.dart';
import 'package:mobile_bisa/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:mobile_bisa/features/marketplace/presentation/bloc/review_cubit.dart';
import 'package:mobile_bisa/features/marketplace/presentation/bloc/review_state.dart';
import 'package:mobile_bisa/shared/widgets/bisa_app_bar.dart';
import 'package:mobile_bisa/shared/widgets/bisa_network_image.dart';
import 'package:mobile_bisa/shared/widgets/shimmer_loading.dart';
import 'package:mobile_bisa/injection_container.dart';
import 'package:mobile_bisa/features/marketplace/data/models/review_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProductReviewsPage extends StatefulWidget {
  final String productId;
  final String productName;

  const ProductReviewsPage({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  State<ProductReviewsPage> createState() => _ProductReviewsPageState();
}

class _ProductReviewsPageState extends State<ProductReviewsPage> {
  int? _selectedRating;
  bool _hasMediaOnly = false;

  void _reloadReviews(ReviewCubit cubit) {
    cubit.getProductReviews(
      widget.productId,
      rating: _selectedRating,
      hasMedia: _hasMediaOnly ? true : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReviewCubit>()..getProductReviews(widget.productId),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: BisaAppBar(
              title: 'marketplace.product_reviews_title'.tr(),
              backgroundColor: AppColors.surface,
            ),
            body: Column(
              children: [
                _ReviewFilterBar(
                  selectedRating: _selectedRating,
                  hasMediaOnly: _hasMediaOnly,
                  onRatingChanged: (rating) {
                    setState(() {
                      _selectedRating = rating;
                      _hasMediaOnly = false;
                    });
                    _reloadReviews(context.read<ReviewCubit>());
                  },
                  onMediaFilter: () {
                    setState(() {
                      _hasMediaOnly = !_hasMediaOnly;
                      if (_hasMediaOnly) _selectedRating = null;
                    });
                    _reloadReviews(context.read<ReviewCubit>());
                  },
                ),
                Expanded(
                  child: BlocBuilder<ReviewCubit, ReviewState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        loading: () => const Center(
                          child: ShimmerListPlaceholder(itemCount: 5, itemHeight: 88),
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
                          if (reviews.isEmpty) {
                            return _buildEmptyState(
                              hasFilter:
                                  _selectedRating != null || _hasMediaOnly,
                            );
                          }
                          return ListView.separated(
                            padding: EdgeInsets.fromLTRB(
                              AppSpacing.md,
                              AppSpacing.sm,
                              AppSpacing.md,
                              AppSpacing.lg,
                            ),
                            itemCount: reviews.length,
                            separatorBuilder: (_, __) =>
                                SizedBox(height: AppSpacing.md),
                            itemBuilder: (context, index) {
                              return _ReviewCard(
                                review: reviews[index],
                                productId: widget.productId,
                                productName: widget.productName,
                              );
                            },
                          );
                        },
                        orElse: () => const SizedBox.shrink(),
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

  Widget _buildEmptyState({required bool hasFilter}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.star, size: 64.sp, color: AppColors.grey200),
          SizedBox(height: AppSpacing.md),
          Text(
            hasFilter
                ? 'marketplace.no_reviews_filter'.tr()
                : 'marketplace.no_reviews_product'.tr(),
            style: TextStyle(color: AppColors.textHint, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}

class _ReviewFilterBar extends StatelessWidget {
  final int? selectedRating;
  final bool hasMediaOnly;
  final ValueChanged<int?> onRatingChanged;
  final VoidCallback onMediaFilter;

  const _ReviewFilterBar({
    required this.selectedRating,
    required this.hasMediaOnly,
    required this.onRatingChanged,
    required this.onMediaFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm10,
        AppSpacing.md,
        AppSpacing.sm10,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _FilterChip(
              label: 'marketplace.reviews_filter_all'.tr(),
              selected: selectedRating == null && !hasMediaOnly,
              onTap: () => onRatingChanged(null),
            ),
            for (final stars in [5, 4, 3, 2, 1])
              _FilterChip(
                label: 'marketplace.reviews_filter_star'.tr(
                  namedArgs: {'count': '$stars'},
                ),
                selected: selectedRating == stars,
                onTap: () => onRatingChanged(stars),
              ),
            _FilterChip(
              label: 'marketplace.reviews_filter_media'.tr(),
              selected: hasMediaOnly,
              icon: LucideIcons.image,
              onTap: onMediaFilter,
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14.sp,
                color: selected ? AppColors.textOnPrimary : AppColors.textSecondary,
              ),
              SizedBox(width: 4.w),
            ],
            Text(label),
          ],
        ),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.primary,
        checkmarkColor: AppColors.textOnPrimary,
        labelStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: selected ? AppColors.textOnPrimary : AppColors.textSecondary,
        ),
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.grey200,
        ),
        padding: EdgeInsets.symmetric(horizontal: 4.w),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ReviewModel review;
  final String productId;
  final String productName;

  const _ReviewCard({
    required this.review,
    required this.productId,
    required this.productName,
  });

  void _openDetail(BuildContext context) {
    context.push(
      '/product-reviews/$productId/review/${review.id}',
      extra: {
        'review': review,
        'productName': productName,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    final isSupplier = authState.maybeWhen(
      authenticated: (user) => user.role == 'SUPPLIER',
      orElse: () => false,
    );

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        onTap: () => _openDetail(context),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Container(
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.grey200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18.r,
                    backgroundImage: resolveMediaImageProvider(review.userAvatar),
                    child: review.userAvatar == null
                        ? const Icon(LucideIcons.user, size: 18)
                        : null,
                  ),
                  SizedBox(width: AppSpacing.md12),
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
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < review.rating
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
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
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13.sp, color: AppColors.textPrimary),
              ),
              if (review.images != null && review.images!.isNotEmpty) ...[
                SizedBox(height: AppSpacing.md12),
                SizedBox(
                  height: 72.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: review.images!.length,
                    separatorBuilder: (_, __) => SizedBox(width: 8.w),
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        child: SizedBox(
                          width: 72.w,
                          height: 72.h,
                          child: BisaNetworkImage(
                            imageUrl: review.images![index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
              if (review.reply != null) ...[
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
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 11.sp,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        review.reply!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (isSupplier && review.reply == null) ...[
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
        ),
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
          TextButton(
            onPressed: () => Navigator.pop(dContext),
            child: Text('batal'.tr()),
          ),
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
