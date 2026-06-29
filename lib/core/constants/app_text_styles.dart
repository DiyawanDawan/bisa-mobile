import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

/// Semantic text styles — map DESIGN-CORE §3 tokens to ScreenUtil sizes.
abstract class AppTextStyles {
  /// AppBar title — `display-page-title`
  static TextStyle pageTitle({
    Color? color,
    FontWeight fontWeight = FontWeight.w800,
    double letterSpacing = -0.5,
  }) =>
      TextStyle(
        fontSize: 18.sp,
        fontWeight: fontWeight,
        color: color ?? AppColors.textPrimary,
        letterSpacing: letterSpacing,
      );

  /// Section heading — `title-section`
  static TextStyle sectionTitle({
    Color? color,
    FontWeight fontWeight = FontWeight.w700,
  }) =>
      TextStyle(
        fontSize: 16.sp,
        fontWeight: fontWeight,
        color: color ?? AppColors.textPrimary,
      );

  /// Primary body — `body-primary`
  static TextStyle body({
    Color? color,
    FontWeight fontWeight = FontWeight.w500,
    double? height,
  }) =>
      TextStyle(
        fontSize: 14.sp,
        fontWeight: fontWeight,
        color: color ?? AppColors.textPrimary,
        height: height,
      );

  /// Compact body — between body and caption
  static TextStyle bodySm({
    Color? color,
    FontWeight fontWeight = FontWeight.w500,
    double? height,
  }) =>
      TextStyle(
        fontSize: 13.sp,
        fontWeight: fontWeight,
        color: color ?? AppColors.textPrimary,
        height: height,
      );

  /// Secondary/meta — `body-secondary`
  static TextStyle bodySecondary({
    Color? color,
    FontWeight fontWeight = FontWeight.w400,
    double? height,
  }) =>
      TextStyle(
        fontSize: 12.sp,
        fontWeight: fontWeight,
        color: color ?? AppColors.textSecondary,
        height: height,
      );

  /// Small label — `caption`
  static TextStyle caption({
    Color? color,
    FontWeight fontWeight = FontWeight.w500,
    double? height,
  }) =>
      TextStyle(
        fontSize: 11.sp,
        fontWeight: fontWeight,
        color: color ?? AppColors.textSecondary,
        height: height,
      );

  /// Chip / badge — `label-chip`
  static TextStyle chip({
    Color? color,
    FontWeight fontWeight = FontWeight.w600,
    double? fontSize,
  }) =>
      TextStyle(
        fontSize: fontSize ?? 10.sp,
        fontWeight: fontWeight,
        color: color ?? AppColors.textSecondary,
      );

  /// CTA label — `button-label` (default lg 16.sp)
  static TextStyle button({
    Color? color,
    double? fontSize,
    double letterSpacing = 0.5,
    FontWeight fontWeight = FontWeight.w700,
  }) =>
      TextStyle(
        fontSize: fontSize ?? 16.sp,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        color: color ?? AppColors.textOnPrimary,
      );

  /// Price emphasis
  static TextStyle price({
    Color? color,
    FontWeight fontWeight = FontWeight.w700,
  }) =>
      TextStyle(
        fontSize: 14.sp,
        fontWeight: fontWeight,
        color: color ?? AppColors.primary,
      );

  /// Micro label (bottom nav, tiny badges)
  static TextStyle micro({
    Color? color,
    FontWeight fontWeight = FontWeight.w600,
    double letterSpacing = 0.2,
  }) =>
      TextStyle(
        fontSize: 8.sp,
        fontWeight: fontWeight,
        color: color ?? AppColors.textSecondary,
        letterSpacing: letterSpacing,
      );

  /// Form field value
  static TextStyle fieldValue({
    Color? color,
    FontWeight fontWeight = FontWeight.w500,
  }) =>
      TextStyle(
        fontSize: 15.sp,
        fontWeight: fontWeight,
        color: color ?? AppColors.textPrimary,
      );

  /// Form field label
  static TextStyle fieldLabel({
    Color? color,
    FontWeight fontWeight = FontWeight.w600,
  }) =>
      TextStyle(
        fontSize: 13.sp,
        fontWeight: fontWeight,
        color: color ?? AppColors.textSecondary,
        letterSpacing: 0.2,
      );

  /// Form hint
  static TextStyle fieldHint({Color? color}) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.textHint,
      );

  /// Bottom sheet hero title
  static TextStyle sheetTitle({
    Color? color,
    FontWeight fontWeight = FontWeight.w900,
    double letterSpacing = -0.5,
  }) =>
      TextStyle(
        fontSize: 24.sp,
        fontWeight: fontWeight,
        color: color ?? AppColors.textPrimary,
        letterSpacing: letterSpacing,
      );
}
