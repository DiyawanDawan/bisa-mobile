import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/utils/safe_area_utils.dart';
import 'package:mobile_bisa/shared/widgets/custom_button.dart';
import 'package:mobile_bisa/shared/widgets/custom_text_field.dart';

enum NegotiationClosureAction { rejectBySupplier, cancelByBuyer }

class NegotiationClosureDialog {
  static Future<String?> show(
    BuildContext context, {
    required NegotiationClosureAction action,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
  String? _selectedPreset;
  String? _error;

  bool get _isSupplierReject =>
      widget.action == NegotiationClosureAction.rejectBySupplier;

  List<String> get _presets => _isSupplierReject
      ? const [
          'Harga penawaran terlalu rendah',
          'Stok tidak mencukupi',
          'Spesifikasi tidak sesuai',
          'Jadwal pengiriman tidak cocok',
        ]
      : const [
          'Kebutuhan berubah',
          'Menemukan penawaran lain',
          'Kesalahan jumlah/harga penawaran',
          'Ingin negosiasi ulang nanti',
        ];

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  String? _resolveReason() {
    if (_selectedPreset == 'Lainnya') {
      final custom = _customController.text.trim();
      if (custom.length < 5) {
        setState(() => _error = 'Alasan custom minimal 5 karakter');
        return null;
      }
      return custom;
    }
    if (_selectedPreset == null) {
      setState(() => _error = 'Pilih alasan terlebih dahulu');
      return null;
    }
    return _selectedPreset;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: sheetBottomPadding(context),
      child: Container(
        margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isSupplierReject ? 'Tolak Penawaran' : 'Batalkan Negosiasi',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              _isSupplierReject
                  ? 'Berikan alasan agar pembeli memahami keputusan Anda.'
                  : 'Berikan alasan pembatalan agar supplier mengetahui keputusan Anda.',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            SizedBox(height: 16.h),
            ..._presets.map(
              (preset) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: _ReasonTile(
                  label: preset,
                  selected: _selectedPreset == preset,
                  onTap: () => setState(() {
                    _selectedPreset = preset;
                    _error = null;
                  }),
                ),
              ),
            ),
            _ReasonTile(
              label: 'Lainnya',
              selected: _selectedPreset == 'Lainnya',
              onTap: () => setState(() {
                _selectedPreset = 'Lainnya';
                _error = null;
              }),
            ),
            if (_selectedPreset == 'Lainnya') ...[
              SizedBox(height: 8.h),
              CustomTextField(
                label: 'Alasan lain',
                controller: _customController,
                hint: 'Tulis alasan...',
                maxLines: 3,
              ),
            ],
            if (_error != null) ...[
              SizedBox(height: 8.h),
              Text(
                _error!,
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Batal',
                    isOutlined: true,
                    height: 48.h,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomButton(
                    text: _isSupplierReject ? 'Tolak' : 'Batalkan',
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
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
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
              SizedBox(width: 10.w),
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
