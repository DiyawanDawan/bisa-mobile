import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../domain/entities/order_entity.dart';
import '../utils/order_dispute_i18n.dart';

class OrderDisputeSection extends StatelessWidget {
  const OrderDisputeSection({
    super.key,
    required this.order,
    required this.isBuyer,
    required this.isSupplier,
    this.onSupplierRespond,
  });

  final OrderEntity order;
  final bool isBuyer;
  final bool isSupplier;
  final VoidCallback? onSupplierRespond;

  @override
  Widget build(BuildContext context) {
    final dispute = order.dispute;
    if (order.status.toUpperCase() != 'DISPUTED' || dispute == null) {
      return const SizedBox.shrink();
    }

    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.25)),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.sm10),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.shieldAlert,
                  color: AppColors.error,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: AppSpacing.md12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'orders.dispute_active_title'.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.error,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      disputeStatusLabel(dispute),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md12),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSpacing.md12),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Row(
              children: [
                Icon(LucideIcons.lock, size: 16.sp, color: AppColors.warning),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'orders.dispute_escrow_held'.tr(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.md),
          _labelValue('orders.dispute_reason'.tr(), dispute.reason),
          if (dispute.description != null && dispute.description!.isNotEmpty) ...[
            SizedBox(height: AppSpacing.sm10),
            _labelValue('orders.dispute_detail'.tr(), dispute.description!),
          ],
          SizedBox(height: AppSpacing.sm10),
          _labelValue(
            'orders.dispute_filed_at'.tr(),
            dateFormat.format(dispute.createdAt),
          ),
          if (dispute.isMediationActive || dispute.isReadyToResolve) ...[
            SizedBox(height: AppSpacing.sm10),
            _labelValue(
              'orders.dispute_mediation_phase'.tr(),
              disputeMediationPhaseLabel(dispute),
            ),
            if (dispute.mediationStartedAt != null) ...[
              SizedBox(height: AppSpacing.sm10),
              _labelValue(
                'orders.dispute_mediation_started'.tr(),
                dateFormat.format(dispute.mediationStartedAt!),
              ),
            ],
            if (dispute.readyToResolveAt != null) ...[
              SizedBox(height: AppSpacing.sm10),
              _labelValue(
                'orders.dispute_ready_resolve'.tr(),
                dateFormat.format(dispute.readyToResolveAt!),
              ),
            ],
          ],
          if (dispute.evidenceUrls.isNotEmpty) ...[
            SizedBox(height: AppSpacing.section),
            Text(
              'orders.dispute_buyer_evidence'.tr(),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            _EvidenceGrid(urls: dispute.evidenceUrls),
          ],
          if (dispute.sellerResponse != null &&
              dispute.sellerResponse!.isNotEmpty) ...[
            SizedBox(height: AppSpacing.md),
            Divider(color: AppColors.grey100, height: 1),
            SizedBox(height: AppSpacing.md),
            _labelValue('orders.dispute_supplier_response'.tr(), dispute.sellerResponse!),
            if (dispute.sellerRespondedAt != null) ...[
              SizedBox(height: AppSpacing.sm10),
              _labelValue(
                'orders.dispute_responded_at'.tr(),
                dateFormat.format(dispute.sellerRespondedAt!),
              ),
            ],
            if (dispute.sellerEvidenceUrls.isNotEmpty) ...[
              SizedBox(height: AppSpacing.section),
              Text(
                'orders.dispute_supplier_evidence'.tr(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              _EvidenceGrid(urls: dispute.sellerEvidenceUrls),
            ],
          ],
          if (dispute.resolutionNote != null &&
              dispute.resolutionNote!.isNotEmpty) ...[
            SizedBox(height: AppSpacing.md),
            _labelValue('orders.dispute_admin_decision'.tr(), dispute.resolutionNote!),
          ],
          if (isBuyer && dispute.isActive) ...[
            SizedBox(height: AppSpacing.md12),
            Text(
              'orders.dispute_buyer_waiting'.tr(),
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textHint,
                height: 1.45,
              ),
            ),
          ],
          if (isSupplier && dispute.supplierCanRespond && onSupplierRespond != null) ...[
            SizedBox(height: AppSpacing.md),
            CustomButton(
              text: 'orders.dispute_respond_button'.tr(),
              onPressed: onSupplierRespond,
              backgroundColor: AppColors.primary,
            ),
          ],
          if (isSupplier &&
              !dispute.supplierCanRespond &&
              dispute.isActive &&
              dispute.sellerResponse != null) ...[
            SizedBox(height: AppSpacing.md12),
            Text(
              'orders.dispute_supplier_waiting'.tr(),
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textHint,
                height: 1.45,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _labelValue(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textHint,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _EvidenceGrid extends StatelessWidget {
  const _EvidenceGrid({required this.urls});

  final List<String> urls;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: urls.map((url) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: BisaNetworkImage(
            imageUrl: url,
            width: 72.w,
            height: 72.w,
            fit: BoxFit.cover,
          ),
        );
      }).toList(),
    );
  }
}
