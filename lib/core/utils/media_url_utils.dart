import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/media_config.dart';

/// Normalisasi URL media dari API (path R2, LoremFlickr, localhost).
/// Jangan pakai [Image.network] langsung untuk field dari backend — gunakan
/// [BisaNetworkImage], [resolveMediaImageProvider], atau [resolveMediaField].
///
/// Header wajib untuk ngrok free tier agar image request tidak dapat HTML interstitial.
const Map<String, String> networkImageHttpHeaders = {
  'ngrok-skip-browser-warning': 'true',
  'Accept': 'image/*,*/*',
};

const _localHosts = {'localhost', '127.0.0.1', '10.0.2.2'};

/// Normalisasi URL media: relative path, localhost, host API, endpoint R2 privat.
String resolveMediaUrl(String? url) {
  if (url == null) return '';
  final trimmed = url.trim();
  if (trimmed.isEmpty) return '';

  if (!_looksLikeAbsoluteUrl(trimmed)) {
    if (trimmed.startsWith('external/loremflickr/')) {
      return _loremFlickrPathToUrl(trimmed);
    }
    return _resolveRelativePath(trimmed);
  }

  Uri mediaUri;
  try {
    mediaUri = Uri.parse(trimmed);
  } catch (_) {
    return trimmed;
  }

  var resolved = trimmed;

  final pathKey = mediaUri.path.replaceFirst(RegExp(r'^/'), '');
  if (_isStorageObjectPath(pathKey)) {
    return _resolveRelativePath(pathKey);
  }

  if (_localHosts.contains(mediaUri.host.toLowerCase())) {
    resolved = _rewriteHost(resolved, mediaUri);
  } else if (mediaUri.host.contains('r2.cloudflarestorage.com')) {
    resolved = _rewritePrivateR2Url(mediaUri);
  } else if (mediaUri.path.contains('/storage/assets/')) {
    final idx = mediaUri.path.indexOf('/storage/assets/');
    final key = mediaUri.path.substring(idx + '/storage/assets/'.length);
    resolved = _resolveRelativePath(key);
  } else {
    resolved = _alignStorageAssetHost(resolved, mediaUri);
  }

  return resolved;
}

/// Field nullable dari model → URL siap pakai untuk entity/UI (null jika kosong).
String? resolveMediaField(String? url) {
  final resolved = resolveMediaUrl(url);
  return resolved.isEmpty ? null : resolved;
}

/// Apakah URL avatar/gambar bisa dimuat setelah normalisasi (bukan null/kosong).
bool hasResolvableMediaUrl(String? url) => resolveMediaUrl(url).isNotEmpty;

/// ImageProvider untuk CircleAvatar / DecorationImage dengan URL ter-resolve + header ngrok.
ImageProvider? resolveMediaImageProvider(String? url) {
  final resolved = resolveMediaUrl(url);
  if (resolved.isEmpty) return null;
  return CachedNetworkImageProvider(
    resolved,
    headers: networkImageHttpHeaders,
  );
}

bool _looksLikeAbsoluteUrl(String value) {
  return value.startsWith('http://') || value.startsWith('https://');
}

bool _isStorageObjectPath(String path) {
  const prefixes = [
    'products/',
    'avatars/',
    'store-banners/',
    'general/',
    'forum/',
    'negotiations/',
    'articles/',
    'categories/',
  ];
  return prefixes.any((p) => path.startsWith(p));
}

/// Fallback jika API mengembalikan path DB placeholder (bukan URL penuh).
String _loremFlickrPathToUrl(String dbPath) {
  const prefix = 'external/loremflickr/';
  if (!dbPath.startsWith(prefix)) return dbPath;

  final rest = dbPath.substring(prefix.length);
  final segments = rest.split('/').where((s) => s.isNotEmpty).toList();
  if (segments.length < 3) return dbPath;

  final width = segments[0];
  final height = segments[1];
  final keywordParts = <String>[];
  var i = 2;
  while (i < segments.length &&
      segments[i] != 'lock' &&
      segments[i] != 'random') {
    keywordParts.add(segments[i]);
    i++;
  }

  final keywordPath = keywordParts.join('/');
  final buffer = StringBuffer('https://loremflickr.com/$width/$height/$keywordPath');

  if (i < segments.length && segments[i] == 'lock' && i + 1 < segments.length) {
    buffer.write('?lock=${segments[i + 1]}');
    i += 2;
    if (i < segments.length && segments[i] == 'random' && i + 1 < segments.length) {
      buffer.write('&random=${segments[i + 1]}');
    }
  } else if (i < segments.length && segments[i] == 'random' && i + 1 < segments.length) {
    buffer.write('?random=${segments[i + 1]}');
  }

  return buffer.toString();
}

String _resolveRelativePath(String path) {
  final base = MediaConfig.mediaBaseUrl;
  if (base.isEmpty) return path;

  final normalized = path.startsWith('/') ? path.substring(1) : path;

  // R2 CDN: https://cdn.example.com/products/...
  if (MediaConfig.useDirectCdn) {
    return '$base/$normalized';
  }

  if (normalized.contains('storage/assets/')) {
    return '$base/${normalized.startsWith('/') ? normalized.substring(1) : normalized}';
  }
  return '$base${MediaConfig.storageAssetsPrefix}$normalized';
}

String _rewriteHost(String original, Uri mediaUri) {
  final base = MediaConfig.mediaBaseUrl;
  if (base.isEmpty) return original;

  Uri baseUri;
  try {
    baseUri = Uri.parse(base);
  } catch (_) {
    return original;
  }

  return mediaUri.replace(
    scheme: baseUri.scheme,
    host: baseUri.host,
    port: baseUri.hasPort ? baseUri.port : null,
  ).toString();
}

String _rewritePrivateR2Url(Uri mediaUri) {
  final path = mediaUri.path.replaceFirst(RegExp(r'^/'), '');
  if (path.isEmpty) return mediaUri.toString();
  return _resolveRelativePath(path);
}

String _alignStorageAssetHost(String original, Uri mediaUri) {
  if (!original.contains(MediaConfig.storageAssetsPrefix)) return original;

  final base = MediaConfig.mediaBaseUrl;
  if (base.isEmpty) return original;

  Uri baseUri;
  try {
    baseUri = Uri.parse(base);
  } catch (_) {
    return original;
  }

  if (mediaUri.host == baseUri.host) return original;

  return mediaUri.replace(
    scheme: baseUri.scheme,
    host: baseUri.host,
    port: baseUri.hasPort ? baseUri.port : null,
  ).toString();
}
