import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

const _maxEdge = 1920;
const _jpegQuality = 85;
const _skipBelowBytes = 2 * 1024 * 1024;

/// Kompresi gambar sebelum upload: max edge 1920px, JPEG quality 85.
/// PDF dan file kecil (<2MB) dilewati.
Future<String> compressImageIfNeeded(String localPath) async {
  final lower = localPath.toLowerCase();
  if (lower.endsWith('.pdf')) return localPath;

  final file = File(localPath);
  if (!await file.exists()) return localPath;

  final size = await file.length();
  if (size < _skipBelowBytes) return localPath;

  if (kIsWeb) return localPath;

  try {
    final dir = await getTemporaryDirectory();
    final ext = _fileExtension(localPath);
    final usePng = ext == '.png';
    final targetPath =
        '${dir.path}/bisa_upload_${DateTime.now().millisecondsSinceEpoch}${usePng ? '.png' : '.jpg'}';

    final result = await FlutterImageCompress.compressAndGetFile(
      localPath,
      targetPath,
      quality: _jpegQuality,
      minWidth: _maxEdge,
      minHeight: _maxEdge,
      format: usePng ? CompressFormat.png : CompressFormat.jpeg,
    );

    return result?.path ?? localPath;
  } catch (_) {
    return localPath;
  }
}

String _fileExtension(String path) {
  final dot = path.lastIndexOf('.');
  if (dot < 0) return '';
  return path.substring(dot).toLowerCase();
}
