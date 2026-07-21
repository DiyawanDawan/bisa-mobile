import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_layout.dart';
import '../../domain/entities/product_certificate_entity.dart';

class ProductCertificateDraftEditor extends StatefulWidget {
  const ProductCertificateDraftEditor({super.key, required this.onChanged});

  final ValueChanged<ProductCertificateDraft?> onChanged;

  @override
  State<ProductCertificateDraftEditor> createState() =>
      _ProductCertificateDraftEditorState();
}

class _ProductCertificateDraftEditorState
    extends State<ProductCertificateDraftEditor> {
  ProductCertificateDraft? _draft;

  Future<void> _pick() async {
    final selected = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
      withData: false,
    );
    final file = selected?.files.single;
    if (file?.path == null || !mounted) return;
    final name = TextEditingController();
    final type = TextEditingController();
    final issuer = TextEditingController();
    final metadata = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('certificate.upload_title'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              decoration: InputDecoration(labelText: 'certificate.name'.tr()),
            ),
            TextField(
              controller: type,
              decoration: InputDecoration(labelText: 'certificate.type'.tr()),
            ),
            TextField(
              controller: issuer,
              decoration: InputDecoration(labelText: 'certificate.issuer'.tr()),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('batal'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              if (name.text.trim().length < 2 || type.text.trim().length < 2) {
                return;
              }
              Navigator.pop(dialogContext, {
                'title': name.text.trim(),
                'certificateType': type.text.trim(),
                if (issuer.text.trim().isNotEmpty)
                  'issuerName': issuer.text.trim(),
              });
            },
            child: Text('common.save'.tr()),
          ),
        ],
      ),
    );
    name.dispose();
    type.dispose();
    issuer.dispose();
    if (metadata == null) return;
    final draft = ProductCertificateDraft(
      localPath: file!.path!,
      fileName: file.name,
      metadata: metadata,
    );
    setState(() => _draft = draft);
    widget.onChanged(draft);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.grey200),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(LucideIcons.shieldPlus, color: AppColors.primary),
        title: Text(
          _draft?.metadata['title']?.toString() ??
              'certificate.section_title'.tr(),
        ),
        subtitle: Text(
          _draft?.fileName ?? 'certificate.upload_after_create'.tr(),
        ),
        trailing: _draft == null
            ? TextButton(
                onPressed: _pick,
                child: Text('certificate.choose_file'.tr()),
              )
            : IconButton(
                onPressed: () {
                  setState(() => _draft = null);
                  widget.onChanged(null);
                },
                icon: const Icon(LucideIcons.x),
              ),
      ),
    );
  }
}
