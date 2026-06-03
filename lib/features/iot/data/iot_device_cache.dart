import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/iot_device_model.dart';

class IotDeviceCache {
  static const _key = 'iot_devices_cache_v1';

  Future<void> saveDevices(List<IotDeviceModel> devices) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = devices.map((d) => d.toJson()).toList();
    await prefs.setString(_key, jsonEncode(jsonList));
  }

  Future<List<IotDeviceModel>?> loadDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => IotDeviceModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
