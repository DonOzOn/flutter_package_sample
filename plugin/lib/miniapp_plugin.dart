import 'miniapp_plugin_platform_interface.dart';

/// The main plugin class that provides access to native functionality
class MiniappPlugin {
  // Basic platform information
  Future<String?> getPlatformVersion() {
    return MiniappPluginPlatform.instance.getPlatformVersion();
  }

  Future<Map<String, dynamic>?> getDeviceInfo() {
    return MiniappPluginPlatform.instance.getDeviceInfo();
  }

  Future<bool?> isTablet() {
    return MiniappPluginPlatform.instance.isTablet();
  }

  // App information
  Future<Map<String, dynamic>?> getAppInfo() {
    return MiniappPluginPlatform.instance.getAppInfo();
  }

  // Native view interaction
  Future<bool> openNativeView(String viewType, {Map<String, dynamic>? params}) {
    return MiniappPluginPlatform.instance.openNativeView(viewType, params);
  }

  // Generic native method calling
  Future<dynamic> callNativeMethod(String method,
      {Map<String, dynamic>? params}) {
    return MiniappPluginPlatform.instance.callNativeMethod(method, params);
  }

  // Permission management
  Future<bool> hasPermission(String permission) {
    return MiniappPluginPlatform.instance.hasPermission(permission);
  }

  Future<bool> requestPermission(String permission) {
    return MiniappPluginPlatform.instance.requestPermission(permission);
  }

  // Network information
  Future<String?> getNetworkInfo() {
    return MiniappPluginPlatform.instance.getNetworkInfo();
  }

  // UI interactions
  Future<bool> showNativeDialog(String title, String message,
      {List<String>? buttons}) {
    return MiniappPluginPlatform.instance
        .showNativeDialog(title, message, buttons: buttons);
  }

  // Hardware features
  Future<bool> vibrate({int duration = 200}) {
    return MiniappPluginPlatform.instance.vibrate(duration: duration);
  }

  Future<Map<String, dynamic>?> getBatteryInfo() {
    return MiniappPluginPlatform.instance.getBatteryInfo();
  }

  // Static convenience methods for common use cases
  static Future<String?> get platformVersion {
    return MiniappPluginPlatform.instance.getPlatformVersion();
  }

  static Future<Map<String, dynamic>?> get deviceInfo {
    return MiniappPluginPlatform.instance.getDeviceInfo();
  }

  static Future<bool?> get isTabletDevice {
    return MiniappPluginPlatform.instance.isTablet();
  }

  static Future<Map<String, dynamic>?> get appInfo {
    return MiniappPluginPlatform.instance.getAppInfo();
  }

  static Future<String?> get networkInfo {
    return MiniappPluginPlatform.instance.getNetworkInfo();
  }

  static Future<Map<String, dynamic>?> get batteryInfo {
    return MiniappPluginPlatform.instance.getBatteryInfo();
  }
}
