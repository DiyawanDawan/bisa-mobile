import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Ekstrak baris-baris teks dari foto dokumen menggunakan ML Kit Text
/// Recognition (on-device, tanpa training/model custom).
///
/// Desain sengaja "tap-to-pick", BUKAN auto-fill heuristik: untuk dokumen
/// resmi (KTP/NIB/SIUP) yang formatnya bisa bervariasi, lebih aman
/// menampilkan kandidat baris hasil OCR dan biarkan user memilih baris yang
/// benar, daripada menebak baris mana yang berisi nama usaha/NPWP/alamat.
/// Lihat planning_mlkit_ocr_features.md Track B untuk alasan lengkap.
abstract final class TextRecognitionUtil {
  /// Membaca [imagePath], mengembalikan daftar baris teks yang terdeteksi
  /// (kosong jika tidak ada teks/foto tidak terbaca).
  static Future<List<String>> extractLines(String imagePath) async {
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final result = await recognizer.processImage(inputImage);

      final lines = <String>[];
      for (final block in result.blocks) {
        for (final line in block.lines) {
          final text = line.text.trim();
          if (text.isNotEmpty) lines.add(text);
        }
      }
      return lines;
    } finally {
      await recognizer.close();
    }
  }
}
