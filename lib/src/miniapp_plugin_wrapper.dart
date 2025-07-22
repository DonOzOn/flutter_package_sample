import 'package:flutter/material.dart';
import 'package:miniapp_plugin/miniapp_plugin.dart' as plugin;
import 'miniapp_plugin_view.dart';

/// MiniApp SDK - Main SDK interface for host applications
///
/// This class provides a high-level, easy-to-use interface for integrating
/// MiniApp functionality into host applications with native SDK communication.
class MiniappSDK {
  static plugin.MiniappPlugin? _instance;
  static bool _initialized = false;

  /// Initialize the MiniApp SDK
  ///
  /// This should be called once during app startup before using any other SDK methods.
  ///
  /// [config] - Optional configuration parameters
  static Future<bool> initialize({Map<String, dynamic>? config}) async {
    if (_initialized) return true;

    try {
      _instance = plugin.MiniappPlugin();

      // Test connection to native platform
      final version = await _instance!.getPlatformVersion();
      if (version != null && version.isNotEmpty) {
        _initialized = true;
        debugPrint('MiniappSDK initialized successfully on $version');
        return true;
      }
    } catch (e) {
      debugPrint('MiniappSDK initialization failed: $e');
    }

    return false;
  }

  /// Check if the SDK is initialized and ready to use
  static bool get isInitialized => _initialized;

  /// Get the plugin instance (for advanced usage)
  static plugin.MiniappPlugin? get instance => _instance;
}

/// Enhanced wrapper for MiniappPlugin with comprehensive native functionality
///
/// This wrapper provides easy access to all native methods with proper error handling
/// and developer-friendly APIs.
class MiniappPluginWrapper {
  static plugin.MiniappPlugin? _instance;

  /// Get the plugin instance, create if needed
  static plugin.MiniappPlugin get _plugin {
    _instance ??= plugin.MiniappPlugin();
    return _instance!;
  }

  // ========== PLATFORM INFORMATION ==========

  /// Get platform version information
  /// Returns something like "iOS 17.0" or "Android 13"
  static Future<String?> getPlatformVersion() async {
    try {
      return await _plugin.getPlatformVersion();
    } catch (e) {
      debugPrint('Error getting platform version: $e');
      return null;
    }
  }

  /// Get comprehensive device information
  ///
  /// Returns a map containing:
  /// - platform: "iOS" or "Android"
  /// - version: OS version
  /// - model: Device model
  /// - manufacturer: Device manufacturer (Android only)
  /// - And more platform-specific details
  static Future<Map<String, dynamic>?> getDeviceInfo() async {
    try {
      return await _plugin.getDeviceInfo();
    } catch (e) {
      debugPrint('Error getting device info: $e');
      return null;
    }
  }

  /// Check if the current device is a tablet
  static Future<bool> isTablet() async {
    try {
      final result = await _plugin.isTablet();
      return result ?? false;
    } catch (e) {
      debugPrint('Error checking tablet: $e');
      return false;
    }
  }

  /// Get application information
  ///
  /// Returns information about the current app:
  /// - packageName/bundleIdentifier
  /// - version information
  /// - app name
  /// - installation details
  static Future<Map<String, dynamic>?> getAppInfo() async {
    try {
      return await _plugin.getAppInfo();
    } catch (e) {
      debugPrint('Error getting app info: $e');
      return null;
    }
  }

  // ========== NATIVE VIEW INTEGRATION ==========

  /// Open a native view or screen
  ///
  /// [viewType] can be:
  /// - "settings": Opens app settings
  /// - "gallery": Opens photo gallery (Android)
  /// - "photos": Opens Photos app (iOS)
  ///
  /// [params] - Optional parameters to pass to the native view
  static Future<bool> openNativeView(String viewType,
      {Map<String, dynamic>? params}) async {
    try {
      return await _plugin.openNativeView(viewType, params: params);
    } catch (e) {
      debugPrint('Error opening native view: $e');
      return false;
    }
  }

  /// Navigate to miniapp using the plugin view
  ///
  /// This is a convenience method that opens the miniapp as a new screen
  static Future<bool> navigateToMiniapp(
    BuildContext context, {
    bool fullscreenDialog = false,
  }) async {
    try {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const MiniappPluginView(),
          fullscreenDialog: fullscreenDialog,
        ),
      );
      return true;
    } catch (e) {
      debugPrint('Error navigating to miniapp: $e');
      return false;
    }
  }

  // ========== GENERIC NATIVE CALLS ==========

  /// Call any native method with parameters
  ///
  /// This is a generic method for calling platform-specific functionality:
  ///
  /// Available methods:
  /// - "getCurrentTime": Get current timestamp
  /// - "getSystemProperty": Get system property (Android)
  /// - "getAvailableMemory": Get memory information (Android)
  /// - "getSystemInfo": Get system information (iOS)
  /// - "getMemoryInfo": Get memory information (iOS)
  static Future<dynamic> callNativeMethod(String method,
      {Map<String, dynamic>? params}) async {
    try {
      return await _plugin.callNativeMethod(method, params: params);
    } catch (e) {
      debugPrint('Error calling native method $method: $e');
      return null;
    }
  }

  // ========== PERMISSIONS ==========

  /// Check if a permission is granted
  ///
  /// Common permissions:
  /// - "camera": Camera access
  /// - "photos": Photo library access
  /// - "location": Location access
  static Future<bool> hasPermission(String permission) async {
    try {
      return await _plugin.hasPermission(permission);
    } catch (e) {
      debugPrint('Error checking permission $permission: $e');
      return false;
    }
  }

  /// Request a permission from the user
  ///
  /// Note: This may show a system permission dialog
  static Future<bool> requestPermission(String permission) async {
    try {
      return await _plugin.requestPermission(permission);
    } catch (e) {
      debugPrint('Error requesting permission $permission: $e');
      return false;
    }
  }

  // ========== NETWORK & CONNECTIVITY ==========

  /// Get current network connection information
  ///
  /// Returns network type like "WiFi", "Cellular", or "Not Connected"
  static Future<String?> getNetworkInfo() async {
    try {
      return await _plugin.getNetworkInfo();
    } catch (e) {
      debugPrint('Error getting network info: $e');
      return null;
    }
  }

  /// Check if device has network connectivity
  static Future<bool> isConnected() async {
    final networkInfo = await getNetworkInfo();
    return networkInfo != null && networkInfo != "Not Connected";
  }

  // ========== UI INTERACTIONS ==========

  /// Show a native system dialog
  ///
  /// [title] - Dialog title
  /// [message] - Dialog message
  /// [buttons] - List of button titles (max 3)
  static Future<bool> showNativeDialog(
    String title,
    String message, {
    List<String>? buttons,
  }) async {
    try {
      return await _plugin.showNativeDialog(title, message, buttons: buttons);
    } catch (e) {
      debugPrint('Error showing native dialog: $e');
      return false;
    }
  }

  /// Show a simple alert dialog
  static Future<bool> showAlert(String title, String message) async {
    return showNativeDialog(title, message, buttons: ['OK']);
  }

  /// Show a confirmation dialog
  static Future<bool> showConfirmation(String title, String message) async {
    return showNativeDialog(title, message, buttons: ['Cancel', 'OK']);
  }

  // ========== HARDWARE FEATURES ==========

  /// Trigger device vibration
  ///
  /// [duration] - Vibration duration in milliseconds (default: 200)
  static Future<bool> vibrate({int duration = 200}) async {
    try {
      return await _plugin.vibrate(duration: duration);
    } catch (e) {
      debugPrint('Error vibrating: $e');
      return false;
    }
  }

  /// Get battery information
  ///
  /// Returns battery level, charging status, etc.
  static Future<Map<String, dynamic>?> getBatteryInfo() async {
    try {
      return await _plugin.getBatteryInfo();
    } catch (e) {
      debugPrint('Error getting battery info: $e');
      return null;
    }
  }

  /// Get current battery level as percentage (0-100)
  static Future<int> getBatteryLevel() async {
    final batteryInfo = await getBatteryInfo();
    if (batteryInfo != null && batteryInfo.containsKey('level')) {
      return batteryInfo['level'] ?? 0;
    }
    return 0;
  }

  /// Check if device is currently charging
  static Future<bool> isCharging() async {
    final batteryInfo = await getBatteryInfo();
    if (batteryInfo != null && batteryInfo.containsKey('isCharging')) {
      return batteryInfo['isCharging'] ?? false;
    }
    return false;
  }

  // ========== UTILITY METHODS ==========

  /// Check if miniapp functionality is supported on this platform
  static Future<bool> isSupported() async {
    try {
      final version = await getPlatformVersion();
      return version != null && version.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get comprehensive system information
  ///
  /// Combines device info, app info, network info, and battery info
  static Future<Map<String, dynamic>> getSystemInfo() async {
    final results = await Future.wait([
      getDeviceInfo(),
      getAppInfo(),
      getNetworkInfo(),
      getBatteryInfo(),
    ]);

    return {
      'device': results[0] ?? {},
      'app': results[1] ?? {},
      'network': results[2] ?? 'Unknown',
      'battery': results[3] ?? {},
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
  }

  /// Test all native methods (for debugging)
  static Future<Map<String, dynamic>> runDiagnostics() async {
    final diagnostics = <String, dynamic>{};

    try {
      diagnostics['platform_version'] = await getPlatformVersion();
    } catch (e) {
      diagnostics['platform_version_error'] = e.toString();
    }

    try {
      diagnostics['device_info'] = await getDeviceInfo();
    } catch (e) {
      diagnostics['device_info_error'] = e.toString();
    }

    try {
      diagnostics['is_tablet'] = await isTablet();
    } catch (e) {
      diagnostics['is_tablet_error'] = e.toString();
    }

    try {
      diagnostics['app_info'] = await getAppInfo();
    } catch (e) {
      diagnostics['app_info_error'] = e.toString();
    }

    try {
      diagnostics['network_info'] = await getNetworkInfo();
    } catch (e) {
      diagnostics['network_info_error'] = e.toString();
    }

    try {
      diagnostics['battery_info'] = await getBatteryInfo();
    } catch (e) {
      diagnostics['battery_info_error'] = e.toString();
    }

    diagnostics['is_supported'] = await isSupported();
    diagnostics['test_timestamp'] = DateTime.now().toIso8601String();

    return diagnostics;
  }

  /// Get direct access to plugin instance for advanced usage
  static plugin.MiniappPlugin get instance => _plugin;
}

/// Exception class for MiniApp-related errors
class MiniappException implements Exception {
  final String message;
  final String code;
  final dynamic details;

  const MiniappException(this.message, this.code, [this.details]);

  @override
  String toString() => 'MiniappException($code): $message';
}
