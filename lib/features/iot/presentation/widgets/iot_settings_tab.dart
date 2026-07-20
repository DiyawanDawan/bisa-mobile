import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../domain/entities/iot_dashboard_entity.dart';
import '../bloc/iot_cubit.dart';

class IotSettingsTab extends StatefulWidget {
  const IotSettingsTab({
    super.key,
    required this.deviceId,
    required this.dashboard,
    required this.range,
    required this.onChanged,
  });

  final String deviceId;
  final IotDashboardEntity dashboard;
  final String range;
  final VoidCallback onChanged;

  @override
  State<IotSettingsTab> createState() => _IotSettingsTabState();
}

class _IotSettingsTabState extends State<IotSettingsTab> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _minCtrl;
  late final TextEditingController _maxCtrl;
  bool _exporting = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.dashboard.deviceName);
    _minCtrl = TextEditingController(
      text: widget.dashboard.thresholdMin?.toStringAsFixed(0) ?? '200',
    );
    _maxCtrl = TextEditingController(
      text: widget.dashboard.thresholdMax?.toStringAsFixed(0) ?? '600',
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _minCtrl.dispose();
    _maxCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final min = double.tryParse(_minCtrl.text.trim());
    final max = double.tryParse(_maxCtrl.text.trim());
    if (min == null || max == null || max < min) {
      showErrorSnackBar(context, 'iot.settings_invalid_threshold');
      return;
    }

    widget.onChanged();
    await context.read<IotCubit>().updateDeviceSettings(
          widget.deviceId,
          {
            'name': _nameCtrl.text.trim(),
            'thresholdMin': min,
            'thresholdMax': max,
          },
          range: widget.range,
        );
    if (!mounted) return;
    showSuccessSnackBar(context, 'iot.settings_saved');
  }

  Future<void> _exportCsv() async {
    setState(() => _exporting = true);
    final result = await context.read<IotCubit>().exportReadings(
          widget.deviceId,
          range: widget.range,
        );
    if (!mounted) return;
    setState(() => _exporting = false);

    await result.fold(
      (failure) async {
        showErrorSnackBar(context, failure.message);
      },
      (csv) async {
        if (csv.trim().isEmpty) {
          showWarningSnackBar(context, 'iot.export_no_data');
          return;
        }
        final dir = await getTemporaryDirectory();
        final file = File(
          '${dir.path}/iot_export_${widget.deviceId.substring(0, 8)}.csv',
        );
        await file.writeAsString(csv);
        await Share.shareXFiles(
          [XFile(file.path)],
          subject: 'iot.export_subject'.tr(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SettingsCard(
            title: 'iot.settings_title'.tr(),
            subtitle: 'iot.settings_desc'.tr(),
            children: [
              _CompactField(
                label: 'iot.add_device_name_label'.tr(),
                controller: _nameCtrl,
                hint: 'iot.settings_device_name_hint'.tr(),
              ),
              SizedBox(height: 8.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _CompactField(
                      label: 'iot.settings_temp_min_label'.tr(),
                      controller: _minCtrl,
                      hint: '200',
                      keyboardType: TextInputType.number,
                      suffix: '°C',
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _CompactField(
                      label: 'iot.settings_temp_max_label'.tr(),
                      controller: _maxCtrl,
                      hint: '600',
                      keyboardType: TextInputType.number,
                      suffix: '°C',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              SizedBox(
                height: AppSpacing.buttonHeightSm,
                child: CustomButton(
                  text: 'iot.settings_save'.tr(),
                  onPressed: _save,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm10),
          _SettingsCard(
            title: 'iot.export_section_title'.tr(),
            children: [
              SizedBox(
                height: 40.h,
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _exporting ? null : _exportCsv,
                  icon: _exporting
                      ? SizedBox(
                          width: 14.w,
                          height: 14.w,
                          child: const CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(LucideIcons.download, size: 16.sp),
                  label: Text(
                    _exporting
                        ? 'iot.exporting_label'.tr()
                        : 'iot.export_csv_button'.tr(
                            namedArgs: {'range': widget.range},
                          ),
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(LucideIcons.bell, size: 12.sp, color: AppColors.textHint),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      'iot.push_notification_note'.tr(),
                      style: TextStyle(fontSize: 10.sp, color: AppColors.textHint, height: 1.3),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.title,
    required this.children,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 2.h),
            Text(
              subtitle!,
              style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary, height: 1.3),
            ),
          ],
          SizedBox(height: 10.h),
          ...children,
        ],
      ),
    );
  }
}

class _CompactField extends StatelessWidget {
  const _CompactField({
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.suffix,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: 14.sp),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        isDense: true,
        suffixText: suffix,
        suffixStyle: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.grey200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}
