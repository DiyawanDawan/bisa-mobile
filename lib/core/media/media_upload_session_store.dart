import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PendingUploadSession {
  const PendingUploadSession({
    required this.localPath,
    required this.sessionId,
    required this.folder,
    required this.updatedAtMs,
  });

  final String localPath;
  final String sessionId;
  final String folder;
  final int updatedAtMs;

  Map<String, dynamic> toJson() => {
        'localPath': localPath,
        'sessionId': sessionId,
        'folder': folder,
        'updatedAtMs': updatedAtMs,
      };

  factory PendingUploadSession.fromJson(Map<String, dynamic> json) {
    return PendingUploadSession(
      localPath: json['localPath'] as String,
      sessionId: json['sessionId'] as String,
      folder: json['folder'] as String,
      updatedAtMs: json['updatedAtMs'] as int? ?? 0,
    );
  }
}

/// Persist sesi upload agar bisa resume setelah app killed atau jaringan putus.
class MediaUploadSessionStore {
  MediaUploadSessionStore(this._prefs);

  static const _storageKey = 'media_upload_pending_sessions_v1';

  final SharedPreferences _prefs;

  Future<List<PendingUploadSession>> listAll() async {
    final raw = _prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return decoded
          .whereType<Map>()
          .map((e) => PendingUploadSession.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<String?> getSessionId(String localPath) async {
    final sessions = await listAll();
    for (final session in sessions.reversed) {
      if (session.localPath == localPath) return session.sessionId;
    }
    return null;
  }

  Future<void> save(PendingUploadSession session) async {
    final sessions = await listAll()
      ..removeWhere((s) => s.localPath == session.localPath)
      ..add(session);
    await _persist(sessions);
  }

  Future<void> clear(String localPath) async {
    final sessions = await listAll()..removeWhere((s) => s.localPath == localPath);
    await _persist(sessions);
  }

  Future<void> clearAll() async {
    await _prefs.remove(_storageKey);
  }

  Future<void> _persist(List<PendingUploadSession> sessions) async {
    final encoded = jsonEncode(sessions.map((s) => s.toJson()).toList());
    await _prefs.setString(_storageKey, encoded);
  }
}
