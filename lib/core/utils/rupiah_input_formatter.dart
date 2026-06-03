import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final _rupiahFormat = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);

/// Input harga dalam format Rupiah (Rp 1.500.000).
class RupiahInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(text: '');
    }
    final value = int.tryParse(digits);
    if (value == null) return oldValue;
    final formatted = _rupiahFormat.format(value);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Parse teks field Rupiah ke angka.
double? parseRupiahInput(String? text) {
  if (text == null || text.trim().isEmpty) return null;
  final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) return null;
  return double.tryParse(digits);
}

/// Format angka ke teks field Rupiah.
String formatRupiahInput(num value) {
  return _rupiahFormat.format(value.round());
}
