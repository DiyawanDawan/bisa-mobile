import 'package:mobile_bisa/core/utils/text_recognition_util.dart';

/// Hasil pengenalan OCR dan pencocokan nominal bukti transfer.
class PaymentProofOcrResult {
  final double? detectedAmount;
  final bool isAmountMatch;
  final String? detectedBank;
  final String? detectedDate;
  final List<String> rawLines;

  const PaymentProofOcrResult({
    this.detectedAmount,
    required this.isAmountMatch,
    this.detectedBank,
    this.detectedDate,
    required this.rawLines,
  });
}

/// Helper untuk mengekstrak data dari bukti transfer manual menggunakan ML Kit Text Recognition.
abstract final class PaymentProofOcrUtil {
  /// Cari dan bersihkan angka dari suatu baris teks.
  static double? _parseAmount(String line) {
    // Hapus Rp, IDR, spasi, koma nol-nol di akhir
    var clean = line.replaceAll(RegExp(r'(Rp|IDR|\s)', caseSensitive: false), '');
    
    // Cari pola angka uang, misalnya: 150.000 atau 150,000 atau 150000
    final regex = RegExp(r'\b\d{1,3}(?:[.,]\d{3})+(?:\b|[.,]\d{2}\b)|\b\d{4,9}\b');
    final match = regex.firstMatch(clean);
    if (match == null) return null;
    
    var numStr = match.group(0)!;
    
    // Potong desimal sen jika .00 atau ,00
    if (numStr.endsWith(',00') || numStr.endsWith('.00')) {
      numStr = numStr.substring(0, numStr.length - 3);
    }
    
    // Hilangkan semua tanda titik/koma pemisah ribuan
    numStr = numStr.replaceAll(RegExp(r'[.,]'), '');
    
    return double.tryParse(numStr);
  }

  /// Proses bukti transfer dan bandingkan dengan nominal invoice yang diharapkan.
  static Future<PaymentProofOcrResult> processReceipt(
    String imagePath,
    double expectedAmount,
  ) async {
    final lines = await TextRecognitionUtil.extractLines(imagePath);
    
    double? detectedAmount;
    bool isAmountMatch = false;
    String? detectedBank;
    String? detectedDate;

    // 1. Deteksi nama bank penerbit bukti transfer
    final bankKeywords = {
      'BCA': 'Bank Central Asia (BCA)',
      'MANDIRI': 'Bank Mandiri',
      'BNI': 'Bank Negara Indonesia (BNI)',
      'BRI': 'Bank Rakyat Indonesia (BRI)',
      'DANAMON': 'Bank Danamon',
      'CIMB': 'CIMB Niaga',
      'PERMATA': 'Permata Bank',
      'BSI': 'Bank Syariah Indonesia (BSI)',
    };
    
    for (final line in lines) {
      final upper = line.toUpperCase();
      for (final entry in bankKeywords.entries) {
        if (upper.contains(entry.key)) {
          detectedBank = entry.value;
          break;
        }
      }
      if (detectedBank != null) break;
    }

    // 2. Deteksi tanggal transaksi
    final dateRegex = RegExp(r'\b\d{2}[-/\.]\d{2}[-/\.]\d{4}\b|\b\d{2}\s[A-Za-z]{3,9}\s\d{4}\b');
    for (final line in lines) {
      final match = dateRegex.firstMatch(line);
      if (match != null) {
        detectedDate = match.group(0);
        break;
      }
    }

    // 3. Cocokkan nominal transfer dengan expectedAmount (toleransi selisih +/- 1000 rupiah untuk kode unik transfer)
    for (final line in lines) {
      final val = _parseAmount(line);
      if (val != null) {
        final diff = (val - expectedAmount).abs();
        if (diff <= 1000) {
          detectedAmount = val;
          isAmountMatch = true;
          break;
        }
      }
    }

    // Jika tidak ada yang cocok presisi, ambil nominal terbesar yang realistis
    if (detectedAmount == null) {
      double maxVal = 0;
      for (final line in lines) {
        final val = _parseAmount(line);
        if (val != null && val > 1000) {
          // Hindari salah deteksi nomor rekening / nomor referensi panjang
          if (val.toString().length < 10) {
            if (val > maxVal) {
              maxVal = val;
            }
          }
        }
      }
      if (maxVal > 0) {
        detectedAmount = maxVal;
        final diff = (detectedAmount - expectedAmount).abs();
        if (diff <= 1000) {
          isAmountMatch = true;
        }
      }
    }

    return PaymentProofOcrResult(
      detectedAmount: detectedAmount,
      isAmountMatch: isAmountMatch,
      detectedBank: detectedBank,
      detectedDate: detectedDate,
      rawLines: lines,
    );
  }
}
