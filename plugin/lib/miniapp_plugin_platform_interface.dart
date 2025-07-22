import 'package:flutter/material.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'miniapp_plugin_method_channel.dart';

abstract class MiniappPluginPlatform extends PlatformInterface {
  /// Constructs a MiniappPluginPlatform.
  MiniappPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static MiniappPluginPlatform _instance = MethodChannelMiniappPlugin();

  /// The default instance of [MiniappPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelMiniappPlugin].
  static MiniappPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MiniappPluginPlatform] when
  /// they register themselves.
  static set instance(MiniappPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  // Basic platform methods
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Map<String, dynamic>?> getDeviceInfo() {
    throw UnimplementedError('getDeviceInfo() has not been implemented.');
  }

  Future<bool?> isTablet() {
    throw UnimplementedError('isTablet() has not been implemented.');
  }

  // App information methods
  Future<Map<String, dynamic>?> getAppInfo() {
    throw UnimplementedError('getAppInfo() has not been implemented.');
  }

  // Native view methods
  Future<bool> openNativeView(String viewType, Map<String, dynamic>? params) {
    throw UnimplementedError('openNativeView() has not been implemented.');
  }

  void openGameView(BuildContext context) {
    throw UnimplementedError('openGameView() has not been implemented.');
  }

  // Generic native method calling
  Future<dynamic> callNativeMethod(String method, Map<String, dynamic>? params) {
    throw UnimplementedError('callNativeMethod() has not been implemented.');
  }

  // Permission methods
  Future<bool> hasPermission(String permission) {
    throw UnimplementedError('hasPermission() has not been implemented.');
  }

  Future<bool> requestPermission(String permission) {
    throw UnimplementedError('requestPermission() has not been implemented.');
  }

  // Network methods
  Future<String?> getNetworkInfo() {
    throw UnimplementedError('getNetworkInfo() has not been implemented.');
  }

  // UI methods
  Future<bool> showNativeDialog(String title, String message, {List<String>? buttons}) {
    throw UnimplementedError('showNativeDialog() has not been implemented.');
  }

  // Hardware methods
  Future<bool> vibrate({int duration = 200}) {
    throw UnimplementedError('vibrate() has not been implemented.');
  }

  Future<Map<String, dynamic>?> getBatteryInfo() {
    throw UnimplementedError('getBatteryInfo() has not been implemented.');
  }
}