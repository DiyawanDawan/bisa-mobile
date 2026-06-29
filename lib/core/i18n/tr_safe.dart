import 'package:easy_localization/easy_localization.dart';

/// [tr] dengan fallback jika key belum ada di bundle (hot reload tidak muat ulang assets).
String trSafe(
  String key, {
  Map<String, String>? namedArgs,
  required String fallback,
}) {
  final text = key.tr(namedArgs: namedArgs);
  if (text == key) {
    var out = fallback;
    namedArgs?.forEach((k, v) {
      out = out.replaceAll('{$k}', v);
    });
    return out;
  }
  return text;
}
