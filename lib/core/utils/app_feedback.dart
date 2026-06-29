import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../errors/failures.dart';
import '../i18n/failure_messages.dart';
import 'safe_area_utils.dart';

void _showFeedbackSnackBar(
  BuildContext context,
  String message,
  Color backgroundColor, {
  Duration? duration,
  Widget? content,
}) {
  showBisaSnackBar(
    context,
    content: content ?? Text(localizeFailureMessage(message)),
    backgroundColor: backgroundColor,
    duration: duration ?? const Duration(seconds: 4),
  );
}

/// SnackBar sukses — margin aman via [showBisaSnackBar].
void showSuccessSnackBar(
  BuildContext context,
  String message, {
  Duration? duration,
}) {
  _showFeedbackSnackBar(
    context,
    message,
    AppColors.success,
    duration: duration,
  );
}

/// SnackBar peringatan (validasi, stok, alamat).
void showWarningSnackBar(
  BuildContext context,
  String message, {
  Duration? duration,
}) {
  _showFeedbackSnackBar(
    context,
    message,
    AppColors.warning,
    duration: duration,
  );
}

/// SnackBar error teks (i18n key atau pesan mentah).
void showErrorSnackBar(
  BuildContext context,
  String message, {
  Duration? duration,
}) {
  _showFeedbackSnackBar(
    context,
    message,
    AppColors.error,
    duration: duration,
  );
}

/// SnackBar kustom (mis. toast stok dengan icon) — tetap safe margin.
void showCustomSnackBar(
  BuildContext context, {
  required Widget content,
  required Color backgroundColor,
  Duration duration = const Duration(seconds: 4),
  SnackBarAction? action,
}) {
  showBisaSnackBar(
    context,
    content: content,
    backgroundColor: backgroundColor,
    duration: duration,
    action: action,
  );
}

/// SnackBar dari domain [Failure].
void showFailureSnackBar(BuildContext context, Failure failure) {
  showErrorSnackBar(context, failure.message);
}

/// SnackBar dari string API / exception mentah.
void showFailureSnackBarFromMessage(BuildContext context, String raw) {
  showErrorSnackBar(context, raw);
}
