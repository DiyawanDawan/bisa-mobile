import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_layout.dart';
import '../../domain/entities/product_certificate_entity.dart';

class ProductCertificateSection extends StatelessWidget {
  const ProductCertificateSection({
    super.key,
    required this.certificates,
    this.onProductTap,
  });

  final List<ProductCertificateEntity> certificates;
  final ValueChanged<String>? onProductTap;

  Future<void> _openCertificate(
    BuildContext context,
    ProductCertificateEntity item,
  ) async {
    final url = item.documentUrl;
    if (url == null) return;
    if (item.mimeType.startsWith('image/')) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => Dialog(
          child: SafeArea(
            child: Stack(
              children: [
                InteractiveViewer(
                  child: Image.network(
                    url,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) =>
                        Center(child: Text('certificate.preview_error'.tr())),
                  ),
                ),
                Positioned(
                  right: AppSpacing.xs,
                  top: AppSpacing.xs,
                  child: IconButton.filled(
                    onPressed: () => Navigator.pop(dialogContext),
                    icon: const Icon(LucideIcons.x),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      return;
    }
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final approved = certificates.where((item) => item.isApproved).toList();
    if (approved.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      color: AppColors.surface,
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.shieldCheck,
                size: 18.sp,
                color: AppColors.primary,
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                'certificate.verified_section'.tr(),
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          ...approved.map(
            (item) => InkWell(
              onTap: onProductTap == null
                  ? null
                  : () => onProductTap!(item.productId),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Row(
                  children: [
                    Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Icon(
                        item.mimeType == 'application/pdf'
                            ? LucideIcons.fileCheck
                            : LucideIcons.badgeCheck,
                        color: AppColors.primary,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: AppSpacing.md12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            [item.issuerName, item.certificateNumber]
                                .whereType<String>()
                                .where((value) => value.isNotEmpty)
                                .join(' · '),
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (item.expiresAt != null)
                            Text(
                              'certificate.valid_until'.tr(
                                namedArgs: {
                                  'date': DateFormat(
                                    'dd MMM yyyy',
                                  ).format(item.expiresAt!),
                                },
                              ),
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'certificate.view'.tr(),
                      onPressed: item.documentUrl == null
                          ? null
                          : () => _openCertificate(context, item),
                      icon: Icon(LucideIcons.externalLink, size: 18.sp),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
