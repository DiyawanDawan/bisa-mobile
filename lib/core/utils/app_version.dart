import 'package:package_info_plus/package_info_plus.dart';

class AppVersion {
  static PackageInfo? _cached;

  static Future<PackageInfo> get info async {
    _cached ??= await PackageInfo.fromPlatform();
    return _cached!;
  }

  static Future<String> get fullLabel async {
    final package = await info;
    return 'v${package.version} (${package.buildNumber})';
  }

  static Future<String> get shortLabel async {
    final package = await info;
    return 'v${package.version}';
  }

  static Future<String> get appName async {
    final package = await info;
    return package.appName;
  }
}
