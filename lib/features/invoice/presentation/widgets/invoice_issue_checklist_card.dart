import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/i18n/failure_messages.dart';
import '../utils/invoice_issue_readiness.dart';

/// Daftar syarat sebelum tagihan bisa diterbitkan.
class InvoiceIssueChecklistCard extends StatelessWidget {
  const InvoiceIssueChecklistCard({
    super.key,
    required this.readiness,
    this.readyText,
    this.pendingTitle,
  });

  final InvoiceIssueReadiness readiness;
  final String? readyText;
  final String? pendingTitle;

  @override
  Widget build(BuildContext context) {
    final resolvedReadyText = readyText ?? 'invoice.issue_ready'.tr();
    final resolvedPendingTitle =
        pendingTitle ?? 'invoice.issue_pending_title'.tr();

    if (readiness.canIssue) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 20.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                resolvedReadyText,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.success,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: AppColors.warning, size: 20.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  resolvedPendingTitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ...readiness.blockers.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: TextStyle(fontSize: 12.sp, color: AppColors.error)),
                  Expanded(
                    child: Text(
                      localizeFailureMessage(item),
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
}
