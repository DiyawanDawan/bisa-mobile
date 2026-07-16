import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

/// Utilitas untuk identifikasi bahasa & penerjemahan teks chat negosiasi secara on-device.
/// Menggunakan Google ML Kit (on-device translation & language ID).
abstract final class TranslationUtil {
  /// Mendeteksi bahasa dari [text]. Mengembalikan kode BCP-47 (misal 'id', 'en'),
  /// atau 'und' jika tidak dapat dideteksi.
  static Future<String> identifyLanguage(String text) async {
    final languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
    try {
      final languageCode = await languageIdentifier.identifyLanguage(text);
      return languageCode;
    } catch (_) {
      return 'und';
    } finally {
      await languageIdentifier.close();
    }
  }

  /// Menerjemahkan [text] antara Bahasa Inggris ('en') dan Bahasa Indonesia ('id').
  /// Otomatis mengunduh model bahasa jika belum terpasang di perangkat.
  static Future<String> translate({
    required String text,
    required String sourceLanguageCode,
    required String targetLanguageCode,
  }) async {
    final sourceLang = _mapCodeToLanguage(sourceLanguageCode);
    final targetLang = _mapCodeToLanguage(targetLanguageCode);

    if (sourceLang == null || targetLang == null || sourceLang == targetLang) {
      return text;
    }

    final translator = OnDeviceTranslator(
      sourceLanguage: sourceLang,
      targetLanguage: targetLang,
    );

    final modelManager = OnDeviceTranslatorModelManager();
    try {
      // Pastikan model bahasa sumber terunduh
      final isSourceDownloaded = await modelManager.isModelDownloaded(sourceLang.bcpCode);
      if (!isSourceDownloaded) {
        await modelManager.downloadModel(sourceLang.bcpCode);
      }

      // Pastikan model bahasa target terunduh
      final isTargetDownloaded = await modelManager.isModelDownloaded(targetLang.bcpCode);
      if (!isTargetDownloaded) {
        await modelManager.downloadModel(targetLang.bcpCode);
      }

      final translatedText = await translator.translateText(text);
      return translatedText;
    } finally {
      await translator.close();
    }
  }

  static TranslateLanguage? _mapCodeToLanguage(String code) {
    final normalized = code.toLowerCase().split('-').first;
    return switch (normalized) {
      'en' => TranslateLanguage.english,
      'id' => TranslateLanguage.indonesian,
      _ => null,
    };
  }
}
