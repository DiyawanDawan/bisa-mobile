import 'package:flutter/material.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart'
    as mlkit;

/// On-device handwriting recognition menggunakan ML Kit Digital Ink Recognition.
///
/// Mendukung model bahasa Latin (cocok untuk ID & EN).
/// Model didownload otomatis saat pertama kali digunakan (~1–2 MB).
abstract final class DigitalInkUtil {
  static const _defaultLanguage = 'id'; // IETF BCP-47 language tag

  /// Download model bahasa jika belum ada di device.
  /// Panggil ini sebelum membuka canvas handwriting.
  static Future<bool> downloadModelIfNeeded({
    String languageTag = _defaultLanguage,
  }) async {
    final manager = mlkit.DigitalInkRecognizerModelManager();
    try {
      final isDownloaded = await manager.isModelDownloaded(languageTag);
      if (!isDownloaded) {
        return await manager.downloadModel(languageTag);
      }
      return true;
    } catch (e) {
      debugPrint('DigitalInkUtil: model download failed — $e');
      return false;
    }
  }

  /// Mengenali daftar stroke [ink] menjadi kandidat teks.
  /// Mengembalikan list kandidat terurut dari yang paling mungkin.
  static Future<List<String>> recognize(
    mlkit.Ink ink, {
    String languageTag = _defaultLanguage,
  }) async {
    final recognizer = mlkit.DigitalInkRecognizer(languageCode: languageTag);
    try {
      final candidates = await recognizer.recognize(ink);
      return candidates.map((c) => c.text).toList();
    } catch (e) {
      debugPrint('DigitalInkUtil: recognition failed — $e');
      return [];
    } finally {
      recognizer.close();
    }
  }
}
