import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../i18n/failure_messages.dart';

/// Inset bawah sistem (home indicator / 3-button nav).
double systemBottomInset(BuildContext context) =>
    MediaQuery.paddingOf(context).bottom;

/// Jenis clearance scroll di tab main shell (FAB AI + bottom nav).
enum MainShellScrollKind { standard, forum, orders, grid }

/// Padding scroll bawah di tab main shell.
double mainShellBottomPadding(
  BuildContext context, {
  MainShellScrollKind kind = MainShellScrollKind.standard,
}) {
  // Bottom nav owns the system SafeArea. Scroll content only needs clearance
  // for the taller of nav/FAB plus one compact breathing gap.
  final navClearance = AppSpacing.bottomNavHeight + AppSpacing.sectionGap;
  final fabClearance = AppSpacing.fabSize + AppSpacing.compact;
  final shellClearance =
      math.max(navClearance, fabClearance) + AppSpacing.compact;
  return shellClearance;
}

/// Alias lama — tab standar (profil, toko supplier).
double mainShellScrollBottomPadding(BuildContext context) =>
    mainShellBottomPadding(context);

/// Padding bawah sheet: keyboard + system nav.
EdgeInsets sheetBottomPadding(BuildContext context) => EdgeInsets.only(
  bottom: math.max(
    MediaQuery.viewInsetsOf(context).bottom,
    MediaQuery.paddingOf(context).bottom,
  ),
);

/// Canonical modal/bottom-sheet padding.
///
/// Keyboard and system navigation are mutually exclusive in layout space, so
/// only the larger inset is applied. Do not wrap consumers in another SafeArea.
EdgeInsets bisaSheetPadding(
  BuildContext context, {
  double? top,
  double? horizontal,
  double? bottom,
}) {
  final safeBottom = math.max(
    MediaQuery.viewInsetsOf(context).bottom,
    MediaQuery.paddingOf(context).bottom,
  );
  return EdgeInsets.fromLTRB(
    horizontal ?? AppSpacing.pageGutter,
    top ?? AppSpacing.sectionGap,
    horizontal ?? AppSpacing.pageGutter,
    safeBottom + (bottom ?? AppSpacing.compact),
  );
}

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
EdgeInsets bisaSnackBarMargin(BuildContext context, {double extraBottom = 0}) =>
    EdgeInsets.fromLTRB(
      16.w,
      16.h,
      16.w,
      16.h + systemBottomInset(context) + extraBottom,
    );

/// Hapus snackbar yang masih di queue (mis. toast stok cart).
void clearBisaSnackBars(BuildContext context) {
  ScaffoldMessenger.of(context).clearSnackBars();
}

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
    content: Text(localizeFailureMessage(message)),
    backgroundColor: isError ? AppColors.error : AppColors.success,
    duration: duration,
    extraBottom: extraBottom,
  );
}

/// Perkiraan tinggi sticky footer instruksi pembayaran.
double paymentInstructionFooterClearance = 88.h;
