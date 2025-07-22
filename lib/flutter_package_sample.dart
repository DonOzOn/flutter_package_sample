/// A Flutter package with miniapp plugin functionality including game features.
///
/// This package provides a MiniappPluginView widget that contains a complete
/// Tetris game implementation, suitable for miniapp integration.
///
/// ## Usage
/// 
/// ### SDK Integration (Recommended)
/// ```dart
/// import 'package:flutter_package_sample/flutter_package_sample.dart';
/// 
/// // Initialize SDK once during app startup
/// await MiniappSDK.initialize();
/// 
/// // Launch miniapp anywhere in your app
/// MiniappSDK.launchMiniapp(context);
/// ```
/// 
/// ### Advanced Usage with Wrapper
/// ```dart
/// // Check platform support first
/// if (await MiniappPluginWrapper.isSupported()) {
///   // Get device info
///   final deviceInfo = await MiniappPluginWrapper.getDeviceInfo();
///   print('Device: ${deviceInfo}');
///   
///   // Open miniapp
///   MiniappPluginWrapper.navigateToMiniapp(context);
/// }
/// ```
/// 
/// ### Native Method Calls
/// ```dart
/// // Get platform information
/// final version = await MiniappPluginWrapper.getPlatformVersion();
/// final isTablet = await MiniappPluginWrapper.isTablet();
/// 
/// // Hardware features
/// await MiniappPluginWrapper.vibrate(duration: 500);
/// final batteryInfo = await MiniappPluginWrapper.getBatteryInfo();
/// 
/// // UI interactions
/// await MiniappPluginWrapper.showAlert('Title', 'Message');
/// 
/// // Open native views
/// await MiniappPluginWrapper.openNativeView('settings');
/// ```
library flutter_package_sample;

// ========== MAIN SDK EXPORTS ==========

/// Export the main SDK interface for host apps (RECOMMENDED)
export 'src/miniapp_plugin_wrapper.dart' show MiniappSDK, MiniappPluginWrapper, MiniappException;

/// Export the main MiniappPluginView widget
export 'src/miniapp_plugin_view.dart';

// ========== GAME COMPONENTS EXPORTS ==========

/// Export game components for advanced usage (from local src)
export 'src/gamer/gamer.dart';
export 'src/gamer/block.dart'; 
export 'src/gamer/keyboard.dart';

/// Export panel components (from local src)
export 'src/panel/controller.dart';
export 'src/panel/page_portrait.dart';
export 'src/panel/screen.dart';
export 'src/panel/status_panel.dart';
export 'src/panel/player_panel.dart';

/// Export material components (from local src)
export 'src/material/material.dart';
export 'src/material/images.dart';
export 'src/material/briks.dart';

/// Export generated localization files (from local src)
export 'src/generated/l10n.dart';

// ========== CONVENIENCE CLASSES ==========

/// A Calculator for demonstration purposes.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;

  /// Multiply two numbers
  int multiply(int a, int b) => a * b;

  /// Calculate percentage
  double percentage(double value, double total) {
    if (total == 0) return 0;
    return (value / total) * 100;
  }
}