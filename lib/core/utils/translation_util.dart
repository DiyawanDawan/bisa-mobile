import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

/// Arah terjemahan ID ↔ EN hasil auto-detect.
typedef IdEnPair = ({String source, String target});

/// Utilitas terjemahan chat negosiasi on-device (Google ML Kit).
///
/// Model ID↔EN di-prefetch sekali (serialized) supaya tap "Terjemahkan"
/// hampir instan — tanpa hang unduh paralel.
abstract final class TranslationUtil {
  static const _defaultTimeout = Duration(seconds: 45);

  static Future<bool>? _ensureModelsFuture;
  static bool _modelsReady = false;

  static OnDeviceTranslator? _idToEn;
  static OnDeviceTranslator? _enToId;
  static LanguageIdentifier? _languageIdentifier;

  /// True jika model bahasa sudah siap dipakai (tanpa unduh lagi).
  static bool get isReady => _modelsReady;

  /// Prefetch model di background (aman dipanggil berkali-kali).
  static void warmUp() {
    unawaited(ensureModelsReady());
  }

  /// Pastikan model ID & EN terunduh. Unduhan di-serialize (satu Future bersama).
  static Future<bool> ensureModelsReady({
    Duration timeout = _defaultTimeout,
  }) {
    if (_modelsReady) return Future.value(true);

    return _ensureModelsFuture ??= _downloadModels(timeout).whenComplete(() {
      if (!_modelsReady) {
        // Izinkan retry jika gagal / timeout.
        _ensureModelsFuture = null;
      }
    });
  }

  static Future<bool> _downloadModels(Duration timeout) async {
    final manager = OnDeviceTranslatorModelManager();
    try {
      // Sequential — unduh paralel sering hang di ML Kit.
      await () async {
        await _ensureOneModel(manager, TranslateLanguage.indonesian.bcpCode);
        await _ensureOneModel(manager, TranslateLanguage.english.bcpCode);
      }()
          .timeout(timeout);

      _idToEn ??= OnDeviceTranslator(
        sourceLanguage: TranslateLanguage.indonesian,
        targetLanguage: TranslateLanguage.english,
      );
      _enToId ??= OnDeviceTranslator(
        sourceLanguage: TranslateLanguage.english,
        targetLanguage: TranslateLanguage.indonesian,
      );
      // Threshold rendah: chat pendek sering gagal di 0.5.
      _languageIdentifier ??= LanguageIdentifier(confidenceThreshold: 0.25);

      _modelsReady = true;
      return true;
    } on TimeoutException {
      debugPrint('TranslationUtil: model download timed out');
      return false;
    } catch (e, st) {
      debugPrint('TranslationUtil: model download failed — $e\n$st');
      return false;
    }
  }

  static Future<void> _ensureOneModel(
    OnDeviceTranslatorModelManager manager,
    String bcpCode,
  ) async {
    final downloaded = await manager.isModelDownloaded(bcpCode);
    if (!downloaded) {
      await manager.downloadModel(bcpCode);
    }
  }

  /// Mendeteksi bahasa dari [text]. Kode BCP-47 ('id', 'en') atau 'und'.
  static Future<String> identifyLanguage(String text) async {
    final probe = _textForLanguageProbe(text);
    if (probe.isEmpty) return 'und';

    _languageIdentifier ??= LanguageIdentifier(confidenceThreshold: 0.25);
    try {
      final languageCode = await _languageIdentifier!
          .identifyLanguage(probe)
          .timeout(const Duration(seconds: 5));
      return _normalizeLangCode(languageCode);
    } catch (_) {
      return 'und';
    }
  }

  /// Auto-detect arah ID ↔ EN untuk chat negosiasi.
  ///
  /// - Bahasa Indonesia / Melayu → terjemah ke Inggris
  /// - Bahasa Inggris → terjemah ke Indonesia
  /// - Gagal deteksi → heuristic + default ID→EN (mayoritas chat BISA)
  static Future<IdEnPair?> resolveIdEnDirection(String text) async {
    final probe = _textForLanguageProbe(text);
    if (probe.isEmpty) return null;

    var detected = await identifyLanguage(text);
    detected = _mapToIdOrEn(detected);

    if (detected == 'id' || detected == 'en') {
      return (
        source: detected,
        target: detected == 'id' ? 'en' : 'id',
      );
    }

    // Heuristic fallback bila ML Kit bilang und / bahasa lain.
    if (_looksLikeEnglish(probe)) {
      return (source: 'en', target: 'id');
    }
    if (_looksLikeIndonesian(probe)) {
      return (source: 'id', target: 'en');
    }

    // Default produk BISA: chat biasanya Indonesia → Inggris.
    return (source: 'id', target: 'en');
  }

  /// Terjemahkan [text] ID ↔ EN dengan auto-detect arah.
  static Future<String> translateAuto(String text) async {
    final pair = await resolveIdEnDirection(text);
    if (pair == null) {
      throw StateError('Nothing to translate');
    }
    return translate(
      text: text,
      sourceLanguageCode: pair.source,
      targetLanguageCode: pair.target,
    );
  }

  /// Terjemahkan [text] ID ↔ EN. Memastikan model siap dulu.
  /// Throws jika model gagal diunduh atau terjemahan gagal.
  static Future<String> translate({
    required String text,
    required String sourceLanguageCode,
    required String targetLanguageCode,
  }) async {
    final source = _normalizeLangCode(sourceLanguageCode);
    final target = _normalizeLangCode(targetLanguageCode);

    if (source == target) return text;
    if (!_isSupportedPair(source, target)) {
      throw StateError('Unsupported language pair: $source → $target');
    }

    final ready = await ensureModelsReady();
    if (!ready) {
      throw TimeoutException('Translation model not ready');
    }

    final translator = _translatorFor(source, target);
    if (translator == null) return text;

    return translator.translateText(text).timeout(const Duration(seconds: 8));
  }

  static OnDeviceTranslator? _translatorFor(String source, String target) {
    if (source == 'id' && target == 'en') return _idToEn;
    if (source == 'en' && target == 'id') return _enToId;
    return null;
  }

  static bool _isSupportedPair(String source, String target) =>
      (source == 'id' && target == 'en') || (source == 'en' && target == 'id');

  /// Buang URL/angka supaya deteksi bahasa tidak jadi 'und'.
  static String _textForLanguageProbe(String text) {
    return text
        .replaceAll(
          RegExp(r'https?:\/\/\S+|www\.\S+', caseSensitive: false),
          ' ',
        )
        .replaceAll(RegExp(r'[\d\W_]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Melayu sering salah-deteksi untuk teks Indonesia → treat as ID.
  static String _mapToIdOrEn(String code) {
    final normalized = _normalizeLangCode(code);
    return switch (normalized) {
      'id' || 'ms' || 'jv' || 'su' => 'id',
      'en' => 'en',
      _ => normalized,
    };
  }

  static bool _looksLikeEnglish(String text) {
    final lower = text.toLowerCase();
    const markers = [
      ' the ',
      ' and ',
      ' please ',
      ' price ',
      ' order ',
      ' can ',
      ' we ',
      ' you ',
      ' hello ',
      ' thanks ',
      ' for ',
      ' this ',
      ' that ',
      ' with ',
    ];
    final padded = ' $lower ';
    var hits = 0;
    for (final m in markers) {
      if (padded.contains(m)) hits++;
    }
    return hits >= 2;
  }

  static bool _looksLikeIndonesian(String text) {
    final lower = text.toLowerCase();
    const markers = [
      ' yang ',
      ' dan ',
      ' untuk ',
      ' saya ',
      ' kamu ',
      ' bisa ',
      ' harga ',
      ' mohon ',
      ' silakan ',
      ' tertarik ',
      ' tawaran ',
      ' nego ',
      ' kirim ',
      ' bayar ',
      ' sudah ',
      ' belum ',
      ' dengan ',
      ' dari ',
      ' halo ',
      ' terima ',
      ' kasih ',
    ];
    final padded = ' $lower ';
    var hits = 0;
    for (final m in markers) {
      if (padded.contains(m)) hits++;
    }
    // Satu kata khas ID sudah cukup (chat pendek).
    return hits >= 1;
  }

  /// Normalisasi kode bahasa (mis. 'in' → 'id', 'en-US' → 'en').
  static String _normalizeLangCode(String code) {
    final normalized = code.toLowerCase().split('-').first;
    return switch (normalized) {
      'in' => 'id', // ISO 639-1 lama untuk Indonesian
      _ => normalized,
    };
  }
}
