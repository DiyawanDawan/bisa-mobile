import 'package:intl/intl.dart';

/// Formats a numeric market value to match [currentValue] unit style (e.g. `/kg`, flat IDR).
String formatMarketPriceLikeCurrent(num value, String currentValue) {
  final formatted = NumberFormat('#,##0', 'id_ID').format(value.round());

  if (currentValue.contains('/kg')) return 'Rp $formatted/kg';
  if (currentValue.contains('/ton')) return 'Rp $formatted/ton';
  if (currentValue.contains('Rp') && !currentValue.contains('/')) {
    return 'Rp $formatted';
  }
  if (value >= 500000) return 'Rp $formatted';
  return 'Rp $formatted/kg';
}
