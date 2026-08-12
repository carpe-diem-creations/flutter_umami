import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

/// Builds a realistic browser User-Agent string embedding the device's real
/// OS version, so Umami's Environment panel (Browser / OS / Device) reports
/// accurate OS data instead of a hardcoded version.
///
/// Umami parses the User-Agent header to populate those fields, so the
/// strings must look like genuine browser UAs.
class UserAgentBuilder {
  UserAgentBuilder._();

  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Returns a platform-appropriate browser UA with the real OS version.
  ///
  /// Never throws — falls back to [fallback] if device info is unavailable.
  static Future<String> build() async {
    try {
      if (Platform.isAndroid) {
        final android = await _deviceInfo.androidInfo;
        final version = android.version.release;
        final model = android.model;
        return 'Mozilla/5.0 (Linux; Android $version; $model) '
            'AppleWebKit/537.36 (KHTML, like Gecko) '
            'Chrome/122.0.0.0 Mobile Safari/537.36';
      } else if (Platform.isIOS) {
        final ios = await _deviceInfo.iosInfo;
        final underscored = ios.systemVersion.replaceAll('.', '_');
        if (ios.model.toLowerCase().contains('ipad')) {
          return 'Mozilla/5.0 (iPad; CPU OS $underscored like Mac OS X) '
              'AppleWebKit/605.1.15 (KHTML, like Gecko) '
              'Version/${ios.systemVersion} Mobile/15E148 Safari/604.1';
        }
        return 'Mozilla/5.0 (iPhone; CPU iPhone OS $underscored '
            'like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) '
            'Version/${ios.systemVersion} Mobile/15E148 Safari/604.1';
      } else if (Platform.isMacOS) {
        final mac = await _deviceInfo.macOsInfo;
        final version =
            '${mac.majorVersion}_${mac.minorVersion}_${mac.patchVersion}';
        return 'Mozilla/5.0 (Macintosh; Intel Mac OS X $version) '
            'AppleWebKit/537.36 (KHTML, like Gecko) '
            'Chrome/122.0.0.0 Safari/537.36';
      }
      // Windows: browser UAs are frozen at NT 10.0 for both Windows 10
      // and 11, so a real version would break UA parsers — use fallback.
    } catch (_) {
      // Platform plugin unavailable — fall through
    }
    return fallback();
  }

  /// Static platform-appropriate UA with a generic OS version.
  static String fallback() {
    if (Platform.isAndroid) {
      return 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 '
          '(KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36';
    } else if (Platform.isIOS) {
      return 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) '
          'AppleWebKit/605.1.15 (KHTML, like Gecko) '
          'Version/17.0 Mobile/15E148 Safari/604.1';
    } else if (Platform.isMacOS) {
      return 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) '
          'AppleWebKit/537.36 (KHTML, like Gecko) '
          'Chrome/122.0.0.0 Safari/537.36';
    }
    return 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
        '(KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36';
  }
}
