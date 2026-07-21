import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/product_certificate_entity.dart';
import '../bloc/store_certificate_cubit.dart';
import 'certificate_status_chip.dart';

class StoreCertificateEditor extends StatefulWidget {
  const StoreCertificateEditor({super.key});

  @override
  State<StoreCertificateEditor> createState() => _StoreCertificateEditorState();
}

class _StoreCertificateEditorState extends State<StoreCertificateEditor> {
  late final StoreCertificateCubit _cubit;
  late final StreamSubscription<StoreCertificateState> _subscription;
  List<StoreCertificateEntity> _items = const [];
  bool _loading = true;
  bool _uploading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cubit = sl<StoreCertificateCubit>();
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
    await _cubit.loadMine();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _cubit.close();
    super.dispose();
  }

  Future<void> _pickAndSubmit() async {
    final selected = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
      allowMultiple: false,
      withData: false,
    );
    final path = selected?.files.single.path;
    if (path == null || !mounted) return;

    final title = TextEditingController();
    final type = TextEditingController();
    final issuer = TextEditingController();
    final number = TextEditingController();
    DateTime? issuedAt;
    DateTime? expiresAt;
    final metadata = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('certificate.store_upload_title'.tr()),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: title,
                  decoration: InputDecoration(
                    labelText: 'certificate.name'.tr(),
                  ),
                ),
                TextField(
                  controller: type,
                  decoration: InputDecoration(
                    labelText: 'certificate.type'.tr(),
                  ),
                ),
                TextField(
                  controller: issuer,
                  decoration: InputDecoration(
                    labelText: 'certificate.issuer'.tr(),
                  ),
                ),
                TextField(
                  controller: number,
                  decoration: InputDecoration(
                    labelText: 'certificate.number'.tr(),
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
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
                    if (value != null) setDialogState(() => issuedAt = value);
                  },
                ),
                _DateButton(
                  label: 'certificate.expires_at'.tr(),
                  value: expiresAt,
                  onTap: () async {
                    final value = await showDatePicker(
                      context: context,
                      firstDate: issuedAt ?? DateTime.now(),
                      lastDate: DateTime.now().add(
                        const Duration(days: 365 * 30),
                      ),
                      initialDate:
                          expiresAt ??
                          DateTime.now().add(const Duration(days: 365)),
                    );
                    if (value != null) setDialogState(() => expiresAt = value);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('batal'.tr()),
            ),
            ElevatedButton(
              onPressed: () {
                if (title.text.trim().length < 2 ||
                    type.text.trim().length < 2) {
                  return;
                }
                if (!areCertificateDatesValid(issuedAt, expiresAt)) {
                  return;
                }
                Navigator.pop(dialogContext, {
                  'title': title.text.trim(),
                  'certificateType': type.text.trim(),
                  if (issuer.text.trim().isNotEmpty)
                    'issuerName': issuer.text.trim(),
                  if (number.text.trim().isNotEmpty)
                    'certificateNumber': number.text.trim(),
                  if (issuedAt != null) 'issuedAt': issuedAt!.toIso8601String(),
                  if (expiresAt != null)
                    'expiresAt': expiresAt!.toIso8601String(),
                });
              },
              child: Text('certificate.submit'.tr()),
            ),
          ],
        ),
      ),
    );
    title.dispose();
    type.dispose();
    issuer.dispose();
    number.dispose();
    if (metadata == null || !mounted) return;

    await _cubit.submit(localPath: path, metadata: metadata);
  }

  Future<void> _remove(StoreCertificateEntity item) async {
    await _cubit.remove(item.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'certificate.store_section_title'.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: _uploading ? null : _pickAndSubmit,
                icon: Icon(LucideIcons.upload, size: 16.sp),
                label: Text('certificate.upload'.tr()),
              ),
            ],
          ),
          Text(
            'certificate.store_review_hint'.tr(),
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
              child: Text('certificate.store_empty_owner'.tr()),
            )
          else
            ..._items.map(
              (item) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  item.mimeType == 'application/pdf'
                      ? LucideIcons.fileText
                      : LucideIcons.image,
                  color: AppColors.primary,
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
                    if (item.rejectionReason != null)
                      Text(
                        item.rejectionReason!,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.error,
                        ),
                      ),
                    if (item.status == 'REJECTED')
                      TextButton(
                        onPressed: _uploading ? null : _pickAndSubmit,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text('certificate.resubmit'.tr()),
                      ),
                  ],
                ),
                trailing: item.status == 'APPROVED'
                    ? IconButton(
                        onPressed: item.documentUrl == null
                            ? null
                            : () => launchUrl(
                                Uri.parse(item.documentUrl!),
                                mode: LaunchMode.externalApplication,
                              ),
                        icon: const Icon(LucideIcons.externalLink),
                      )
                    : item.status == 'REJECTED'
                    ? IconButton(
                        onPressed: () => _remove(item),
                        icon: const Icon(
                          LucideIcons.trash2,
                          color: AppColors.error,
                        ),
                      )
                    : null,
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
