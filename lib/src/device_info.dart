import 'dart:ui';

import 'package:package_info_plus/package_info_plus.dart';

import 'package:umami_flutter_sdk/src/device_id_service.dart';

/// Immutable snapshot of device metadata collected at init time.
class DeviceInfo {
  final String deviceId;
  final String locale;
  final String screenResolution;

  /// App version (e.g. `1.4.2`), sent as the Umami `tag` field.
  /// `null` if the version could not be determined.
  final String? appVersion;

  const DeviceInfo({
    required this.deviceId,
    required this.locale,
    required this.screenResolution,
    this.appVersion,
  });

  @override
  String toString() =>
      'DeviceInfo(deviceId: $deviceId, locale: $locale, '
      'screen: $screenResolution, appVersion: $appVersion)';
}

/// Gathers device ID, locale, screen resolution, and app version in one
/// async call.
///
/// Every field has a safe fallback so [gather] never throws.
class DeviceInfoService {
  DeviceInfoService._();

  static Future<DeviceInfo> gather({String? appVersionOverride}) async {
    return DeviceInfo(
      deviceId: await _resolveDeviceId(),
      locale: _resolveLocale(),
      screenResolution: _resolveScreenResolution(),
      appVersion: appVersionOverride ?? await _resolveAppVersion(),
    );
  }

  static Future<String> _resolveDeviceId() async {
    try {
      return await DeviceIdService.getId();
    } catch (_) {
      return 'unknown';
    }
  }

  static String _resolveLocale() {
    try {
      return PlatformDispatcher.instance.locale.toString();
    } catch (_) {
      return 'en';
    }
  }

  static String _resolveScreenResolution() {
    try {
      final displays = PlatformDispatcher.instance.displays;
      if (displays.isNotEmpty) {
        final display = displays.first;
        final size = display.size / display.devicePixelRatio;
        return '${size.width.toInt()}x${size.height.toInt()}';
      }
    } catch (_) {
      // Display API unavailable
    }
    return '0x0';
  }

  static Future<String?> _resolveAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return info.version.isEmpty ? null : info.version;
    } catch (_) {
      // Platform plugin not available
      return null;
    }
  }
}
