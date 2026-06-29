import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/i18n/failure_messages.dart';
import '../../../../injection_container.dart';
import '../../../ai/domain/repositories/ai_repository.dart';
import '../utils/prediction_product_mapper.dart';
import 'product_specs_sheet.dart';

class IotPredictionImportResult {
  const IotPredictionImportResult({
    required this.predictionId,
    required this.grade,
    required this.specsData,
    this.suggestedName,
    this.biomassaType,
    this.suggestedPricePerUnit,
  });

  final String predictionId;
  final String grade;
  final ProductSpecsData specsData;
  final String? suggestedName;
  final String? biomassaType;
  final double? suggestedPricePerUnit;
}

class IotPredictionImportSheet extends StatefulWidget {
  const IotPredictionImportSheet({super.key});

  static Future<IotPredictionImportResult?> show(BuildContext context) {
    return showModalBottomSheet<IotPredictionImportResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: const IotPredictionImportSheet(),
      ),
    );
  }

  @override
  State<IotPredictionImportSheet> createState() => _IotPredictionImportSheetState();
}

class _IotPredictionImportSheetState extends State<IotPredictionImportSheet> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await sl<AiRepository>().getRecentIotPredictions(limit: 15);
    if (!mounted) return;
    result.fold(
      (f) => setState(() {
        _loading = false;
        _error = localizeFailureMessage(f.message);
      }),
      (items) => setState(() {
        _loading = false;
        _items = items;
      }),
    );
  }

  IotPredictionImportResult _mapPrediction(Map<String, dynamic> p) =>
      mapPredictionToProductSeed(p);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
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
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(LucideIcons.radio, color: AppColors.primary, size: 20.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'marketplace.import_iot_title'.tr(),
                  style: AppTextStyles.sectionTitle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            'marketplace.import_iot_subtitle'.tr(),
            style: AppTextStyles.caption(color: AppColors.textSecondary),
          ),
          SizedBox(height: AppSpacing.md),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
            )
          else if (_error != null)
            Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  Text(_error!, style: AppTextStyles.caption(color: AppColors.error)),
                  TextButton(onPressed: _load, child: Text('iot.retry'.tr())),
                ],
              ),
            )
          else if (_items.isEmpty)
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Text(
                'marketplace.import_iot_empty'.tr(),
                style: AppTextStyles.body(color: AppColors.textSecondary),
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _items.length,
                separatorBuilder: (_, __) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  final p = _items[index];
                  final grade = p['predictedGrade']?.toString() ?? '—';
                  final suhu = p['suhuPirolisis'];
                  final waktu = p['waktuPembakaran'];
                  final device = p['iotDeviceName']?.toString() ?? 'IoT';
                  final created = p['createdAt']?.toString() ?? '';

                  return Material(
                    color: AppColors.primaryLight.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.r),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: () => Navigator.pop(context, _mapPrediction(p)),
                      child: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Grade $grade · $device',
                                    style: AppTextStyles.body(fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'marketplace.import_iot_row_meta'.tr(
                                      namedArgs: {
                                        'suhu': '$suhu',
                                        'waktu': '$waktu',
                                      },
                                    ),
                                    style: AppTextStyles.caption(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  if (created.isNotEmpty)
                                    Text(
                                      created.length > 19 ? created.substring(0, 19) : created,
                                      style: AppTextStyles.caption(color: AppColors.textHint),
                                    ),
                                ],
                              ),
                            ),
                            Icon(LucideIcons.chevronRight, size: 18.sp),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
