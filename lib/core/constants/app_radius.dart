import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Token border radius responsif.
abstract class AppRadius {
  AppRadius._();

  /// Nilai desain px untuk [ThemeData] (tanpa ScreenUtil).
  static const double smPx = 6;
  static const double mdPx = 10;
  static const double lgPx = 12;
  static const double tilePx = 14;
  static const double xlPx = 16;
  static const double pillPx = 20;
  static const double buttonPx = 8;

  /// 6px — chip kecil, badge
  static double get sm => smPx.r;

  /// 8px — text button, ghost CTA
  static double get button => buttonPx.r;

  /// 10px — icon container dalam list tile
  static double get md => mdPx.r;

  /// 12px — card kecil
  static double get lg => lgPx.r;

  /// 14px — list tile / menu row (Fitur Penting)
  static double get tile => tilePx.r;

  /// 16px — card, modal, primary button
  static double get xl => xlPx.r;

  /// 20px — pill / avatar rounded
  static double get pill => pillPx.r;
}
