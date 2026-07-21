import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_layout.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/utils/media_url_utils.dart';
import 'package:mobile_bisa/core/utils/safe_area_utils.dart';
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

  /// Cache list tanpa filter — dipakai buat ringkasan skor & jumlah di chip.
  List<ReviewModel>? _allReviews;

  bool get _hasFilter => _selectedRating != null || _hasMediaOnly;

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
            backgroundColor: AppColors.surface,
            appBar: BisaAppBar(
              title: 'marketplace.product_reviews_title'.tr(),
              backgroundColor: AppColors.surface,
            ),
            body: BlocConsumer<ReviewCubit, ReviewState>(
              listener: (context, state) {
                state.maybeWhen(
                  loaded: (reviews) {
                    if (!_hasFilter) {
                      setState(() => _allReviews = reviews);
                    }
                  },
                  orElse: () {},
                );
              },
              builder: (context, state) {
                return Column(
                  children: [
                    if (_allReviews != null && _allReviews!.isNotEmpty) ...[
                      _RatingSummaryHeader(reviews: _allReviews!),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.grey100,
                      ),
                    ],
                    _ReviewFilterBar(
                      allReviews: _allReviews ?? const [],
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
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.grey100,
                    ),
                    Expanded(child: _buildBody(state)),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(ReviewState state) {
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
          return _buildEmptyState(hasFilter: _hasFilter);
        }
        return ListView.separated(
          padding: EdgeInsets.only(
            bottom: AppSpacing.lg + systemBottomInset(context),
          ),
          itemCount: reviews.length,
          separatorBuilder: (_, __) => Divider(
            height: 1,
            thickness: 1,
            color: AppColors.grey100,
            indent: AppSpacing.md,
            endIndent: AppSpacing.md,
          ),
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

/// Header ringkasan gaya Shopee: skor besar + bintang di kiri,
/// bar distribusi rating di kanan.
class _RatingSummaryHeader extends StatelessWidget {
  final List<ReviewModel> reviews;

  const _RatingSummaryHeader({required this.reviews});

  @override
  Widget build(BuildContext context) {
    final total = reviews.length;
    final avg = reviews.fold<double>(0, (sum, r) => sum + r.rating) / total;
    final counts = List<int>.generate(
      5,
      (i) => reviews.where((r) => r.rating.round() == 5 - i).length,
    );

    return Container(
      width: double.infinity,
      color: AppColors.surface,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    avg.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      height: 1,
                    ),
                  ),
                  Text(
                    ' / 5',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < avg.round()
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: AppColors.warning,
                    size: 18.sp,
                  );
                }),
              ),
              SizedBox(height: 4.h),
              Text(
                'marketplace.reviews_with_count'
                    .tr(namedArgs: {'count': '$total'}),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
          SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              children: List.generate(5, (i) {
                final stars = 5 - i;
                final count = counts[i];
                final fraction = total == 0 ? 0.0 : count / total;
                return Padding(
                  padding: EdgeInsets.only(bottom: i == 4 ? 0 : 4.h),
                  child: Row(
                    children: [
                      Text(
                        '$stars',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Icon(
                        Icons.star_rounded,
                        size: 10.sp,
                        color: AppColors.warning,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.r),
                          child: LinearProgressIndicator(
                            value: fraction,
                            minHeight: 5.h,
                            backgroundColor: AppColors.grey100,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.warning,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      SizedBox(
                        width: 24.w,
                        child: Text(
                          '$count',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.textHint,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

/// Chip filter gaya Shopee: kotak rounded kecil dengan jumlah,
/// selected = border + teks primary di atas primaryLight.
class _ReviewFilterBar extends StatelessWidget {
  final List<ReviewModel> allReviews;
  final int? selectedRating;
  final bool hasMediaOnly;
  final ValueChanged<int?> onRatingChanged;
  final VoidCallback onMediaFilter;

  const _ReviewFilterBar({
    required this.allReviews,
    required this.selectedRating,
    required this.hasMediaOnly,
    required this.onRatingChanged,
    required this.onMediaFilter,
  });

  int _starCount(int stars) =>
      allReviews.where((r) => r.rating.round() == stars).length;

  int get _mediaCount =>
      allReviews.where((r) => r.images != null && r.images!.isNotEmpty).length;

  @override
  Widget build(BuildContext context) {
    final total = allReviews.length;

    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 46.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              children: [
                _ShopeeChip(
                  label: 'marketplace.reviews_filter_all'.tr(),
                  count: total,
                  selected: selectedRating == null && !hasMediaOnly,
                  onTap: () => onRatingChanged(null),
                ),
                _ShopeeChip(
                  label: 'marketplace.reviews_filter_media'.tr(),
                  count: _mediaCount,
                  icon: LucideIcons.image,
                  selected: hasMediaOnly,
                  onTap: onMediaFilter,
                ),
                for (final stars in [5, 4, 3, 2, 1])
                  _ShopeeChip(
                    label: '$stars ★',
                    count: _starCount(stars),
                    selected: selectedRating == stars,
                    onTap: () => onRatingChanged(stars),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Chip filter dua baris gaya Shopee: label di atas, jumlah "(N)" di bawah.
/// Tinggi seragam; selected = border + teks primary.
class _ShopeeChip extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  const _ShopeeChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textSecondary;

    return Padding(
      padding: EdgeInsets.only(right: AppSpacing.sm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Container(
          constraints: BoxConstraints(minWidth: 64.w),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryLight : AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.grey200,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 12.sp, color: color),
                    SizedBox(width: 4.w),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Text(
                '($count)',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: selected ? AppColors.primary : AppColors.textHint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Kartu ulasan flat gaya Shopee: full-width putih, avatar + nama + bintang,
/// isi ulasan, grid foto besar, balasan penjual.
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
      child: InkWell(
        onTap: () => _openDetail(context),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 16.r,
                    backgroundColor: AppColors.grey100,
                    backgroundImage: resolveMediaImageProvider(review.userAvatar),
                    child: review.userAvatar == null
                        ? const Icon(
                            LucideIcons.user,
                            size: 16,
                            color: AppColors.textHint,
                          )
                        : null,
                  ),
                  SizedBox(width: AppSpacing.sm10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.userName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < review.rating
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
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textPrimary,
                  height: 1.45,
                ),
              ),
              if (review.images != null && review.images!.isNotEmpty) ...[
                SizedBox(height: AppSpacing.sm10),
                _ReviewImageGrid(
                  images: review.images!,
                  onTap: () => _openDetail(context),
                ),
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
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
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
              if (isSupplier && review.reply == null) ...[
                SizedBox(height: AppSpacing.sm10),
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

/// Grid foto ulasan gaya Shopee: kotak besar 3 kolom,
/// foto ke-3 dapat overlay "+N" kalau masih ada sisa.
class _ReviewImageGrid extends StatelessWidget {
  final List<String> images;
  final VoidCallback onTap;

  const _ReviewImageGrid({required this.images, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gap = 6.w;
        final size = (constraints.maxWidth - gap * 2) / 3;
        final visible = images.length > 3 ? 3 : images.length;
        final remaining = images.length - visible;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: List.generate(visible, (index) {
            final isLastWithMore = index == visible - 1 && remaining > 0;
            return GestureDetector(
              onTap: onTap,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: SizedBox(
                  width: size,
                  height: size,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      BisaNetworkImage(
                        imageUrl: images[index],
                        fit: BoxFit.cover,
                      ),
                      if (isLastWithMore)
                        Container(
                          color: AppColors.textPrimary.withValues(alpha: 0.45),
                          alignment: Alignment.center,
                          child: Text(
                            '+$remaining',
                            style: TextStyle(
                              color: AppColors.textOnPrimary,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
