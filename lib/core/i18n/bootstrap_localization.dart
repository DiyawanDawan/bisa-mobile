import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/localization.dart';
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/widgets.dart';

const _translationsPath = 'assets/translations';
const _fallbackLocale = Locale('id', 'ID');

/// Loads translation maps before [runApp] so startup services can call [tr].
Future<void> bootstrapLocalization(Locale locale) async {
  const loader = RootBundleAssetLoader();
  final map = await loader.load(_translationsPath, locale);
  final fallbackMap = await loader.load(_translationsPath, _fallbackLocale);
  Localization.load(
    locale,
    translations: map != null ? Translations(map) : null,
    fallbackTranslations:
        fallbackMap != null ? Translations(fallbackMap) : null,
  );
}
