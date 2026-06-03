import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../domain/entities/order_entity.dart';

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
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.25)),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
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
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sengketa Aktif',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.error,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      dispute.statusLabel,
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
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(LucideIcons.lock, size: 16.sp, color: AppColors.warning),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Dana escrow ditahan sampai admin BISA menyelesaikan sengketa.',
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
          SizedBox(height: 16.h),
          _labelValue('Alasan', dispute.reason),
          if (dispute.description != null && dispute.description!.isNotEmpty) ...[
            SizedBox(height: 10.h),
            _labelValue('Detail Masalah', dispute.description!),
          ],
          SizedBox(height: 10.h),
          _labelValue(
            'Diajukan',
            dateFormat.format(dispute.createdAt),
          ),
          if (dispute.evidenceUrls.isNotEmpty) ...[
            SizedBox(height: 14.h),
            Text(
              'Bukti Buyer',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 8.h),
            _EvidenceGrid(urls: dispute.evidenceUrls),
          ],
          if (dispute.sellerResponse != null &&
              dispute.sellerResponse!.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Divider(color: AppColors.grey100, height: 1),
            SizedBox(height: 16.h),
            _labelValue('Tanggapan Supplier', dispute.sellerResponse!),
            if (dispute.sellerRespondedAt != null) ...[
              SizedBox(height: 10.h),
              _labelValue(
                'Ditanggapi',
                dateFormat.format(dispute.sellerRespondedAt!),
              ),
            ],
            if (dispute.sellerEvidenceUrls.isNotEmpty) ...[
              SizedBox(height: 14.h),
              Text(
                'Bukti Supplier',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              _EvidenceGrid(urls: dispute.sellerEvidenceUrls),
            ],
          ],
          if (dispute.resolutionNote != null &&
              dispute.resolutionNote!.isNotEmpty) ...[
            SizedBox(height: 16.h),
            _labelValue('Keputusan Admin', dispute.resolutionNote!),
          ],
          if (isBuyer && dispute.isActive) ...[
            SizedBox(height: 12.h),
            Text(
              'Tim BISA sedang meninjau bukti Anda. Anda akan mendapat notifikasi setelah ada keputusan.',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textHint,
                height: 1.45,
              ),
            ),
          ],
          if (isSupplier && dispute.supplierCanRespond && onSupplierRespond != null) ...[
            SizedBox(height: 16.h),
            CustomButton(
              text: 'Berikan Tanggapan',
              onPressed: onSupplierRespond,
              backgroundColor: AppColors.primary,
            ),
          ],
          if (isSupplier &&
              !dispute.supplierCanRespond &&
              dispute.isActive &&
              dispute.sellerResponse != null) ...[
            SizedBox(height: 12.h),
            Text(
              'Tanggapan Anda sudah dikirim. Menunggu keputusan admin.',
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
      spacing: 8.w,
      runSpacing: 8.h,
      children: urls.map((url) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
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
