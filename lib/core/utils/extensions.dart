import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ── String Extensions ─────────────────────────────────────────────────────────

extension StringExt on String {
  /// Kapitalisasi huruf pertama setiap kata
  String get toTitleCase {
    return split(' ')
        .map((word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }

  /// Validasi format email sederhana
  bool get isValidEmail {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(this);
  }

  /// Validasi nomor telepon Indonesia
  bool get isValidPhone {
    return RegExp(r'^(\+62|62|0)[0-9]{8,13}$').hasMatch(this);
  }

  /// Apakah string ini angka?
  bool get isNumeric => double.tryParse(this) != null;

  /// Hapus spasi berlebih di awal, akhir, dan tengah
  String get clean => trim().replaceAll(RegExp(r'\s+'), ' ');

  /// Format ke currency IDR: "Rp 1.500.000"
  String get toRupiah {
    final num? value = num.tryParse(replaceAll('.', '').replaceAll(',', ''));
    if (value == null) return this;
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
        .format(value);
  }

  /// Singkat panjang string dengan elipsis
  String ellipsis(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }
}

extension NullableStringExt on String? {
  /// Apakah null atau kosong?
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

// ── DateTime Extensions ───────────────────────────────────────────────────────

extension DateTimeExt on DateTime {
  /// Format: "28 April 2026"
  String get toIndonesianDate {
    return DateFormat('d MMMM yyyy', 'id_ID').format(this);
  }

  /// Format: "28 Apr 2026, 15:30"
  String get toIndonesianDateTime {
    return DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(this);
  }

  /// Format: "15:30"
  String get toTime => DateFormat('HH:mm').format(this);

  /// Apakah hari ini?
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Waktu relatif: "2 jam lalu", "kemarin", dll.
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inSeconds < 60) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays == 1) return 'Kemarin';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} minggu lalu';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()} bulan lalu';
    return '${(diff.inDays / 365).floor()} tahun lalu';
  }
}

// ── Num Extensions ────────────────────────────────────────────────────────────

extension NumExt on num {
  /// Format ke Rupiah: "Rp 1.500.000"
  String get toRupiah {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
        .format(this);
  }

  /// SizedBox dengan tinggi [this]
  SizedBox get verticalSpace => SizedBox(height: toDouble());

  /// SizedBox dengan lebar [this]
  SizedBox get horizontalSpace => SizedBox(width: toDouble());

  /// EdgeInsets semua sisi
  EdgeInsets get edgeInsetsAll => EdgeInsets.all(toDouble());

  /// EdgeInsets horizontal
  EdgeInsets get edgeInsetsH =>
      EdgeInsets.symmetric(horizontal: toDouble());

  /// EdgeInsets vertikal
  EdgeInsets get edgeInsetsV =>
      EdgeInsets.symmetric(vertical: toDouble());
}

// ── BuildContext Extensions ────────────────────────────────────────────────────

extension ContextExt on BuildContext {
  // Screen size
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  // Theme shortcuts
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // Navigation
  void popPage<T>([T? result]) => Navigator.of(this).pop(result);
  Future<T?> pushPage<T>(Widget page) => Navigator.of(this).push<T>(
        MaterialPageRoute(builder: (_) => page),
      );
  Future<T?> pushReplacementPage<T>(Widget page) =>
      Navigator.of(this).pushReplacement<T, dynamic>(
        MaterialPageRoute(builder: (_) => page),
      );

  // SnackBar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Responsive
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;
  bool get isDesktop => screenWidth >= 1200;
}
