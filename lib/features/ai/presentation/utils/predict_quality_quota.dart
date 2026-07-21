import 'package:shared_preferences/shared_preferences.dart';

import '../../../auth/domain/entities/user_entity.dart';

/// Kuota prediksi grade biochar: 3x/bulan untuk semua user.
/// Langganan PRO hanya berlaku untuk IoT, bukan fitur AI.
class PredictQualityQuota {
  static const freeLimitPerMonth = 3;

  static String _monthKey() {
    final now = DateTime.now();
    return 'ai_predict_count_${now.year}_${now.month}';
  }

  static Future<int> usedThisMonth() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_monthKey()) ?? 0;
  }

  static Future<int> remaining(UserEntity? user) async {
    final used = await usedThisMonth();
    return (freeLimitPerMonth - used).clamp(0, freeLimitPerMonth);
  }

  static Future<bool> canPredict(UserEntity? user) async {
    return (await usedThisMonth()) < freeLimitPerMonth;
  }

  static Future<void> recordUsage(UserEntity? user) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _monthKey();
    await prefs.setInt(key, (prefs.getInt(key) ?? 0) + 1);
  }
}
