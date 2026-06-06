import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';

/// Inset bawah sistem (home indicator / 3-button nav).
double systemBottomInset(BuildContext context) =>
    MediaQuery.paddingOf(context).bottom;

/// Jenis clearance scroll di tab main shell (FAB AI + bottom nav).
enum MainShellScrollKind {
  standard,
  forum,
  orders,
  grid,
}

/// Padding scroll bawah di tab main shell.
double mainShellBottomPadding(
  BuildContext context, {
  MainShellScrollKind kind = MainShellScrollKind.standard,
}) {
  final base = switch (kind) {
    MainShellScrollKind.standard => 96.h,
    MainShellScrollKind.forum => 80.h,
    MainShellScrollKind.orders => 100.h,
    MainShellScrollKind.grid => 160.h,
  };
  return base + systemBottomInset(context);
}

/// Alias lama — tab standar (profil, toko supplier).
double mainShellScrollBottomPadding(BuildContext context) =>
    mainShellBottomPadding(context);

/// Padding bawah sheet: keyboard + system nav.
EdgeInsets sheetBottomPadding(BuildContext context) => EdgeInsets.only(
      bottom: MediaQuery.viewInsetsOf(context).bottom +
          MediaQuery.paddingOf(context).bottom,
    );

/// Padding scroll halaman full-screen (tanpa bottom nav shell).
EdgeInsets fullScreenScrollPadding(
  BuildContext context, {
  double horizontal = 0,
  double top = 0,
  double baseBottom = 24,
}) {
  return EdgeInsets.fromLTRB(
    horizontal.w,
    top.h,
    horizontal.w,
    baseBottom.h + systemBottomInset(context),
  );
}

/// Offset `Positioned(bottom:)` untuk FAB/legend di peta GIS.
double gisMapFloatingBottomOffset(
  BuildContext context, {
  required bool panelOpen,
}) {
  final system = systemBottomInset(context);
  return panelOpen ? 260.h + system : 80.h + system;
}

/// Margin SnackBar aman dari system nav (+ opsional sticky footer).
EdgeInsets bisaSnackBarMargin(
  BuildContext context, {
  double extraBottom = 0,
}) =>
    EdgeInsets.fromLTRB(
      16.w,
      16.h,
      16.w,
      16.h + systemBottomInset(context) + extraBottom,
    );

/// SnackBar terpusat dengan safe area.
void showBisaSnackBar(
  BuildContext context, {
  required Widget content,
  Color? backgroundColor,
  Duration duration = const Duration(seconds: 4),
  SnackBarAction? action,
  double extraBottom = 0,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: content,
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: bisaSnackBarMargin(context, extraBottom: extraBottom),
      duration: duration,
      action: action,
    ),
  );
}

/// Pesan teks singkat.
void showBisaSnackBarMessage(
  BuildContext context,
  String message, {
  bool isError = false,
  Duration duration = const Duration(seconds: 4),
  double extraBottom = 0,
}) {
  showBisaSnackBar(
    context,
    content: Text(message),
    backgroundColor: isError ? AppColors.error : AppColors.success,
    duration: duration,
    extraBottom: extraBottom,
  );
}

/// Perkiraan tinggi sticky footer instruksi pembayaran.
double paymentInstructionFooterClearance = 88.h;
