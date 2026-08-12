## 0.3.1

- Fixed repository and homepage URLs in `pubspec.yaml` (moved to `carpe-diem-creations`).

## 0.3.0

- Added automatic app version capture — the version is read via `package_info_plus` at init and sent as the Umami `tag` field on every event, so all metrics can be filtered by app version in the dashboard (requires Umami v2.9+).
- Added optional `appVersion` parameter to `init()` to override the auto-detected version (e.g. to include build metadata or a flavor like `1.4.2-beta`).
- Added `appVersion` field to `DeviceInfo`.
- The default User-Agent now embeds the device's **real OS version** (and model on Android), so Umami's Environment panel reports accurate OS data instead of hardcoded versions. Windows keeps the frozen `NT 10.0` string, matching real browsers.
- Exported `UserAgentBuilder` for consumers who want to build or inspect the generated User-Agent.
- Widened `flutter_secure_storage` constraint to allow v11.x (`>=8.0.0 <12.0.0`).

## 0.2.1

- Widened `device_info_plus` constraint to allow v13.x (`>=9.0.0 <14.0.0`).

## 0.2.0

- Added `recordFirstOpen` parameter to `init()` — automatically sends a `first_open` event when the app is opened for the first time on a device.
- Added `DeviceIdService.isFirstLaunch` — indicates whether the current session is the device's first launch.
- **Note:** On iOS/macOS, Keychain persists across reinstalls, and on Windows, secure storage also survives reinstalls, so `first_open` fires only once per device on these platforms. On Android, secure storage is cleared on uninstall, so reinstalling the app will trigger `first_open` again.

## 0.1.3

- Widened dependency version constraints to reduce conflicts with host apps.

## 0.1.2

- Upgraded `device_info_plus` from ^11.5.0 to ^12.3.0.
- Upgraded `flutter_secure_storage` from ^9.2.4 to ^10.0.0.
- Upgraded `flutter_lints` from ^5.0.0 to ^6.0.0.
- Removed deprecated `encryptedSharedPreferences` parameter (auto-migrated by v10).
- Updated README with Firebase Analytics comparison and contributing guide.

## 0.1.1

### Bug Fixes

- Fixed `init()` — now recovers from failures and can be retried (was permanently broken after a single failure).
- Fixed double-`init()` call crash — second call is now safely ignored.
- Fixed HTTP client leak — reusing a single `IOClient` instead of creating a new one per event send.
- Fixed repository and homepage URLs in `pubspec.yaml`.
- Fixed version mismatch between `pubspec.yaml` and `CHANGELOG.md`.

### New Features

- Added `onError` callback parameter to `init()` for monitoring analytics failures in production.
- Added configurable `userAgent` parameter to `init()` to override the default browser User-Agent.
- Added `UmamiAnalytics.isInitialized` getter to check initialization state.
- Added `UmamiAnalytics.reset()` method for testing and re-initialization scenarios.
- Exported `DeviceIdService` so consumers can access the persistent device ID independently.

### Improvements

- Added `platforms` field to `pubspec.yaml` (Android, iOS, macOS, Windows — no web).
- Upgraded `uuid` dependency from ^3.0.5 to ^4.0.0.
- Added comprehensive dartdoc to all public API surfaces.
- Added `example/main.dart` with full usage demo.
- Added 15 unit tests (was previously empty).
- Updated `README.md` with full API reference, init parameters table, and architecture overview.

## 0.1.0

- Initial release.
- Non-blocking `init()` with automatic device info collection.
- `trackScreen()` and `trackEvent()` — fire-and-forget, safe to call before init completes.
- Persistent device IDs via Keychain (iOS/macOS) and EncryptedSharedPreferences (Android).
- Platform-specific User-Agent for accurate OS detection in Umami.
- Multi-platform support: Android, iOS, macOS, Windows.
