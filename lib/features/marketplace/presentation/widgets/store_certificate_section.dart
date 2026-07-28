import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/utils/safe_area_utils.dart';
import '../../domain/entities/product_certificate_entity.dart';

class StoreCertificateSection extends StatelessWidget {
  const StoreCertificateSection({super.key, required this.certificates});

  final List<StoreCertificateEntity> certificates;

  Future<void> _openCertificate(
    BuildContext context,
    StoreCertificateEntity item,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (sheetContext) => _StoreCertificateDetailSheet(item: item),
    );
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
                LucideIcons.store,
                size: 18.sp,
                color: AppColors.primary,
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                'certificate.store_verified_section'.tr(),
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          ...approved.map(
            (item) => Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Material(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.tile),
                child: InkWell(
                  onTap: () => _openCertificate(context, item),
                  borderRadius: BorderRadius.circular(AppRadius.tile),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        _CertificateIcon(mimeType: item.mimeType),
                        SizedBox(width: AppSpacing.md12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                [
                                  item.issuerName,
                                  item.certificateNumber,
                                ]
                                    .whereType<String>()
                                    .where((value) => value.isNotEmpty)
                                    .join(' - '),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              if (item.expiresAt != null) ...[
                                SizedBox(height: 2.h),
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
                            ],
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Icon(
                          LucideIcons.chevronRight,
                          size: 18.sp,
                          color: AppColors.grey400,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreCertificateDetailSheet extends StatelessWidget {
  const _StoreCertificateDetailSheet({required this.item});

  final StoreCertificateEntity item;

  bool get _isImage => item.mimeType.startsWith('image/');

  Future<void> _openExternal() async {
    final url = item.documentUrl;
    if (url == null) return;
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  String _date(DateTime? value) {
    if (value == null) return '-';
    return DateFormat('dd MMM yyyy').format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 0.92.sh),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.xxlPx.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: bisaSheetPadding(
              context,
              horizontal: AppSpacing.md,
              top: AppSpacing.md,
              bottom: AppSpacing.sm,
            ),
            child: Row(
              children: [
                _CertificateIcon(mimeType: item.mimeType, size: 36.r),
                SizedBox(width: AppSpacing.md12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'certificate.detail_title'.tr(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(LucideIcons.x, size: 18.sp),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.md,
              ),
              children: [
                _CertificatePreview(item: item, isImage: _isImage),
                SizedBox(height: AppSpacing.md),
                _CertificateInfoRow(
                  icon: LucideIcons.badgeCheck,
                  label: 'certificate.type'.tr(),
                  value: item.certificateType,
                ),
                _CertificateInfoRow(
                  icon: LucideIcons.landmark,
                  label: 'certificate.issuer'.tr(),
                  value: item.issuerName,
                ),
                _CertificateInfoRow(
                  icon: LucideIcons.hash,
                  label: 'certificate.number'.tr(),
                  value: item.certificateNumber,
                ),
                _CertificateInfoRow(
                  icon: LucideIcons.calendarDays,
                  label: 'certificate.issued_at'.tr(),
                  value: _date(item.issuedAt),
                ),
                _CertificateInfoRow(
                  icon: LucideIcons.calendarCheck,
                  label: 'certificate.valid_until'
                      .tr(namedArgs: {'date': ''})
                      .trim(),
                  value: _date(item.expiresAt),
                ),
              ],
            ),
          ),
          Padding(
            padding: bisaSheetPadding(
              context,
              horizontal: AppSpacing.md,
              top: AppSpacing.sm,
              bottom: AppSpacing.md,
            ),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: item.documentUrl == null ? null : _openExternal,
                icon: Icon(LucideIcons.externalLink, size: 16.sp),
                label: Text('certificate.open_document'.tr()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CertificatePreview extends StatelessWidget {
  const _CertificatePreview({required this.item, required this.isImage});

  final StoreCertificateEntity item;
  final bool isImage;

  @override
  Widget build(BuildContext context) {
    final documentUrl = item.documentUrl;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        height: 0.42.sh,
        width: double.infinity,
        color: AppColors.grey50,
        child: documentUrl == null
            ? Center(child: Text('certificate.preview_error'.tr()))
            : isImage
                ? InteractiveViewer(
                    minScale: 0.7,
                    maxScale: 5,
                    child: Center(
                      child: Image.network(
                        documentUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) => Center(
                          child: Text('certificate.preview_error'.tr()),
                        ),
                      ),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.fileCheck,
                        size: 42.sp,
                        color: AppColors.primary,
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Text(
                        item.fileName.isEmpty ? item.title : item.fileName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

class _CertificateInfoRow extends StatelessWidget {
  const _CertificateInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final displayValue = value == null || value!.trim().isEmpty ? '-' : value!;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 17.sp, color: AppColors.textSecondary),
          SizedBox(width: AppSpacing.md12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  displayValue,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CertificateIcon extends StatelessWidget {
  const _CertificateIcon({required this.mimeType, this.size});

  final String mimeType;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final iconSize = size ?? 40.r;
    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Icon(
        mimeType == 'application/pdf'
            ? LucideIcons.fileCheck
            : LucideIcons.badgeCheck,
        color: AppColors.primary,
        size: iconSize * 0.5,
      ),
    );
  }
}
