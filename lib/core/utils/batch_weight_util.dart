/// Konversi berat batch tungku BISA: UI ton/kg, API/ML kilogram.
abstract final class BatchWeightUtil {
  static const double kgPerTon = 1000;
  static const double defaultBatchTon = 1;

  static double tonToKg(double ton) => ton * kgPerTon;

  static double kgToTon(double kg) => kg / kgPerTon;

  /// Tampilkan di form (dari kg tersimpan di backend).
  static String formatTonForField(num? kg) {
    if (kg == null) return defaultBatchTon.toString();
    final ton = kgToTon(kg.toDouble());
    if ((ton - ton.round()).abs() < 0.001) return ton.round().toString();
    return ton.toStringAsFixed(2);
  }

  static String formatKgForField(num? kg) {
    if (kg == null) return '${(defaultBatchTon * kgPerTon).round()}';
    final v = kg.toDouble();
    if ((v - v.round()).abs() < 0.001) return v.round().toString();
    return v.toStringAsFixed(1);
  }

  static double? parseFieldToKg(String text, BatchWeightUnit unit) {
    final v = double.tryParse(text.trim());
    if (v == null || v <= 0) return null;
    return unit.toKg(v);
  }

  /// Satuan tampilan: di bawah 1 ton pakai Kg agar tidak jadi "0.00" ton.
  static BatchWeightUnit preferredUnitForKg(num? kg) {
    if (kg == null) return BatchWeightUnit.ton;
    return kg.toDouble() < kgPerTon ? BatchWeightUnit.kg : BatchWeightUnit.ton;
  }
}

enum BatchWeightUnit { ton, kg }

extension BatchWeightUnitX on BatchWeightUnit {
  double toKg(double value) =>
      this == BatchWeightUnit.ton ? BatchWeightUtil.tonToKg(value) : value;

  String formatFromKg(double kg) {
    if (this == BatchWeightUnit.ton) {
      return BatchWeightUtil.formatTonForField(kg);
    }
    return BatchWeightUtil.formatKgForField(kg);
  }

  String formatFromKgNullable(num? kg) {
    if (kg == null) {
      return this == BatchWeightUnit.ton
          ? '${BatchWeightUtil.defaultBatchTon}'
          : '${(BatchWeightUtil.defaultBatchTon * BatchWeightUtil.kgPerTon).round()}';
    }
    return formatFromKg(kg.toDouble());
  }
}
