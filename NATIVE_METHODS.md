# Enhanced Native Methods Documentation

## Overview

The Flutter Package Sample now includes comprehensive native method integration with both Android and iOS platforms. This document describes all available native methods and how to use them effectively.

## 🚀 Quick Start

### 1. SDK Initialization (Recommended Approach)

```dart
import 'package:flutter_package_sample/flutter_package_sample.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the SDK
  final initialized = await MiniappSDK.initialize();
  if (initialized) {
    print('MiniApp SDK ready to use!');
  }
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () => MiniappSDK.launchMiniapp(context),
            child: Text('Launch MiniApp'),
          ),
        ),
      ),
    );
  }
}
```

### 2. Advanced Wrapper Usage

```dart
import 'package:flutter_package_sample/flutter_package_sample.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    super.initState();
    _checkSupport();
  }

  Future<void> _checkSupport() async {
    final isSupported = await MiniappPluginWrapper.isSupported();
    if (isSupported) {
      print('MiniApp functionality is supported!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => MiniappPluginWrapper.navigateToMiniapp(context),
      child: Text('Open MiniApp'),
    );
  }
}
```

## 📱 Platform Information Methods

### Get Platform Version
```dart
final version = await MiniappPluginWrapper.getPlatformVersion();
print('Platform: $version'); // e.g., "iOS 17.0" or "Android 13"
```

### Get Device Information
```dart
final deviceInfo = await MiniappPluginWrapper.getDeviceInfo();
print('Device: ${deviceInfo}');

// Example output:
// {
//   "platform": "iOS",
//   "version": "17.0",
//   "model": "iPhone 14",
//   "name": "John's iPhone",
//   "system_name": "iOS"
// }
```

### Check if Device is Tablet
```dart
final isTablet = await MiniappPluginWrapper.isTablet();
if (isTablet) {
  print('Running on tablet');
} else {
  print('Running on phone');
}
```

### Get App Information
```dart
final appInfo = await MiniappPluginWrapper.getAppInfo();
print('App: ${appInfo}');

// Example output:
// {
//   "packageName": "com.example.myapp",
//   "versionName": "1.0.0",
//   "appName": "My App"
// }
```

## 🔧 Native View Integration

### Open Native Views
```dart
// Open app settings
await MiniappPluginWrapper.openNativeView('settings');

// Open photo gallery (Android) or Photos app (iOS)
await MiniappPluginWrapper.openNativeView('gallery'); // Android
await MiniappPluginWrapper.openNativeView('photos');  // iOS

// With parameters
await MiniappPluginWrapper.openNativeView('custom', params: {
  'key1': 'value1',
  'key2': 'value2',
});
```

## 🛠 Generic Native Method Calls

### Call Any Native Method
```dart
// Get current timestamp
final timestamp = await MiniappPluginWrapper.callNativeMethod('getCurrentTime');
print('Current time: $timestamp');

// Get system property (Android)
final property = await MiniappPluginWrapper.callNativeMethod('getSystemProperty', params: {
  'key': 'java.version'
});

// Get memory information
final memory = await MiniappPluginWrapper.callNativeMethod('getAvailableMemory');
print('Memory info: $memory');
```

### Available Generic Methods

**Android:**
- `getCurrentTime` - Get current timestamp
- `getSystemProperty` - Get system property by key
- `getAvailableMemory` - Get memory information

**iOS:**
- `getCurrentTime` - Get current timestamp  
- `getSystemInfo` - Get system information
- `getMemoryInfo` - Get memory statistics

## 🔐 Permission Management

### Check Permissions
```dart
final hasCamera = await MiniappPluginWrapper.hasPermission('camera');
final hasPhotos = await MiniappPluginWrapper.hasPermission('photos');
final hasLocation = await MiniappPluginWrapper.hasPermission('location');

if (hasCamera) {
  print('Camera permission granted');
}
```

### Request Permissions
```dart
if (!await MiniappPluginWrapper.hasPermission('camera')) {
  final granted = await MiniappPluginWrapper.requestPermission('camera');
  if (granted) {
    print('Camera permission granted');
  } else {
    print('Camera permission denied');
  }
}
```

## 🌐 Network & Connectivity

### Get Network Information
```dart
final networkInfo = await MiniappPluginWrapper.getNetworkInfo();
print('Network: $networkInfo'); // "WiFi", "Cellular", or "Not Connected"

// Check if connected
final isConnected = await MiniappPluginWrapper.isConnected();
if (isConnected) {
  print('Device has network connection');
}
```

## 🎨 UI Interactions

### Show Native Dialogs
```dart
// Simple alert
await MiniappPluginWrapper.showAlert('Title', 'Message');

// Confirmation dialog
await MiniappPluginWrapper.showConfirmation('Confirm', 'Are you sure?');

// Custom dialog with multiple buttons
await MiniappPluginWrapper.showNativeDialog(
  'Choose Option',
  'Select an option below:',
  buttons: ['Cancel', 'OK', 'Maybe'],
);
```

## 📳 Hardware Features

### Vibration
```dart
// Short vibration (200ms default)
await MiniappPluginWrapper.vibrate();

// Custom duration
await MiniappPluginWrapper.vibrate(duration: 500);

// Check if vibration worked
final success = await MiniappPluginWrapper.vibrate(duration: 300);
if (success) {
  print('Vibration triggered successfully');
}
```

### Battery Information
```dart
// Get full battery info
final batteryInfo = await MiniappPluginWrapper.getBatteryInfo();
print('Battery: ${batteryInfo}');

// Get just the battery level (0-100)
final level = await MiniappPluginWrapper.getBatteryLevel();
print('Battery level: $level%');

// Check if charging
final isCharging = await MiniappPluginWrapper.isCharging();
if (isCharging) {
  print('Device is charging');
}
```

## 🔍 Utility & Diagnostics

### Check Platform Support
```dart
final isSupported = await MiniappPluginWrapper.isSupported();
if (isSupported) {
  print('All native methods are available');
} else {
  print('Some native methods may not work');
}
```

### Get Comprehensive System Info
```dart
final systemInfo = await MiniappPluginWrapper.getSystemInfo();
print('Complete system info: ${systemInfo}');

// Returns:
// {
//   "device": { /* device info */ },
//   "app": { /* app info */ },
//   "network": "WiFi",
//   "battery": { /* battery info */ },
//   "timestamp": 1234567890
// }
```

### Run Full Diagnostics
```dart
final diagnostics = await MiniappPluginWrapper.runDiagnostics();
print('Diagnostics: ${diagnostics}');

// This tests all native methods and returns results
// Useful for debugging and ensuring all methods work properly
```

## 🎮 MiniApp Integration Examples

### Basic Integration
```dart
class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Game'),
        actions: [
          IconButton(
            icon: Icon(Icons.games),
            onPressed: () => MiniappSDK.launchMiniapp(context),
          ),
        ],
      ),
      body: YourGameContent(),
    );
  }
}
```

### Conditional Features Based on Device
```dart
class AdaptiveGameScreen extends StatefulWidget {
  @override
  _AdaptiveGameScreenState createState() => _AdaptiveGameScreenState();
}

class _AdaptiveGameScreenState extends State<AdaptiveGameScreen> {
  bool _isTablet = false;
  Map<String, dynamic>? _deviceInfo;

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
  }

  Future<void> _loadDeviceInfo() async {
    final isTablet = await MiniappPluginWrapper.isTablet();
    final deviceInfo = await MiniappPluginWrapper.getDeviceInfo();
    
    setState(() {
      _isTablet = isTablet;
      _deviceInfo = deviceInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isTablet ? TabletGameLayout() : PhoneGameLayout(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Vibrate on game action (if supported)
          await MiniappPluginWrapper.vibrate(duration: 100);
          
          // Launch miniapp
          MiniappSDK.launchMiniapp(context);
        },
        child: Icon(Icons.games),
      ),
    );
  }
}
```

### Error Handling Best Practices
```dart
class RobustMiniappIntegration {
  static Future<void> launchMiniappSafely(BuildContext context) async {
    try {
      // Check if SDK is initialized
      if (!MiniappSDK.isInitialized) {
        final initialized = await MiniappSDK.initialize();
        if (!initialized) {
          throw MiniappException('SDK initialization failed', 'INIT_ERROR');
        }
      }

      // Check platform support
      final isSupported = await MiniappPluginWrapper.isSupported();
      if (!isSupported) {
        throw MiniappException('Platform not supported', 'PLATFORM_ERROR');
      }

      // Launch miniapp
      final success = await MiniappSDK.launchMiniapp(context);
      if (!success) {
        throw MiniappException('Failed to launch miniapp', 'LAUNCH_ERROR');
      }

    } on MiniappException catch (e) {
      // Handle MiniApp specific errors
      print('MiniApp Error: ${e.code} - ${e.message}');
      
      // Show user-friendly message
      await MiniappPluginWrapper.showAlert(
        'Error',
        'Unable to launch miniapp: ${e.message}',
      );
      
    } catch (e) {
      // Handle unexpected errors
      print('Unexpected error: $e');
      
      await MiniappPluginWrapper.showAlert(
        'Error',
        'An unexpected error occurred. Please try again.',
      );
    }
  }
}
```

## 📋 Method Summary

| Category | Method | Description |
|----------|--------|-------------|
| **Platform** | `getPlatformVersion()` | Get OS version |
| **Platform** | `getDeviceInfo()` | Get device details |
| **Platform** | `isTablet()` | Check if tablet |
| **Platform** | `getAppInfo()` | Get app information |
| **Navigation** | `openNativeView()` | Open native screens |
| **Navigation** | `launchMiniapp()` | Launch miniapp (SDK) |
| **Navigation** | `navigateToMiniapp()` | Open miniapp (Wrapper) |
| **Generic** | `callNativeMethod()` | Call any native method |
| **Permissions** | `hasPermission()` | Check permission |
| **Permissions** | `requestPermission()` | Request permission |
| **Network** | `getNetworkInfo()` | Get network status |
| **Network** | `isConnected()` | Check connectivity |
| **UI** | `showNativeDialog()` | Show native dialog |
| **UI** | `showAlert()` | Simple alert |
| **UI** | `showConfirmation()` | Confirmation dialog |
| **Hardware** | `vibrate()` | Trigger vibration |
| **Hardware** | `getBatteryInfo()` | Get battery data |
| **Hardware** | `getBatteryLevel()` | Get battery percentage |
| **Hardware** | `isCharging()` | Check charging status |
| **Utility** | `isSupported()` | Check platform support |
| **Utility** | `getSystemInfo()` | Comprehensive system data |
| **Utility** | `runDiagnostics()` | Test all methods |

## 🛡️ Error Handling

All methods include proper error handling and return sensible defaults on failure:

- Methods returning `bool` default to `false` on error
- Methods returning `String?` return `null` on error  
- Methods returning `Map?` return `null` on error
- All errors are logged to debug console

For production apps, always check return values:

```dart
final deviceInfo = await MiniappPluginWrapper.getDeviceInfo();
if (deviceInfo != null) {
  // Use device info
  print('Platform: ${deviceInfo['platform']}');
} else {
  // Handle error case
  print('Unable to get device information');
}
```

## 🔧 Troubleshooting

**Common Issues:**

1. **Methods return null:** Ensure device has proper permissions and native implementation is available
2. **SDK not initialized:** Call `MiniappSDK.initialize()` before using SDK methods
3. **Platform not supported:** Check `isSupported()` before calling native methods
4. **Permission denied:** Use `requestPermission()` before accessing protected features

**Debug Mode:**

Enable debug logging to see detailed method call information:

```dart
// Run diagnostics to test all methods
final results = await MiniappPluginWrapper.runDiagnostics();
print('Diagnostics: ${results}');
```

This comprehensive native integration makes your Flutter package a powerful SDK for host applications with full native platform communication capabilities.