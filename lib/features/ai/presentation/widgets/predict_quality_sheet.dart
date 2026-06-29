import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/i18n/failure_messages.dart';
import '../../../../core/i18n/tr_safe.dart';
import '../../../../core/utils/batch_weight_util.dart';
import '../../../../core/utils/pro_subscription.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/batch_weight_field.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../domain/repositories/ai_repository.dart';
import '../utils/predict_quality_quota.dart';
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
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
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
    final beratKg = BatchWeightUtil.parseFieldToKg(_weightCtrl.text, _weightUnit);

    if (temp == null || time == null || beratKg == null) {
      setState(() => _error = 'ai.predict_invalid_input'.tr());
      return;
    }
    if (temp < 20 || temp > 1000) {
      setState(() => _error = trSafe(
            'ai.predict_temp_range',
            fallback: 'Suhu harus antara 20–1000°C',
          ));
      return;
    }
    if (time < 1) {
      setState(() => _error = trSafe(
            'ai.predict_time_min',
            fallback: 'Waktu pembakaran minimal 1 menit',
          ));
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

  String _biomassLabel(String type) => type.replaceAll('_', ' ');

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u,
          orElse: () => null,
        );
    final isPro = user != null && isProActive(user);

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.92),
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
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
                Icon(LucideIcons.sparkles, color: AppColors.primary, size: 18.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'ai.predict_title'.tr(),
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              isPro
                  ? 'ai.predict_subtitle_pro'.tr()
                  : 'ai.predict_subtitle_free'.tr(namedArgs: {'remaining': '$_remaining'}),
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
                      child: Text(_biomassLabel(t), style: TextStyle(fontSize: 13.sp)),
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
                  border: Border.all(color: AppColors.error.withValues(alpha: 0.25)),
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
              height: 44.h,
              child: CustomButton(
                text: 'ai.predict_submit'.tr(),
                isLoading: _loading,
                onPressed: _loading ? null : _predict,
              ),
            ),
            if (!isPro && _remaining <= 0) ...[
              SizedBox(height: 6.h),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    context.push('/iot-subscription');
                  },
                  child: Text(
                    'ai.predict_upgrade_pro'.tr(),
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
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
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final String? suffix;

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
