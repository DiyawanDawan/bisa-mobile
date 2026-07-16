import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

/// Utilitas untuk mendeteksi keberadaan wajah pada foto (kyc selfie).
/// Menggunakan Google ML Kit Face Detection (on-device).
abstract final class FaceDetectorUtil {
  /// Membaca file gambar dari [imagePath] dan mendeteksi apakah terdapat
  /// setidaknya satu wajah di dalamnya.
  static Future<bool> detectFace(String imagePath) async {
    final options = FaceDetectorOptions(
      performanceMode: FaceDetectorMode.fast,
    );
    final faceDetector = FaceDetector(options: options);
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final faces = await faceDetector.processImage(inputImage);
      return faces.isNotEmpty;
    } finally {
      await faceDetector.close();
    }
  }
}
