import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Token spacing responsif (design width 393 — lihat [ScreenUtilInit] di main.dart).
/// Gunakan untuk padding, margin, dan jarak antar elemen.
abstract class AppSpacing {
  AppSpacing._();

  static const double xsPx = 4;
  static const double xs6Px = 6;
  static const double smPx = 8;
  static const double sm10Px = 10;
  static const double md12Px = 12;
  static const double mdPx = 16;
  static const double lgPx = 20;
  static const double xlPx = 24;
  static const double xl28Px = 28;
  static const double xxlPx = 32;
  static const double sectionPx = 14;
  static const double xxxlPx = 40;
  static const double buttonHeightSmPx = 40;
  static const double buttonHeightPx = 48;
  static const double buttonHeightLgPx = 56;

  /// 4px — gap sangat kecil (badge, icon-text)
  static double get xs => xsPx.w;

  /// 6px — gap icon dalam tombol
  static double get xs6 => xs6Px.w;

  /// 8px — gap kecil antar chip/label
  static double get sm => smPx.w;

  /// 10px — radius companion spacing
  static double get sm10 => sm10Px.w;

  /// 12px — padding kompak dalam card
  static double get md12 => md12Px.w;

  /// 16px — padding standar layar & card
  static double get md => mdPx.w;

  /// 20px — section spacing
  static double get lg => lgPx.w;

  /// 24px — jarak antar section besar
  static double get xl => xlPx.w;

  /// 28px — footer / CTA block
  static double get xl28 => xl28Px.w;

  /// 32px — header / hero spacing
  static double get xxl => xxlPx.w;

  /// 40px — large vertical rhythm
  static double get xxxl => xxxlPx.h;

  /// Tinggi tombol kecil
  static double get buttonHeightSm => buttonHeightSmPx.h;

  /// Tinggi tombol utama (standar)
  static double get buttonHeight => buttonHeightPx.h;

  /// Tinggi tombol besar
  static double get buttonHeightLg => buttonHeightLgPx.h;

  /// Padding horizontal standar layar
  static double get screenHorizontal => md;

  /// Padding vertikal standar section
  static double get sectionVertical => lg;

  /// `EdgeInsets.symmetric(horizontal: screenHorizontal)`
  static EdgeInsets get screenPaddingHorizontal =>
      EdgeInsets.symmetric(horizontal: screenHorizontal);

  /// `EdgeInsets.all(md)` — card / intro block
  static EdgeInsets get cardPadding => EdgeInsets.all(md);

  /// 14px — jarak antar section / list block
  static double get section => sectionPx.h;
}
