import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Format tanggal, mata uang, dan timeago mengikuti locale aktif aplikasi.
class LocaleFormatters {
  LocaleFormatters._();

  static String intlLocaleCode(Locale locale) {
    if (locale.languageCode == 'id') return 'id_ID';
    return 'en_US';
  }

  static String timeagoLocaleCode(Locale locale, {bool short = false}) {
    if (locale.languageCode == 'en') {
      return short ? 'en_short' : 'en';
    }
    return short ? 'id_short' : 'id';
  }

  static String formatCurrency(BuildContext context, num amount) {
    final code = intlLocaleCode(context.locale);
    return NumberFormat.currency(
      locale: code,
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  static String formatDate(BuildContext context, DateTime date) {
    final code = intlLocaleCode(context.locale);
    return DateFormat('d MMMM yyyy', code).format(date);
  }

  static String formatDateTime(BuildContext context, DateTime date) {
    final code = intlLocaleCode(context.locale);
    return DateFormat('d MMM yyyy, HH:mm', code).format(date);
  }

  static String formatDateTimeLong(BuildContext context, DateTime date) {
    final code = intlLocaleCode(context.locale);
    return DateFormat('EEEE, d MMMM yyyy · HH:mm', code).format(date);
  }

  static String formatTimeAgo(
    BuildContext context,
    DateTime date, {
    bool short = false,
  }) {
    return timeago.format(
      date,
      locale: timeagoLocaleCode(context.locale, short: short),
    );
  }
}

extension LocaleFormatContext on BuildContext {
  String formatCurrency(num amount) =>
      LocaleFormatters.formatCurrency(this, amount);

  String formatDate(DateTime date) =>
      LocaleFormatters.formatDate(this, date);

  String formatDateTime(DateTime date) =>
      LocaleFormatters.formatDateTime(this, date);

  String formatDateTimeLong(DateTime date) =>
      LocaleFormatters.formatDateTimeLong(this, date);

  String formatTimeAgo(DateTime date, {bool short = false}) =>
      LocaleFormatters.formatTimeAgo(this, date, short: short);
}
