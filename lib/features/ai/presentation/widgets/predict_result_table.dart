import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/i18n/tr_safe.dart';

/// Tabel hasil prediksi kualitas biochar (grade, yield, harga, dll).
class PredictResultTable extends StatelessWidget {
  const PredictResultTable({
    super.key,
    required this.prediction,
    this.compact = false,
    this.onAddToProduct,
  });

  final Map<String, dynamic> prediction;
  final bool compact;
  final VoidCallback? onAddToProduct;

  static Map<String, dynamic>? parseRawOutput(Map<String, dynamic>? prediction) {
    if (prediction == null) return null;
    final raw = prediction['rawOutput'];
    if (raw == null) return null;
    try {
      return jsonDecode(raw.toString()) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static String formatIdr(num? value) {
    if (value == null) return '—';
    final n = value.round();
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final meta = parseRawOutput(prediction);
    final grade = prediction['predictedGrade']?.toString() ?? '—';
    final yieldPct = _formatPercent(prediction['predictedYield']);
    final cOrganik = _formatPercent(prediction['cOrganik']);
    final dosis = prediction['dosis']?.toString() ?? '—';
    final pricePerTon = meta?['predicted_price_idr_per_ton'];
    final totalIdr = meta?['predicted_total_idr'];

    final rows = <_PredictRow>[
      _PredictRow(
        label: trSafe('ai.predict_table_grade', fallback: 'Grade'),
        value: grade,
        badge: true,
      ),
      _PredictRow(
        label: trSafe('ai.predict_table_yield', fallback: 'Yield'),
        value: yieldPct,
      ),
      _PredictRow(
        label: trSafe('ai.predict_table_carbon', fallback: 'Karbon organik'),
        value: cOrganik,
      ),
      _PredictRow(
        label: trSafe('ai.predict_table_dosis', fallback: 'Dosis rekomendasi'),
        value: '$dosis ton/ha',
      ),
    ];

    if (pricePerTon != null) {
      final perTon = pricePerTon is num ? pricePerTon : num.tryParse('$pricePerTon');
      rows.add(
        _PredictRow(
          label: trSafe('ai.predict_table_price_ton', fallback: 'Harga estimasi'),
          value: 'Rp ${formatIdr(perTon)}/ton',
        ),
      );
      if (totalIdr != null) {
        final total = totalIdr is num ? totalIdr : num.tryParse('$totalIdr');
        rows.add(
          _PredictRow(
            label: trSafe('ai.predict_table_price_batch', fallback: 'Nilai batch'),
            value: 'Rp ${formatIdr(total)}',
            emphasize: true,
          ),
        );
      }
    }

    final titleSize = compact ? 12.sp : 14.sp;
    final labelSize = compact ? 10.sp : 11.sp;
    final valueSize = compact ? 11.sp : 12.sp;
    final padH = compact ? 8.w : 10.w;
    final padV = compact ? 6.h : 8.h;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Text(
            'ai.predict_result_title'.tr(),
            style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w800),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.grey200),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Column(
              children: [
                _headerRow(labelSize),
                for (var i = 0; i < rows.length; i++)
                  _dataRow(
                    rows[i],
                    labelSize: labelSize,
                    valueSize: valueSize,
                    padH: padH,
                    padV: padV,
                    striped: i.isOdd,
                    isLast: i == rows.length - 1,
                  ),
              ],
            ),
          ),
        ),
        if (onAddToProduct != null && prediction['id'] != null) ...[
          SizedBox(height: 8.h),
          SizedBox(
            height: compact ? 36.h : 40.h,
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onAddToProduct,
              icon: Icon(LucideIcons.package, size: compact ? 14.sp : 16.sp),
              label: Text(
                trSafe('ai.predict_add_to_product', fallback: 'Tambah ke Produk'),
                style: TextStyle(fontSize: compact ? 11.sp : 12.sp),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _headerRow(double fontSize) {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.08),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              trSafe('ai.predict_table_col_metric', fallback: 'Metrik'),
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              trSafe('ai.predict_table_col_value', fallback: 'Nilai'),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dataRow(
    _PredictRow row, {
    required double labelSize,
    required double valueSize,
    required double padH,
    required double padV,
    required bool striped,
    required bool isLast,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: striped ? AppColors.grey50 : AppColors.surface,
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: AppColors.grey100, width: 1)),
      ),
      padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              row.label,
              style: TextStyle(fontSize: labelSize, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            flex: 5,
            child: row.badge
                ? _gradeBadge(row.value, valueSize)
                : Text(
                    row.value,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: valueSize,
                      fontWeight: row.emphasize ? FontWeight.w800 : FontWeight.w700,
                      color: row.emphasize ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _gradeBadge(String grade, double fontSize) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
        ),
        child: Text(
          grade,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  String _formatPercent(dynamic value) {
    if (value == null) return '—';
    final n = value is num ? value.toDouble() : double.tryParse('$value');
    if (n == null) return value.toString();
    return '${n.toStringAsFixed(2)}%';
  }
}

class _PredictRow {
  const _PredictRow({
    required this.label,
    required this.value,
    this.badge = false,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool badge;
  final bool emphasize;
}
