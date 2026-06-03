import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
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
        appBar: const BisaAppBar(
          title: 'Tulis Ulasan',
          backgroundColor: Colors.white,
        ),
        body: BlocConsumer<ReviewCubit, ReviewState>(
          listener: (context, state) {
            state.maybeWhen(
              success: () {
                ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(content: Text('ulasan_berhasil_disimpan'.tr())),
                );
                Navigator.pop(context, {
                  'rating': _rating,
                  'comment': _commentController.text,
                });
              },
              error: (message) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: AppColors.error,
                  ),
                );
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => context.push(
                      '/supplier/${widget.orderId}',
                    ),
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
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
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      widget.shopName ?? 'Supplier',
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
                                        'Supplier Terverifikasi',
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
                  SizedBox(height: 12.h),
                  // Product Info Card (Compact)
                  GestureDetector(
                    onTap: () => context.push('/product/${widget.productId}'),
                    child: Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: AppColors.grey50,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
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
                          SizedBox(width: 10.w),
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
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Berikan Rating',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Ketuk bintang untuk menilai kualitas',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 12.h),
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
                                      ? Colors.amber
                                      : AppColors.grey200,
                                  fill: isSelected ? 1 : 0,
                                  size: 38.sp,
                                ),
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: 8.h),
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
                  SizedBox(height: 16.h),
                  CustomTextField(
                    label: 'Ulasan Anda',
                    hint:
                        'Bagikan pengalaman Anda menggunakan produk ini...',
                    controller: _commentController,
                    maxLines: 4,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 6.h, left: 4.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Minimal 10 karakter',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: _commentController.text.length < 10
                                ? Colors.orange
                                : AppColors.success,
                          ),
                        ),
                        Text(
                          '${_commentController.text.length} karakter',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  CustomButton(
                    text: widget.reviewId != null
                        ? 'Perbarui Ulasan'
                        : 'Kirim Ulasan',
                    useGradient: true,
                    isLoading: state.maybeWhen(
                      loading: () => true,
                      orElse: () => false,
                    ),
                    onPressed: state.maybeWhen(
                      loading: () => null,
                      orElse: () => () {
                        if (_commentController.text.length < 10) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('ulasan_minimal_10_karakter_ya'.tr()),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.orange,
                            ),
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
                  SizedBox(height: 16.h),
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
        return 'Sangat Buruk';
      case 2:
        return 'Buruk';
      case 3:
        return 'Cukup Baik';
      case 4:
        return 'Sangat Baik';
      case 5:
        return 'Luar Biasa!';
      default:
        return '';
    }
  }

  Color _getRatingColor(int rating) {
    switch (rating) {
      case 1:
      case 2:
        return Colors.red;
      case 3:
        return Colors.orange;
      case 4:
      case 5:
        return AppColors.primary;
      default:
        return AppColors.textPrimary;
    }
  }
}
