import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ambang batas tidak valid'),
          backgroundColor: AppColors.error,
        ),
      );
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pengaturan perangkat disimpan')),
    );
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.message),
            backgroundColor: AppColors.error,
          ),
        );
      },
      (csv) async {
        if (csv.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak ada data untuk diekspor')),
          );
          return;
        }
        final dir = await getTemporaryDirectory();
        final file = File(
          '${dir.path}/iot_export_${widget.deviceId.substring(0, 8)}.csv',
        );
        await file.writeAsString(csv);
        await Share.shareXFiles(
          [XFile(file.path)],
          subject: 'Export data sensor IoT',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Pengaturan Perangkat',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Atur nama tampilan dan ambang suhu aman untuk peringatan.',
            style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            label: 'Nama perangkat',
            controller: _nameCtrl,
            hint: 'Contoh: Tungku Biochar Utama',
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: 'Suhu min (°C)',
                  controller: _minCtrl,
                  hint: '0',
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomTextField(
                  label: 'Suhu max (°C)',
                  controller: _maxCtrl,
                  hint: '120',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          CustomButton(text: 'Simpan Pengaturan', onPressed: _save),
          SizedBox(height: 24.h),
          Text(
            'Ekspor Data',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          OutlinedButton.icon(
            onPressed: _exporting ? null : _exportCsv,
            icon: _exporting
                ? SizedBox(
                    width: 16.w,
                    height: 16.w,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(LucideIcons.download, size: 18.sp),
            label: Text(
              _exporting ? 'Mengekspor...' : 'Unduh CSV (${widget.range})',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              minimumSize: Size(double.infinity, 48.h),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Notifikasi push otomatis aktif saat suhu melewati ambang batas.',
            style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}
