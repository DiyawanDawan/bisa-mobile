/// Global readability boost for physical devices (APK).
///
/// Applied via [ScreenUtilInit.designSize] (smaller baseline → larger `.sp`)
/// and [AppFontScale.mediaTextFactor] on [MediaQuery.textScaler].
abstract final class AppFontScale {
  /// Design canvas width before readability boost (legacy Figma baseline).
  static const double baseDesignWidth = 393;

  /// Design canvas height before readability boost.
  static const double baseDesignHeight = 852;

  /// ~6% larger fonts/spacing on real devices — subtle but noticeable on APK.
  static const double readableBoost = 1.06;

  /// ScreenUtil design width after boost.
  static const double designWidth = baseDesignWidth / readableBoost;

  /// ScreenUtil design height after boost (keeps aspect ratio).
  static const double designHeight = baseDesignHeight / readableBoost;

  /// Extra scale for Material/theme text (non-`.sp` widgets).
  static const double mediaTextFactor = readableBoost;
}
