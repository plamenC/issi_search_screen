import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceService {
  static final DeviceService _instance = DeviceService._internal();
  factory DeviceService() => _instance;
  DeviceService._internal();

  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  String? _cachedDeviceId;

  /// Get unique device identifier
  /// This will be used to track which cases are followed on this device
  Future<String> getDeviceId() async {
    if (_cachedDeviceId != null) {
      return _cachedDeviceId!;
    }

    try {
      if (kIsWeb) {
        final webInfo = await _deviceInfo.webBrowserInfo;
        _cachedDeviceId = 'web_${webInfo.userAgent?.hashCode ?? 'unknown'}';
      } else if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        // Use a combination of device identifiers for uniqueness
        _cachedDeviceId =
            'android_${androidInfo.id}_${androidInfo.model}_${androidInfo.fingerprint}';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        // iOS doesn't provide device ID directly, use identifierForVendor
        _cachedDeviceId = 'ios_${iosInfo.identifierForVendor ?? 'unknown'}';
      } else if (Platform.isLinux) {
        final linuxInfo = await _deviceInfo.linuxInfo;
        _cachedDeviceId = 'linux_${linuxInfo.machineId ?? 'unknown'}';
      } else if (Platform.isWindows) {
        final windowsInfo = await _deviceInfo.windowsInfo;
        _cachedDeviceId = 'windows_${windowsInfo.deviceId}';
      } else if (Platform.isMacOS) {
        final macInfo = await _deviceInfo.macOsInfo;
        _cachedDeviceId = 'macos_${macInfo.systemGUID ?? 'unknown'}';
      } else {
        _cachedDeviceId = 'unknown_${DateTime.now().millisecondsSinceEpoch}';
      }

      debugPrint('🔧 Device ID generated: $_cachedDeviceId');
      return _cachedDeviceId!;
    } catch (e) {
      debugPrint('❌ Error getting device ID: $e');
      // Fallback to a timestamp-based ID
      _cachedDeviceId = 'fallback_${DateTime.now().millisecondsSinceEpoch}';
      return _cachedDeviceId!;
    }
  }

  /// Clear cached device ID (useful for testing)
  void clearCache() {
    _cachedDeviceId = null;
  }
}
