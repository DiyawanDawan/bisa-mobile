import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/pro_subscription.dart';
import '../../../auth/domain/entities/user_entity.dart';

/// Free tier: 3 prediksi per bulan; Pro unlimited.
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
    if (user != null && isProActive(user)) return 999;
    final used = await usedThisMonth();
    return (freeLimitPerMonth - used).clamp(0, freeLimitPerMonth);
  }

  static Future<bool> canPredict(UserEntity? user) async {
    if (user != null && isProActive(user)) return true;
    return (await usedThisMonth()) < freeLimitPerMonth;
  }

  static Future<void> recordUsage(UserEntity? user) async {
    if (user != null && isProActive(user)) return;
    final prefs = await SharedPreferences.getInstance();
    final key = _monthKey();
    await prefs.setInt(key, (prefs.getInt(key) ?? 0) + 1);
  }
}
