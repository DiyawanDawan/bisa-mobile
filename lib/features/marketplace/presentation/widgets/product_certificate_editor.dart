import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/utils/safe_area_utils.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/product_certificate_entity.dart';
import '../bloc/product_certificate_cubit.dart';
import 'certificate_status_chip.dart';

class ProductCertificateEditor extends StatefulWidget {
  const ProductCertificateEditor({super.key, required this.productId});

  final String productId;

  @override
  State<ProductCertificateEditor> createState() =>
      _ProductCertificateEditorState();
}

class _ProductCertificateEditorState extends State<ProductCertificateEditor> {
  late final ProductCertificateCubit _cubit;
  late final StreamSubscription<ProductCertificateState> _subscription;
  List<ProductCertificateEntity> _items = const [];
  bool _loading = true;
  bool _uploading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cubit = sl<ProductCertificateCubit>();
    _subscription = _cubit.stream.listen((state) {
      if (!mounted) return;
      setState(() {
        _items = state.items;
        _loading = state.loading;
        _uploading = state.submitting;
        _error = state.error;
      });
    });
    _load();
  }

  Future<void> _load() async {
    await _cubit.loadOwner(widget.productId);
  }

  @override
  void dispose() {
    _subscription.cancel();
    _cubit.close();
    super.dispose();
  }

  Future<void> _openUploadSheet() async {
    final selected = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
      allowMultiple: false,
      withData: false,
    );
    final path = selected?.files.single.path;
    if (path == null || !mounted) return;

    final metadata = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (sheetContext) => _CertificateFormSheet(
        titleText: 'certificate.upload_title'.tr(),
      ),
    );
    if (metadata == null || !mounted) return;

    await _cubit.submit(
      productId: widget.productId,
      localPath: path,
      metadata: metadata,
    );
  }

  Future<void> _openDetailSheet(ProductCertificateEntity item) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (sheetContext) => _CertificateDetailSheet(
        item: item,
        uploading: _uploading,
        onResubmit: () async {
          Navigator.pop(sheetContext);
          await _openUploadSheet();
        },
        onDelete: () async {
          Navigator.pop(sheetContext);
          await _cubit.remove(widget.productId, item.id);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'certificate.section_title'.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: _uploading ? null : _openUploadSheet,
                icon: Icon(LucideIcons.upload, size: 16.sp),
                label: Text('certificate.upload'.tr()),
              ),
            ],
          ),
          Text(
            'certificate.review_hint'.tr(),
            style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_items.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Text('certificate.empty_owner'.tr()),
            )
          else
            ..._items.map(
              (item) => ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: () => _openDetailSheet(item),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: item.mimeType.startsWith('image/') &&
                          item.documentUrl != null
                      ? Image.network(
                          item.documentUrl!,
                          width: 44.r,
                          height: 44.r,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: 44.r,
                            height: 44.r,
                            color: AppColors.primaryLight,
                            child: Icon(
                              LucideIcons.image,
                              color: AppColors.primary,
                              size: 20.sp,
                            ),
                          ),
                        )
                      : Container(
                          width: 44.r,
                          height: 44.r,
                          color: AppColors.primaryLight,
                          child: Icon(
                            item.mimeType == 'application/pdf'
                                ? LucideIcons.fileText
                                : LucideIcons.image,
                            color: AppColors.primary,
                            size: 20.sp,
                          ),
                        ),
                ),
                title: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${item.certificateType} · ${item.issuerName ?? '-'}'),
                    SizedBox(height: AppSpacing.xs),
                    CertificateStatusChip(status: item.status),
                  ],
                ),
                trailing: Icon(
                  LucideIcons.chevronRight,
                  size: 18.sp,
                  color: AppColors.grey400,
                ),
              ),
            ),
          if (_uploading) const LinearProgressIndicator(),
          if (_error != null)
            Text(
              _error!,
              style: TextStyle(fontSize: 11.sp, color: AppColors.error),
            ),
        ],
      ),
    );
  }
}

class _CertificateDetailSheet extends StatelessWidget {
  const _CertificateDetailSheet({
    required this.item,
    required this.uploading,
    required this.onResubmit,
    required this.onDelete,
  });

  final ProductCertificateEntity item;
  final bool uploading;
  final VoidCallback onResubmit;
  final VoidCallback onDelete;

  bool get _isImage => item.mimeType.startsWith('image/');

  Future<void> _openExternal() async {
    final url = item.documentUrl;
    if (url == null) return;
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 0.88.sh),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.xxlPx.r),
        ),
      ),
      child: SingleChildScrollView(
        padding: bisaSheetPadding(
          context,
          horizontal: AppSpacing.xl,
          top: AppSpacing.md,
          bottom: AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'certificate.detail_title'.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(LucideIcons.x, size: 18.sp),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            if (_isImage && item.documentUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.xl),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: InteractiveViewer(
                    child: Image.network(
                      item.documentUrl!,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => Container(
                        color: AppColors.grey100,
                        alignment: Alignment.center,
                        child: Text('certificate.preview_error'.tr()),
                      ),
                    ),
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Column(
                  children: [
                    Icon(
                      LucideIcons.fileText,
                      size: 40.sp,
                      color: AppColors.primary,
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      item.fileName.isEmpty
                          ? 'certificate.document_file'.tr()
                          : item.fileName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: AppSpacing.lg),
            Text(
              item.title,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: AppSpacing.xs),
            CertificateStatusChip(status: item.status),
            SizedBox(height: AppSpacing.md),
            _MetaRow(
              label: 'certificate.type'.tr(),
              value: item.certificateType,
            ),
            _MetaRow(
              label: 'certificate.issuer'.tr(),
              value: item.issuerName ?? '-',
            ),
            _MetaRow(
              label: 'certificate.number'.tr(),
              value: item.certificateNumber ?? '-',
            ),
            if (item.issuedAt != null)
              _MetaRow(
                label: 'certificate.issued_at'.tr(),
                value: DateFormat('dd MMM yyyy').format(item.issuedAt!),
              ),
            if (item.expiresAt != null)
              _MetaRow(
                label: 'certificate.expires_at'.tr(),
                value: DateFormat('dd MMM yyyy').format(item.expiresAt!),
              ),
            if (item.rejectionReason != null) ...[
              SizedBox(height: AppSpacing.sm),
              Text(
                item.rejectionReason!,
                style: TextStyle(fontSize: 12.sp, color: AppColors.error),
              ),
            ],
            SizedBox(height: AppSpacing.xl),
            if (item.documentUrl != null)
              OutlinedButton.icon(
                onPressed: _openExternal,
                icon: Icon(LucideIcons.externalLink, size: 16.sp),
                label: Text('certificate.open_document'.tr()),
              ),
            if (item.status == 'REJECTED' || item.status == 'PENDING') ...[
              SizedBox(height: AppSpacing.sm),
              if (item.status == 'REJECTED')
                ElevatedButton.icon(
                  onPressed: uploading ? null : onResubmit,
                  icon: Icon(LucideIcons.upload, size: 16.sp),
                  label: Text('certificate.resubmit'.tr()),
                ),
              if (item.status != 'APPROVED')
                TextButton.icon(
                  onPressed: uploading ? null : onDelete,
                  icon: Icon(
                    LucideIcons.trash2,
                    size: 16.sp,
                    color: AppColors.error,
                  ),
                  label: Text(
                    'certificate.delete'.tr(),
                    style: const TextStyle(color: AppColors.error),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110.w,
            child: Text(
              label,
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _CertificateFormSheet extends StatefulWidget {
  const _CertificateFormSheet({required this.titleText});

  final String titleText;

  @override
  State<_CertificateFormSheet> createState() => _CertificateFormSheetState();
}

class _CertificateFormSheetState extends State<_CertificateFormSheet> {
  final title = TextEditingController();
  final type = TextEditingController();
  final issuer = TextEditingController();
  final number = TextEditingController();
  DateTime? issuedAt;
  DateTime? expiresAt;

  @override
  void dispose() {
    title.dispose();
    type.dispose();
    issuer.dispose();
    number.dispose();
    super.dispose();
  }

  void _submit() {
    if (title.text.trim().length < 2 || type.text.trim().length < 2) return;
    if (!areCertificateDatesValid(issuedAt, expiresAt)) return;
    Navigator.pop(context, {
      'title': title.text.trim(),
      'certificateType': type.text.trim(),
      if (issuer.text.trim().isNotEmpty) 'issuerName': issuer.text.trim(),
      if (number.text.trim().isNotEmpty)
        'certificateNumber': number.text.trim(),
      if (issuedAt != null) 'issuedAt': issuedAt!.toIso8601String(),
      if (expiresAt != null) 'expiresAt': expiresAt!.toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 0.9.sh),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.xxlPx.r),
        ),
      ),
      child: SingleChildScrollView(
        padding: bisaSheetPadding(
          context,
          horizontal: AppSpacing.xl,
          top: AppSpacing.md,
          bottom: AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              widget.titleText,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: AppSpacing.lg),
            TextField(
              controller: title,
              decoration: InputDecoration(labelText: 'certificate.name'.tr()),
            ),
            SizedBox(height: AppSpacing.md12),
            TextField(
              controller: type,
              decoration: InputDecoration(labelText: 'certificate.type'.tr()),
            ),
            SizedBox(height: AppSpacing.md12),
            TextField(
              controller: issuer,
              decoration: InputDecoration(labelText: 'certificate.issuer'.tr()),
            ),
            SizedBox(height: AppSpacing.md12),
            TextField(
              controller: number,
              decoration: InputDecoration(labelText: 'certificate.number'.tr()),
            ),
            SizedBox(height: AppSpacing.md),
            _DateButton(
              label: 'certificate.issued_at'.tr(),
              value: issuedAt,
              onTap: () async {
                final value = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                  initialDate: issuedAt ?? DateTime.now(),
                );
                if (value != null) setState(() => issuedAt = value);
              },
            ),
            _DateButton(
              label: 'certificate.expires_at'.tr(),
              value: expiresAt,
              onTap: () async {
                final value = await showDatePicker(
                  context: context,
                  firstDate: issuedAt ?? DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 30)),
                  initialDate:
                      expiresAt ??
                      DateTime.now().add(const Duration(days: 365)),
                );
                if (value != null) setState(() => expiresAt = value);
              },
            ),
            SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: Text('certificate.submit'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  const _DateButton({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final DateTime? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: const Icon(LucideIcons.calendar),
      title: Text(label),
      subtitle: Text(
        value == null ? '-' : DateFormat('dd MMM yyyy').format(value!),
      ),
    );
  }
}
