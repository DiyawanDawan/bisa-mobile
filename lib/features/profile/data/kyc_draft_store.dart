import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

/// Draft lokal KYC — path foto + field bisnis, supaya user bisa lanjut nanti.
class KycDraft {
  const KycDraft({
    this.step = 0,
    this.ktpPath,
    this.selfiePath,
    this.nibPath,
    this.siupPath,
    this.businessName = '',
    this.taxId = '',
    this.businessAddress = '',
  });

  final int step;
  final String? ktpPath;
  final String? selfiePath;
  final String? nibPath;
  final String? siupPath;
  final String businessName;
  final String taxId;
  final String businessAddress;

  KycDraft copyWith({
    int? step,
    String? ktpPath,
    String? selfiePath,
    String? nibPath,
    String? siupPath,
    String? businessName,
    String? taxId,
    String? businessAddress,
    bool clearKtp = false,
    bool clearSelfie = false,
    bool clearNib = false,
    bool clearSiup = false,
  }) {
    return KycDraft(
      step: step ?? this.step,
      ktpPath: clearKtp ? null : (ktpPath ?? this.ktpPath),
      selfiePath: clearSelfie ? null : (selfiePath ?? this.selfiePath),
      nibPath: clearNib ? null : (nibPath ?? this.nibPath),
      siupPath: clearSiup ? null : (siupPath ?? this.siupPath),
      businessName: businessName ?? this.businessName,
      taxId: taxId ?? this.taxId,
      businessAddress: businessAddress ?? this.businessAddress,
    );
  }

  Map<String, dynamic> toJson() => {
        'step': step,
        'ktpPath': ktpPath,
        'selfiePath': selfiePath,
        'nibPath': nibPath,
        'siupPath': siupPath,
        'businessName': businessName,
        'taxId': taxId,
        'businessAddress': businessAddress,
      };

  factory KycDraft.fromJson(Map<String, dynamic> json) {
    return KycDraft(
      step: (json['step'] as num?)?.toInt() ?? 0,
      ktpPath: json['ktpPath']?.toString(),
      selfiePath: json['selfiePath']?.toString(),
      nibPath: json['nibPath']?.toString(),
      siupPath: json['siupPath']?.toString(),
      businessName: json['businessName']?.toString() ?? '',
      taxId: json['taxId']?.toString() ?? '',
      businessAddress: json['businessAddress']?.toString() ?? '',
    );
  }

  /// Buang path file yang sudah tidak ada di disk.
  KycDraft withExistingFilesOnly() {
    String? keep(String? path) {
      if (path == null || path.isEmpty) return null;
      return File(path).existsSync() ? path : null;
    }

    return KycDraft(
      step: step.clamp(0, 3),
      ktpPath: keep(ktpPath),
      selfiePath: keep(selfiePath),
      nibPath: keep(nibPath),
      siupPath: keep(siupPath),
      businessName: businessName,
      taxId: taxId,
      businessAddress: businessAddress,
    );
  }
}

class KycDraftStore {
  KycDraftStore(this._prefs);

  final SharedPreferences _prefs;
  static const _key = 'kyc_verification_draft_v1';

  Future<KycDraft?> load() async {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw);
      if (map is! Map) return null;
      return KycDraft.fromJson(Map<String, dynamic>.from(map))
          .withExistingFilesOnly();
    } catch (_) {
      return null;
    }
  }

  Future<void> save(KycDraft draft) async {
    await _prefs.setString(_key, jsonEncode(draft.toJson()));
  }

  Future<void> clear() async {
    await _prefs.remove(_key);
  }
}
