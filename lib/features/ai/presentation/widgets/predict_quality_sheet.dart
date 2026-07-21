import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/utils/safe_area_utils.dart';
import '../../../../core/i18n/failure_messages.dart';
import '../../../../core/i18n/tr_safe.dart';
import '../../../../core/utils/batch_weight_util.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/batch_weight_field.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../domain/repositories/ai_repository.dart';
import '../utils/predict_quality_quota.dart';
import '../utils/temperature_ocr_util.dart';
import '../../../marketplace/presentation/utils/prediction_product_mapper.dart';
import 'predict_result_table.dart';

class PredictQualitySheet extends StatefulWidget {
  const PredictQualitySheet({
    super.key,
    this.initialBiomassaType,
    this.initialSuhu,
    this.initialWaktu,
    this.initialBerat,
  });

  final String? initialBiomassaType;
  final double? initialSuhu;
  final double? initialWaktu;
  final double? initialBerat;

  static Future<void> show(
    BuildContext context, {
    String? initialBiomassaType,
    double? initialSuhu,
    double? initialWaktu,
    double? initialBerat,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (sheetCtx) => Padding(
        padding: bisaSheetPadding(sheetCtx),
        child: PredictQualitySheet(
          initialBiomassaType: initialBiomassaType,
          initialSuhu: initialSuhu,
          initialWaktu: initialWaktu,
          initialBerat: initialBerat,
        ),
      ),
    );
  }

  @override
  State<PredictQualitySheet> createState() => _PredictQualitySheetState();
}

class _PredictQualitySheetState extends State<PredictQualitySheet> {
  late final TextEditingController _tempCtrl;
  late final TextEditingController _timeCtrl;
  late final TextEditingController _weightCtrl;
  String _biomassaType = 'BIOCHAR';
  BatchWeightUnit _weightUnit = BatchWeightUnit.ton;
  bool _loading = false;
  bool _scanningTemp = false;
  Map<String, dynamic>? _result;
  String? _error;
  int _remaining = 3;

  static const _types = [
    'SEKAM_PADI',
    'TONGKOL_JAGUNG',
    'TEMPURUNG_KELAPA',
    'WOOD_CHIP',
    'BIOCHAR',
    'OTHER',
  ];

  @override
  void initState() {
    super.initState();
    _tempCtrl = TextEditingController(
      text: widget.initialSuhu?.round().toString() ?? '500',
    );
    final waktu = widget.initialWaktu?.round();
    _timeCtrl = TextEditingController(
      text: '${waktu != null && waktu >= 1 ? waktu : 120}',
    );
    _weightUnit = BatchWeightUtil.preferredUnitForKg(widget.initialBerat);
    _weightCtrl = TextEditingController(
      text: _weightUnit.formatFromKgNullable(widget.initialBerat),
    );
    if (widget.initialBiomassaType != null &&
        _types.contains(widget.initialBiomassaType)) {
      _biomassaType = widget.initialBiomassaType!;
    }
    _loadQuota();
  }

  Future<void> _loadQuota() async {
    final user = context.read<AuthCubit>().state.maybeWhen(
      authenticated: (u) => u,
      orElse: () => null,
    );
    final rem = await PredictQualityQuota.remaining(user);
    if (mounted) setState(() => _remaining = rem);
  }

  @override
  void dispose() {
    _tempCtrl.dispose();
    _timeCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  Future<void> _predict() async {
    final user = context.read<AuthCubit>().state.maybeWhen(
      authenticated: (u) => u,
      orElse: () => null,
    );
    if (user == null) return;

    if (!await PredictQualityQuota.canPredict(user)) {
      setState(() => _error = 'ai.predict_quota_exceeded'.tr());
      return;
    }

    final temp = double.tryParse(_tempCtrl.text.trim());
    final time = double.tryParse(_timeCtrl.text.trim());
    final beratKg = BatchWeightUtil.parseFieldToKg(
      _weightCtrl.text,
      _weightUnit,
    );

    if (temp == null || time == null || beratKg == null) {
      setState(() => _error = 'ai.predict_invalid_input'.tr());
      return;
    }
    if (temp < 20 || temp > 1000) {
      setState(
        () => _error = trSafe(
          'ai.predict_temp_range',
          fallback: 'Suhu harus antara 20–1000°C',
        ),
      );
      return;
    }
    if (time < 1) {
      setState(
        () => _error = trSafe(
          'ai.predict_time_min',
          fallback: 'Waktu pembakaran minimal 1 menit',
        ),
      );
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _result = null;
    });

    final result = await sl<AiRepository>().predictQuality(
      biomassaType: _biomassaType,
      suhuPirolisis: temp,
      waktuPembakaran: time,
      beratInput: beratKg,
    );

    if (!mounted) return;

    result.fold(
      (f) => setState(() {
        _loading = false;
        _error = localizeFailureMessage(f.message);
      }),
      (data) async {
        await PredictQualityQuota.recordUsage(user);
        await _loadQuota();
        if (!mounted) return;
        setState(() {
          _loading = false;
          _result = data;
        });
      },
    );
  }

  Future<void> _scanTemperatureFromPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (ctx) => Padding(
        padding: bisaSheetPadding(
          ctx,
          top: AppSpacing.md12,
          bottom: AppSpacing.compact,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              trSafe(
                'ai.scan_temp_source_title',
                fallback: 'Foto termometer digital',
              ),
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 12.h),
            ListTile(
              leading: Icon(LucideIcons.camera, color: AppColors.primary),
              title: Text(
                trSafe('ai.scan_temp_camera', fallback: 'Ambil foto'),
              ),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: Icon(LucideIcons.image, color: AppColors.primary),
              title: Text(
                trSafe('ai.scan_temp_gallery', fallback: 'Pilih dari galeri'),
              ),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;

    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;

    setState(() => _scanningTemp = true);
    double? value;
    try {
      value = await TemperatureOcrUtil.extractTemperature(picked.path);
    } catch (_) {
      value = null;
    }
    if (!mounted) return;

    setState(() => _scanningTemp = false);
    if (value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            trSafe(
              'ai.scan_temp_failed',
              fallback: 'Suhu tidak terbaca dari foto. Silakan isi manual.',
            ),
          ),
        ),
      );
      return;
    }

    setState(() {
      _tempCtrl.text = value!.round().toString();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          trSafe(
            'ai.scan_temp_success',
            fallback: 'Suhu terdeteksi, silakan cek ulang sebelum lanjut.',
          ),
        ),
      ),
    );
  }

  String _biomassLabel(String type) => type.replaceAll('_', ' ');

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.92,
      ),
      padding: EdgeInsets.only(top: AppSpacing.sectionGap),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Icon(
                  LucideIcons.sparkles,
                  color: AppColors.primary,
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'ai.predict_title'.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              'ai.predict_subtitle_free'.tr(
                namedArgs: {'remaining': '$_remaining'},
              ),
              style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
            ),
            SizedBox(height: 10.h),
            _CompactDropdown<String>(
              label: 'ai.predict_biomass_type'.tr(),
              value: _biomassaType,
              items: _types
                  .map(
                    (t) => DropdownMenuItem(
                      value: t,
                      child: Text(
                        _biomassLabel(t),
                        style: TextStyle(fontSize: 13.sp),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _biomassaType = v);
              },
            ),
            SizedBox(height: 8.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _CompactNumField(
                    label: 'ai.predict_temp_label'.tr(),
                    hint: '500',
                    controller: _tempCtrl,
                    suffix: '°C',
                    onCameraTap: _scanTemperatureFromPhoto,
                    cameraLoading: _scanningTemp,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _CompactNumField(
                    label: 'ai.predict_time_label'.tr(),
                    hint: '120',
                    controller: _timeCtrl,
                    suffix: trSafe('ai.predict_time_suffix', fallback: 'mnt'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            BatchWeightField(
              controller: _weightCtrl,
              initialUnit: _weightUnit,
              initialKg: widget.initialBerat,
              onUnitChanged: (u) => setState(() => _weightUnit = u),
            ),
            if (_error != null) ...[
              SizedBox(height: 8.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.25),
                  ),
                ),
                child: Text(
                  _error!,
                  style: TextStyle(fontSize: 11.sp, color: AppColors.error),
                ),
              ),
            ],
            if (_result != null) ...[
              SizedBox(height: 10.h),
              PredictResultTable(
                prediction: _result!,
                onAddToProduct: () => openAddProductFromPrediction(
                  context,
                  prediction: _result!,
                  closeCurrentSheet: true,
                ),
              ),
            ],
            SizedBox(height: 12.h),
            SizedBox(
              height: AppSpacing.buttonHeightSm,
              child: CustomButton(
                text: 'ai.predict_submit'.tr(),
                isLoading: _loading,
                onPressed: _loading ? null : _predict,
              ),
            ),
            if (_remaining <= 0) ...[
              SizedBox(height: 6.h),
              Text(
                'ai.predict_quota_exhausted'.tr(
                  namedArgs: {'limit': '${PredictQualityQuota.freeLimitPerMonth}'},
                ),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CompactNumField extends StatelessWidget {
  const _CompactNumField({
    required this.label,
    required this.hint,
    required this.controller,
    this.suffix,
    this.onCameraTap,
    this.cameraLoading = false,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final String? suffix;
  final VoidCallback? onCameraTap;
  final bool cameraLoading;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
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
        suffixIcon: onCameraTap == null
            ? null
            : cameraLoading
            ? Padding(
                padding: EdgeInsets.all(12.w),
                child: SizedBox(
                  width: 16.w,
                  height: 16.w,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : IconButton(
                icon: Icon(
                  LucideIcons.camera,
                  size: 18.sp,
                  color: AppColors.primary,
                ),
                tooltip: trSafe(
                  'ai.scan_temp_tooltip',
                  fallback: 'Foto termometer',
                ),
                onPressed: onCameraTap,
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

class _CompactDropdown<T> extends StatelessWidget {
  const _CompactDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      isDense: true,
      isExpanded: true,
      style: TextStyle(fontSize: 13.sp, color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
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
