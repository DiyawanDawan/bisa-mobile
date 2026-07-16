import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Ekstrak angka suhu (°C) dari foto termometer digital menggunakan
/// ML Kit Text Recognition (on-device, tanpa model/training custom).
///
/// Catatan desain (lihat planning_mlkit_ocr_features.md):
/// - Hasil ini SELALU harus jadi draft yang bisa dikoreksi user, jangan
///   pernah dipakai untuk auto-submit tanpa konfirmasi.
/// - Scope: termometer digital (7-segment display). Termometer analog
///   (jarum) di luar scope, kembalikan null (tidak ada digit yang cocok).
abstract final class TemperatureOcrUtil {
  static final RegExp _numberPattern = RegExp(r'-?\d+(\.\d+)?');

  /// Membaca [imagePath], mengembalikan kandidat suhu terbaik dalam
  /// rentang [minValid]..[maxValid], atau null jika tidak ada angka
  /// valid yang terdeteksi.
  static Future<double?> extractTemperature(
    String imagePath, {
    double minValid = 0,
    double maxValid = 1000,
  }) async {
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final result = await recognizer.processImage(inputImage);

      final candidates = <double>[];
      for (final block in result.blocks) {
        for (final line in block.lines) {
          for (final match in _numberPattern.allMatches(line.text)) {
            final raw = match.group(0);
            if (raw == null) continue;
            final value = double.tryParse(raw);
            if (value != null && value >= minValid && value <= maxValid) {
              candidates.add(value);
            }
          }
        }
      }

      if (candidates.isEmpty) return null;
      return _bestCandidate(candidates);
    } finally {
      await recognizer.close();
    }
  }

  /// Termometer biasanya menampilkan satu angka dominan. Kalau ML Kit
  /// mendeteksi beberapa angka (misal ada digit lain di background),
  /// ambil yang paling sering muncul; fallback ke kandidat pertama.
  static double _bestCandidate(List<double> candidates) {
    if (candidates.length == 1) return candidates.first;

    final counts = <double, int>{};
    for (final value in candidates) {
      counts[value] = (counts[value] ?? 0) + 1;
    }

    var best = candidates.first;
    var bestCount = 0;
    for (final entry in counts.entries) {
      if (entry.value > bestCount) {
        best = entry.key;
        bestCount = entry.value;
      }
    }
    return best;
  }
}
