import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/i18n/failure_messages.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../data/datasources/marketplace_remote_data_source.dart';

class BulkProductUploadPage extends StatefulWidget {
  const BulkProductUploadPage({super.key});

  @override
  State<BulkProductUploadPage> createState() => _BulkProductUploadPageState();
}

class _BulkProductUploadPageState extends State<BulkProductUploadPage> {
  bool _uploading = false;
  bool _downloadingTemplate = false;
  String? _selectedFileName;
  String? _error;
  Map<String, dynamic>? _result;

  Future<void> _downloadTemplate() async {
    setState(() {
      _downloadingTemplate = true;
      _error = null;
    });
    try {
      final csv = await sl<MarketplaceRemoteDataSource>().downloadBulkProductTemplate();
      await Share.share(csv, subject: 'bisa-product-bulk-template.csv');
    } catch (e) {
      setState(() => _error = 'marketplace.bulk_template_failed'.tr());
    } finally {
      if (mounted) setState(() => _downloadingTemplate = false);
    }
  }

  Future<void> _pickAndUpload() async {
    final pick = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      withData: false,
    );
    if (pick == null || pick.files.isEmpty) return;
    final path = pick.files.single.path;
    if (path == null) return;

    setState(() {
      _uploading = true;
      _error = null;
      _result = null;
      _selectedFileName = pick.files.single.name;
    });

    try {
      final data = await sl<MarketplaceRemoteDataSource>().uploadBulkProducts(path);
      if (!mounted) return;
      setState(() => _result = data);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = localizeFailureMessage(e.toString()));
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final results = (_result?['results'] as List?) ?? [];
    final created = (_result?['created'] as num?)?.toInt() ?? 0;
    final failed = (_result?['failed'] as num?)?.toInt() ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        title: 'marketplace.bulk_upload_title'.tr(),
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'marketplace.bulk_upload_hint'.tr(),
              style: AppTextStyles.body(color: AppColors.textSecondary),
            ),
            SizedBox(height: AppSpacing.lg),
            CustomButton(
              text: 'marketplace.bulk_download_template'.tr(),
              isLoading: _downloadingTemplate,
              useGradient: false,
              onPressed: _downloadingTemplate ? null : _downloadTemplate,
            ),
            SizedBox(height: AppSpacing.md12),
            CustomButton(
              text: _selectedFileName == null
                  ? 'marketplace.bulk_pick_csv'.tr()
                  : 'marketplace.bulk_upload_file'.tr(namedArgs: {
                      'name': _selectedFileName!,
                    }),
              isLoading: _uploading,
              onPressed: _uploading ? null : _pickAndUpload,
            ),
            if (_error != null) ...[
              SizedBox(height: AppSpacing.md),
              Text(_error!, style: AppTextStyles.caption(color: AppColors.error)),
            ],
            if (_result != null) ...[
              SizedBox(height: AppSpacing.lg),
              Container(
                padding: EdgeInsets.all(AppSpacing.section),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          created > 0 ? LucideIcons.circleCheck : LucideIcons.circleAlert,
                          color: created > 0 ? AppColors.success : AppColors.warning,
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Text(
                          'marketplace.bulk_result_summary'.tr(namedArgs: {
                            'created': '$created',
                            'failed': '$failed',
                          }),
                          style: AppTextStyles.body(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.md12),
                    ...results.map((raw) {
                      final row = Map<String, dynamic>.from(raw as Map);
                      final ok = row['success'] == true;
                      return Padding(
                        padding: EdgeInsets.only(bottom: 6.h),
                        child: Text(
                          ok
                              ? 'marketplace.bulk_row_ok'.tr(namedArgs: {
                                  'row': '${row['row']}',
                                  'name': '${row['name']}',
                                })
                              : 'marketplace.bulk_row_fail'.tr(namedArgs: {
                                  'row': '${row['row']}',
                                  'error': '${row['error']}',
                                }),
                          style: AppTextStyles.caption(
                            color: ok ? AppColors.success : AppColors.error,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
