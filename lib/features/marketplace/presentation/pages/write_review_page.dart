import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_feedback.dart';
import '../bloc/review_cubit.dart';
import '../bloc/review_state.dart';
import '../../../../shared/widgets/bisa_avatar.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../injection_container.dart';

class WriteReviewPage extends StatefulWidget {
  final String productId;
  final String orderId;
  final String productName;
  final String? thumbnailUrl;
  final String? shopName;
  final String? shopRegency;
  final String? shopAvatar;
  final bool isShopVerified;
  final String? reviewId;
  final double? initialRating;
  final String? initialComment;

  const WriteReviewPage({
    super.key,
    required this.productId,
    required this.orderId,
    required this.productName,
    this.thumbnailUrl,
    this.shopName,
    this.shopRegency,
    this.shopAvatar,
    this.isShopVerified = false,
    this.reviewId,
    this.initialRating,
    this.initialComment,
  });

  @override
  State<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  late double _rating;
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating ?? 5.0;
    _commentController = TextEditingController(text: widget.initialComment);
    _commentController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReviewCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BisaAppBar(
          title: 'marketplace.write_review_title'.tr(),
          backgroundColor: AppColors.surface,
        ),
        body: BlocConsumer<ReviewCubit, ReviewState>(
          listener: (context, state) {
            state.maybeWhen(
              success: () {
                showSuccessSnackBar(context, 'marketplace.review_saved');
                Navigator.pop(context, {
                  'rating': _rating,
                  'comment': _commentController.text,
                });
              },
              error: (message) => showErrorSnackBar(context, message),
              orElse: () {},
            );
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md12, vertical: AppSpacing.md12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => context.push(
                      '/supplier/${widget.orderId}',
                    ),
                    child: Container(
                      padding: EdgeInsets.all(AppSpacing.md12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          BisaAvatar(
                            imageUrl: widget.shopAvatar,
                            radius: 22.r,
                            fallbackIcon: LucideIcons.store,
                          ),
                          SizedBox(width: AppSpacing.md12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      widget.shopName ?? 'marketplace.supplier_fallback'.tr(),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    if (widget.isShopVerified) ...[
                                      SizedBox(width: 4.w),
                                      Icon(
                                        LucideIcons.badgeCheck,
                                        color: AppColors.info,
                                        size: 14.sp,
                                      ),
                                    ],
                                  ],
                                ),
                                if (widget.shopRegency != null)
                                  Text(
                                    widget.shopRegency!,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.textSecondary
                                          .withValues(alpha: 0.7),
                                    ),
                                  ),
                                if (widget.isShopVerified)
                                  Row(
                                    children: [
                                      Icon(LucideIcons.shieldCheck,
                                          color: AppColors.primary,
                                          size: 12.sp),
                                      SizedBox(width: 4.w),
                                      Text(
                                        'marketplace.verified_supplier'.tr(),
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          Icon(LucideIcons.chevronRight,
                              color: AppColors.grey400, size: 20.sp),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.md12),
                  // Product Info Card (Compact)
                  GestureDetector(
                    onTap: () => context.push('/product/${widget.productId}'),
                    child: Container(
                      padding: EdgeInsets.all(AppSpacing.sm10),
                      decoration: BoxDecoration(
                        color: AppColors.grey50,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.button),
                            child: widget.thumbnailUrl != null
                                ? BisaNetworkImage(
                                    imageUrl: widget.thumbnailUrl,
                                    width: 40.w,
                                    height: 40.w,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 40.w,
                                    height: 40.w,
                                    color: AppColors.grey200,
                                    child: Icon(LucideIcons.package,
                                        color: AppColors.grey400, size: 18.sp),
                                  ),
                          ),
                          SizedBox(width: AppSpacing.sm10),
                          Expanded(
                            child: Text(
                              widget.productName,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'marketplace.give_rating'.tr(),
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'marketplace.tap_stars_hint'.tr(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: AppSpacing.md12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            final isSelected = index < _rating;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _rating = index + 1.0),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Icon(
                                  LucideIcons.star,
                                  color: isSelected
                                      ? AppColors.warning
                                      : AppColors.grey200,
                                  fill: isSelected ? 1 : 0,
                                  size: 38.sp,
                                ),
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Text(
                          _getRatingLabel(_rating.toInt()),
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: _getRatingColor(_rating.toInt()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  CustomTextField(
                    label: 'marketplace.your_review'.tr(),
                    hint: 'marketplace.review_hint'.tr(),
                    controller: _commentController,
                    maxLines: 4,
                    isRequired: true,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 6.h, left: 4.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'marketplace.min_10_chars'.tr(),
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: _commentController.text.length < 10
                                ? AppColors.warning
                                : AppColors.success,
                          ),
                        ),
                        Text(
                          'marketplace.char_count'.tr(namedArgs: {
                            'count': '${_commentController.text.length}',
                          }),
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl),
                  CustomButton(
                    text: widget.reviewId != null
                        ? 'marketplace.update_review'.tr()
                        : 'marketplace.submit_review'.tr(),
                    useGradient: true,
                    isLoading: state.maybeWhen(
                      loading: () => true,
                      orElse: () => false,
                    ),
                    onPressed: state.maybeWhen(
                      loading: () => null,
                      orElse: () => () {
                        if (_commentController.text.length < 10) {
                          showWarningSnackBar(
                            context,
                            'marketplace.review_min_chars',
                          );
                          return;
                        }
                        if (widget.reviewId != null) {
                          context.read<ReviewCubit>().updateReview(
                                reviewId: widget.reviewId!,
                                rating: _rating,
                                comment: _commentController.text,
                              );
                        } else {
                          context.read<ReviewCubit>().postReview(
                                productId: widget.productId,
                                orderId: widget.orderId,
                                rating: _rating,
                                comment: _commentController.text,
                              );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1:
        return 'marketplace.rating_terrible'.tr();
      case 2:
        return 'marketplace.rating_bad'.tr();
      case 3:
        return 'marketplace.rating_ok'.tr();
      case 4:
        return 'marketplace.rating_good'.tr();
      case 5:
        return 'marketplace.rating_excellent'.tr();
      default:
        return '';
    }
  }

  Color _getRatingColor(int rating) {
    switch (rating) {
      case 1:
      case 2:
        return AppColors.error;
      case 3:
        return AppColors.warning;
      case 4:
      case 5:
        return AppColors.primary;
      default:
        return AppColors.textPrimary;
    }
  }
}
