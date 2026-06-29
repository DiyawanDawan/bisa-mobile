import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_bisa/core/constants/app_layout.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/utils/safe_area_utils.dart';
import 'package:mobile_bisa/shared/widgets/custom_button.dart';
import 'package:mobile_bisa/shared/widgets/custom_text_field.dart';

enum NegotiationClosureAction { rejectBySupplier, cancelByBuyer }

class _ClosurePreset {
  const _ClosurePreset({required this.id, required this.labelKey});

  final String id;
  final String labelKey;
}

const _kOtherPresetId = 'other';

class NegotiationClosureDialog {
  static Future<String?> show(
    BuildContext context, {
    required NegotiationClosureAction action,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (ctx) => _NegotiationClosureSheet(action: action),
    );
  }
}

class _NegotiationClosureSheet extends StatefulWidget {
  const _NegotiationClosureSheet({required this.action});

  final NegotiationClosureAction action;

  @override
  State<_NegotiationClosureSheet> createState() =>
      _NegotiationClosureSheetState();
}

class _NegotiationClosureSheetState extends State<_NegotiationClosureSheet> {
  final _customController = TextEditingController();
  String? _selectedPresetId;
  String? _error;

  bool get _isSupplierReject =>
      widget.action == NegotiationClosureAction.rejectBySupplier;

  List<_ClosurePreset> get _presets => _isSupplierReject
      ? const [
          _ClosurePreset(
            id: 'price_low',
            labelKey: 'negotiation.closure_preset_price_low',
          ),
          _ClosurePreset(
            id: 'stock',
            labelKey: 'negotiation.closure_preset_stock',
          ),
          _ClosurePreset(
            id: 'spec',
            labelKey: 'negotiation.closure_preset_spec',
          ),
          _ClosurePreset(
            id: 'schedule',
            labelKey: 'negotiation.closure_preset_schedule',
          ),
        ]
      : const [
          _ClosurePreset(
            id: 'needs_change',
            labelKey: 'negotiation.closure_preset_needs_change',
          ),
          _ClosurePreset(
            id: 'other_offer',
            labelKey: 'negotiation.closure_preset_other_offer',
          ),
          _ClosurePreset(
            id: 'mistake',
            labelKey: 'negotiation.closure_preset_mistake',
          ),
          _ClosurePreset(
            id: 'renegotiate',
            labelKey: 'negotiation.closure_preset_renegotiate',
          ),
        ];

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  String? _resolveReason() {
    if (_selectedPresetId == _kOtherPresetId) {
      final custom = _customController.text.trim();
      if (custom.length < 5) {
        setState(() => _error = 'negotiation.closure_custom_min'.tr());
        return null;
      }
      return custom;
    }
    if (_selectedPresetId == null) {
      setState(() => _error = 'negotiation.closure_select_reason'.tr());
      return null;
    }
    final preset = _presets.firstWhere((p) => p.id == _selectedPresetId);
    return preset.labelKey.tr();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: sheetBottomPadding(context),
      child: Container(
        margin: EdgeInsets.fromLTRB(AppSpacing.md12, 0, AppSpacing.md12, AppSpacing.md12),
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.xlPx.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isSupplierReject
                  ? 'negotiation.closure_title_reject'.tr()
                  : 'negotiation.closure_title_cancel'.tr(),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              _isSupplierReject
                  ? 'negotiation.closure_subtitle_reject'.tr()
                  : 'negotiation.closure_subtitle_cancel'.tr(),
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            ..._presets.map(
              (preset) => Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.sm),
                child: _ReasonTile(
                  label: preset.labelKey.tr(),
                  selected: _selectedPresetId == preset.id,
                  onTap: () => setState(() {
                    _selectedPresetId = preset.id;
                    _error = null;
                  }),
                ),
              ),
            ),
            _ReasonTile(
              label: 'negotiation.closure_other'.tr(),
              selected: _selectedPresetId == _kOtherPresetId,
              onTap: () => setState(() {
                _selectedPresetId = _kOtherPresetId;
                _error = null;
              }),
            ),
            if (_selectedPresetId == _kOtherPresetId) ...[
              SizedBox(height: AppSpacing.sm),
              CustomTextField(
                label: 'negotiation.closure_custom_label'.tr(),
                controller: _customController,
                hint: 'negotiation.closure_custom_hint'.tr(),
                maxLines: 3,
              ),
            ],
            if (_error != null) ...[
              SizedBox(height: AppSpacing.sm),
              Text(
                _error!,
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'batal'.tr(),
                    isOutlined: true,
                    height: 48.h,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                SizedBox(width: AppSpacing.md12),
                Expanded(
                  child: CustomButton(
                    text: _isSupplierReject
                        ? 'negotiation.closure_action_reject'.tr()
                        : 'negotiation.closure_action_cancel'.tr(),
                    height: 48.h,
                    backgroundColor: AppColors.error,
                    onPressed: () {
                      final reason = _resolveReason();
                      if (reason != null) Navigator.pop(context, reason);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReasonTile extends StatelessWidget {
  const _ReasonTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.primary.withValues(alpha: 0.08)
          : AppColors.grey50,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.section, vertical: AppSpacing.md12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.grey200,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                size: 18.sp,
                color: selected ? AppColors.primary : AppColors.grey400,
              ),
              SizedBox(width: AppSpacing.sm10),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
