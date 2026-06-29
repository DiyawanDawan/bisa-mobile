import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../currency/display_currency_service.dart';
import '../i18n/locale_formatters.dart';

/// Format checkout, invoice, wallet — selalu IDR (kontrak backend).
String formatMoneyIdr(num value) {
  return NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(value);
}

/// Format katalog/card — hormati [DisplayCurrencyService] (FB-19).
String formatMoneyDisplay(num value) {
  return DisplayCurrencyService.instance.formatIdr(value);
}

/// Format uang mengikuti locale aktif (EasyLocalization).
String formatMoneyLocale(BuildContext context, num value) {
  return LocaleFormatters.formatCurrency(context, value);
}
