import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/core.dart';

enum VerificationGuideType { ktp, selfie, nib, siup }

class VerificationPhotoGuide extends StatelessWidget {
  const VerificationPhotoGuide({super.key, required this.type});

  final VerificationGuideType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.image, size: 16.sp, color: AppColors.primary),
              SizedBox(width: 6.w),
              Text(
                'verification.guide_title'.tr(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildGoodExample()),
              SizedBox(width: 10.w),
              Expanded(child: _buildBadExample()),
            ],
          ),
          SizedBox(height: 10.h),
          ..._tipKeys.map(
            (tipKey) => Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    LucideIcons.circleCheck,
                    size: 14.sp,
                    color: AppColors.success,
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      tipKey.tr(),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> get _tipKeys {
    switch (type) {
      case VerificationGuideType.ktp:
        return const [
          'verification.guide_ktp_tip_1',
          'verification.guide_ktp_tip_2',
          'verification.guide_ktp_tip_3',
        ];
      case VerificationGuideType.selfie:
        return const [
          'verification.guide_selfie_tip_1',
          'verification.guide_selfie_tip_2',
          'verification.guide_selfie_tip_3',
        ];
      case VerificationGuideType.nib:
        return const [
          'verification.guide_nib_tip_1',
          'verification.guide_nib_tip_2',
        ];
      case VerificationGuideType.siup:
        return const [
          'verification.guide_siup_tip_1',
          'verification.guide_siup_tip_2',
        ];
    }
  }

  Widget _buildGoodExample() {
    return Column(
      children: [
        _exampleFrame(
          borderColor: AppColors.success,
          label: 'verification.guide_good'.tr(),
          labelColor: AppColors.success,
          child: _illustration(good: true),
        ),
      ],
    );
  }

  Widget _buildBadExample() {
    return Column(
      children: [
        _exampleFrame(
          borderColor: AppColors.error,
          label: 'verification.guide_bad'.tr(),
          labelColor: AppColors.error,
          child: _illustration(good: false),
        ),
      ],
    );
  }

  Widget _exampleFrame({
    required Color borderColor,
    required String label,
    required Color labelColor,
    required Widget child,
  }) {
    return Column(
      children: [
        Container(
          height: 72.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.grey50,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: child,
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: labelColor,
          ),
        ),
      ],
    );
  }

  Widget _illustration({required bool good}) {
    switch (type) {
      case VerificationGuideType.ktp:
        return _ktpIllustration(good: good);
      case VerificationGuideType.selfie:
        return _selfieIllustration(good: good);
      case VerificationGuideType.nib:
      case VerificationGuideType.siup:
        return _documentIllustration(good: good);
    }
  }

  Widget _ktpIllustration({required bool good}) {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 40.h,
            decoration: BoxDecoration(
              color: AppColors.infoSurface,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: AppColors.infoBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 28.w,
                  margin: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                  child: Icon(LucideIcons.user, size: 14.sp, color: AppColors.grey500),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 3.h,
                        width: good ? 48.w : 24.w,
                        color: AppColors.grey400,
                      ),
                      SizedBox(height: 3.h),
                      Container(
                        height: 3.h,
                        width: good ? 36.w : 18.w,
                        color: AppColors.grey300,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!good)
            Positioned(
              right: 4.w,
              child: Icon(LucideIcons.scissors, size: 16.sp, color: AppColors.error),
            ),
        ],
      ),
    );
  }

  Widget _selfieIllustration({required bool good}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.grey300,
              border: Border.all(color: AppColors.grey400),
            ),
            child: Icon(
              LucideIcons.user,
              size: 18.sp,
              color: good ? AppColors.grey600 : AppColors.grey400,
            ),
          ),
          SizedBox(width: 6.w),
          Container(
            width: good ? 40.w : 20.w,
            height: 28.h,
            decoration: BoxDecoration(
              color: AppColors.infoSurface,
              borderRadius: BorderRadius.circular(3.r),
              border: Border.all(
                color: good ? AppColors.infoBorder : AppColors.error,
              ),
            ),
            child: good
                ? Icon(LucideIcons.creditCard, size: 12.sp, color: AppColors.primary)
                : Icon(LucideIcons.eyeOff, size: 12.sp, color: AppColors.error),
          ),
        ],
      ),
    );
  }

  Widget _documentIllustration({required bool good}) {
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(3.r),
          border: Border.all(color: AppColors.grey300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.fileText,
              size: 20.sp,
              color: good ? AppColors.primary : AppColors.grey400,
            ),
            if (!good) ...[
              SizedBox(height: 2.h),
              Container(
                height: 2.h,
                width: 30.w,
                color: AppColors.error.withValues(alpha: 0.5),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
