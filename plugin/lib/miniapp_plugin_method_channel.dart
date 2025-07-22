import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'miniapp_plugin_platform_interface.dart';

/// An implementation of [MiniappPluginPlatform] that uses method channels.
class MethodChannelMiniappPlugin extends MiniappPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('miniapp_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    try {
      final version =
          await methodChannel.invokeMethod<String>('getPlatformVersion');
      return version;
    } catch (e) {
      debugPrint('Error getting platform version: $e');
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>?> getDeviceInfo() async {
    try {
      final result = await methodChannel.invokeMethod('getDeviceInfo');
      return Map<String, dynamic>.from(result ?? {});
    } catch (e) {
      debugPrint('Error getting device info: $e');
      return null;
    }
  }

  @override
  Future<bool?> isTablet() async {
    try {
      final result = await methodChannel.invokeMethod<bool>('isTablet');
      return result;
    } catch (e) {
      debugPrint('Error checking tablet: $e');
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>?> getAppInfo() async {
    try {
      final result = await methodChannel.invokeMethod('getAppInfo');
      return Map<String, dynamic>.from(result ?? {});
    } catch (e) {
      debugPrint('Error getting app info: $e');
      return null;
    }
  }

  @override
  Future<bool> openNativeView(
      String viewType, Map<String, dynamic>? params) async {
    try {
      final result = await methodChannel.invokeMethod<bool>('openNativeView', {
        'viewType': viewType,
        'params': params ?? {},
      });
      return result ?? false;
    } catch (e) {
      debugPrint('Error opening native view: $e');
      return false;
    }
  }

  @override
  Future<dynamic> callNativeMethod(
      String method, Map<String, dynamic>? params) async {
    try {
      final result = await methodChannel.invokeMethod('callNativeMethod', {
        'method': method,
        'params': params ?? {},
      });
      return result;
    } catch (e) {
      debugPrint('Error calling native method: $e');
      return null;
    }
  }

  @override
  Future<bool> hasPermission(String permission) async {
    try {
      final result = await methodChannel.invokeMethod<bool>('hasPermission', {
        'permission': permission,
      });
      return result ?? false;
    } catch (e) {
      debugPrint('Error checking permission: $e');
      return false;
    }
  }

  @override
  Future<bool> requestPermission(String permission) async {
    try {
      final result =
          await methodChannel.invokeMethod<bool>('requestPermission', {
        'permission': permission,
      });
      return result ?? false;
    } catch (e) {
      debugPrint('Error requesting permission: $e');
      return false;
    }
  }

  @override
  Future<String?> getNetworkInfo() async {
    try {
      final result = await methodChannel.invokeMethod<String>('getNetworkInfo');
      return result;
    } catch (e) {
      debugPrint('Error getting network info: $e');
      return null;
    }
  }

  @override
  Future<bool> showNativeDialog(String title, String message,
      {List<String>? buttons}) async {
    try {
      final result =
          await methodChannel.invokeMethod<bool>('showNativeDialog', {
        'title': title,
        'message': message,
        'buttons': buttons ?? ['OK'],
      });
      return result ?? false;
    } catch (e) {
      debugPrint('Error showing native dialog: $e');
      return false;
    }
  }

  @override
  Future<bool> vibrate({int duration = 200}) async {
    try {
      final result = await methodChannel.invokeMethod<bool>('vibrate', {
        'duration': duration,
      });
      return result ?? false;
    } catch (e) {
      debugPrint('Error vibrating111323232: $e');
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>?> getBatteryInfo() async {
    try {
      final result = await methodChannel.invokeMethod('getBatteryInfo');
      return Map<String, dynamic>.from(result ?? {});
    } catch (e) {
      debugPrint('Error getting battery info: $e');
      return null;
    }
  }
}
