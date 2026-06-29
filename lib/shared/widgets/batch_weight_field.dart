import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_colors.dart';
import '../../core/i18n/tr_safe.dart';
import '../../core/utils/batch_weight_util.dart';

/// Input berat batch dengan pilihan satuan Ton atau Kg (API tetap kg).
class BatchWeightField extends StatefulWidget {
  const BatchWeightField({
    super.key,
    required this.controller,
    this.initialUnit,
    this.initialKg,
    this.dense = true,
    this.onUnitChanged,
  });

  final TextEditingController controller;
  final BatchWeightUnit? initialUnit;
  final num? initialKg;
  final bool dense;
  final ValueChanged<BatchWeightUnit>? onUnitChanged;

  @override
  State<BatchWeightField> createState() => _BatchWeightFieldState();
}

class _BatchWeightFieldState extends State<BatchWeightField> {
  late BatchWeightUnit _unit;

  @override
  void initState() {
    super.initState();
    _unit = widget.initialUnit ??
        BatchWeightUtil.preferredUnitForKg(widget.initialKg);
    if (widget.initialKg != null) {
      widget.controller.text = _unit.formatFromKgNullable(widget.initialKg);
    }
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  void _setUnit(BatchWeightUnit next) {
    if (next == _unit) return;
    final current = double.tryParse(widget.controller.text.trim());
    if (current != null && current > 0) {
      final kg = _unit.toKg(current);
      widget.controller.text = next.formatFromKg(kg);
    } else {
      widget.controller.text = next == BatchWeightUnit.ton ? '1' : '1000';
    }
    setState(() => _unit = next);
    widget.onUnitChanged?.call(next);
  }

  double? get _parsedKg =>
      BatchWeightUtil.parseFieldToKg(widget.controller.text, _unit);

  @override
  Widget build(BuildContext context) {
    final unitLabel = _unit == BatchWeightUnit.ton ? 'ton' : 'kg';
    final exampleKey = _unit == BatchWeightUnit.ton
        ? 'common.weight_example_ton'
        : 'common.weight_example_kg';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: widget.controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(fontSize: 14.sp),
                decoration: InputDecoration(
                  labelText: trSafe('common.weight_input_label', fallback: 'Berat input'),
                  hintText: _unit == BatchWeightUnit.ton ? '1' : '1',
                  isDense: true,
                  suffixText: unitLabel,
                  suffixStyle: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
            SizedBox(width: 6.w),
            _UnitToggle(unit: _unit, onChanged: _setUnit),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          trSafe(
            exampleKey,
            fallback: _unit == BatchWeightUnit.ton
                ? '1 ton → pilih Ton, ketik 1'
                : '1 kg → pilih Kg, ketik 1',
          ),
          style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondary),
        ),
        if (_parsedKg != null) ...[
          SizedBox(height: 2.h),
          Text(
            trSafe(
              'common.weight_sent_kg',
              namedArgs: {'value': _formatKg(_parsedKg!)},
              fallback: 'Dikirim ke server: {_value} kg',
            ),
            style: TextStyle(fontSize: 10.sp, color: AppColors.primary, fontWeight: FontWeight.w600),
          ),
        ],
      ],
    );
  }

  String _formatKg(double kg) {
    if ((kg - kg.round()).abs() < 0.01) return kg.round().toString();
    return kg.toStringAsFixed(1);
  }
}

class _UnitToggle extends StatelessWidget {
  const _UnitToggle({required this.unit, required this.onChanged});

  final BatchWeightUnit unit;
  final ValueChanged<BatchWeightUnit> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _unitChip(BatchWeightUnit.ton, 'common.weight_unit_ton', 'Ton'),
            Container(width: 1, height: 24.h, color: AppColors.grey200),
            _unitChip(BatchWeightUnit.kg, 'common.weight_unit_kg', 'Kg'),
          ],
        ),
      ),
    );
  }

  Widget _unitChip(BatchWeightUnit value, String key, String fallback) {
    final selected = unit == value;
    return Material(
      color: selected ? AppColors.primaryLight : Colors.transparent,
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        onTap: () => onChanged(value),
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Text(
            trSafe(key, fallback: fallback),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
