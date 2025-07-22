# Integration Guide for Flutter Package Sample

## Overview

This package provides a complete miniapp solution with native SDK integration. It includes a Tetris game as a demonstration and provides proper Flutter plugin architecture for host app integration.

## Package Architecture

```
flutter_package_sample/
├── lib/
│   ├── flutter_package_sample.dart     # Main exports
│   └── src/
│       ├── miniapp_plugin_wrapper.dart  # SDK & Wrapper classes
│       ├── miniapp_plugin_view.dart     # Main game widget
│       ├── gamer/                       # Game engine
│       ├── panel/                       # UI components
│       ├── material/                    # Visual assets
│       └── generated/                   # Localization
├── plugin/                              # Native plugin
│   ├── android/                         # Android implementation
│   ├── ios/                            # iOS implementation
│   └── lib/                            # Flutter interface
├── example/                            # Integration examples
└── assets/                            # Game assets
```

## Integration Methods

### Method 1: SDK Interface (Recommended)

**Best for:** Production apps requiring proper initialization and error handling.

```dart
import 'package:flutter_package_sample/flutter_package_sample.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize SDK
  final initialized = await MiniappSDK.initialize();
  if (!initialized) {
    print('Miniapp SDK initialization failed');
  }
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HostScreen(),
    );
  }
}

class HostScreen extends StatelessWidget {
  void _launchMiniapp(BuildContext context) {
    // Launch miniapp with proper error handling
    MiniappSDK.launchMiniapp(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Host App')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _launchMiniapp(context),
          child: Text('Launch Miniapp'),
        ),
      ),
    );
  }
}
```

### Method 2: Advanced Navigation

**Best for:** Apps needing custom navigation behavior.

```dart
// Custom navigation with options
MiniappPluginWrapper.navigateToMiniapp(
  context,
  title: 'Custom Title',
  fullscreenDialog: true,
);

// Check support before launching
if (await MiniappPluginWrapper.isSupported()) {
  MiniappPluginWrapper.openMiniapp(context);
} else {
  // Handle unsupported platform
  showDialog(context: context, builder: (context) => 
    AlertDialog(content: Text('Miniapp not supported'))
  );
}
```

### Method 3: Direct Widget Integration

**Best for:** Embedding miniapp directly in existing screens.

```dart
import 'package:flutter_package_sample/flutter_package_sample.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MiniappPluginView(), // Direct widget embedding
    );
  }
}
```

## Platform Requirements

### Android
- **Minimum SDK:** 21 (Android 5.0)
- **Target SDK:** 34+
- **Permissions:** None required for basic functionality

### iOS  
- **Minimum Version:** iOS 12.0
- **Architecture:** arm64, x86_64 (simulator)
- **Permissions:** None required for basic functionality

## Host App Configuration

### pubspec.yaml
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  flutter_package_sample:
    path: ../flutter_package_sample  # Adjust path
```

### Android Configuration

**android/app/build.gradle:**
```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

### iOS Configuration

**ios/Runner/Info.plist:**
```xml
<key>MinimumOSVersion</key>
<string>12.0</string>
```

## Native SDK Methods

### Available Methods

```dart
// Platform information
String? version = await MiniappPluginWrapper.getPlatformVersion();

// Platform support check
bool supported = await MiniappPluginWrapper.isSupported();

// SDK information
Map<String, dynamic> info = await MiniappSDK.getPlatformInfo();

// Launch methods
MiniappSDK.launchMiniapp(context);
MiniappPluginWrapper.openMiniapp(context);
```

### Adding Custom Native Methods

**1. Update Platform Interface:**
```dart
// plugin/lib/miniapp_plugin_platform_interface.dart
abstract class MiniappPluginPlatform extends PlatformInterface {
  Future<String?> customNativeMethod(String param);
}
```

**2. Update Method Channel:**
```dart
// plugin/lib/miniapp_plugin_method_channel.dart
@override
Future<String?> customNativeMethod(String param) async {
  return await methodChannel.invokeMethod('customNativeMethod', {'param': param});
}
```

**3. Android Implementation:**
```java
// plugin/android/src/main/java/.../MiniappPlugin.java
@Override
public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
  if (call.method.equals("customNativeMethod")) {
    String param = call.argument("param");
    // Your native Android code here
    result.success("Android result: " + param);
  }
}
```

**4. iOS Implementation:**
```objc
// plugin/ios/Classes/MiniappPlugin.m
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"customNativeMethod" isEqualToString:call.method]) {
    NSString *param = call.arguments[@"param"];
    // Your native iOS code here
    result([NSString stringWithFormat:@"iOS result: %@", param]);
  }
}
```

## Error Handling

### Initialization Errors
```dart
try {
  final initialized = await MiniappSDK.initialize();
  if (!initialized) {
    // Handle initialization failure
    showError('SDK initialization failed');
  }
} catch (e) {
  // Handle exception
  print('SDK error: $e');
}
```

### Platform Compatibility
```dart
// Check platform support
if (await MiniappPluginWrapper.isSupported()) {
  // Safe to launch miniapp
  MiniappSDK.launchMiniapp(context);
} else {
  // Show platform not supported message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Miniapp not supported on this platform')),
  );
}
```

## Troubleshooting

### Common Issues

1. **"Package not found" error:**
   - Ensure correct path in pubspec.yaml
   - Run `flutter clean && flutter pub get`

2. **Native methods not working:**
   - Check platform implementation
   - Verify method channel names match
   - Test on physical device

3. **Asset loading issues:**
   - Verify asset paths in pubspec.yaml
   - Check asset files exist in correct locations
   - Clear asset cache with `flutter clean`

4. **Platform-specific crashes:**
   - Check minimum OS versions
   - Verify native permissions
   - Test platform-specific implementations

### Debug Tips

```dart
// Enable debug logging
debugPrint('SDK Version: ${MiniappSDK.version}');

// Check platform info
final info = await MiniappSDK.getPlatformInfo();
print('Platform info: $info');

// Verify initialization
final initialized = await MiniappSDK.initialize();
print('SDK initialized: $initialized');
```

## Performance Considerations

- **Cold start:** First launch may take longer due to asset loading
- **Memory usage:** Game holds assets in memory during gameplay
- **Battery impact:** Game uses moderate CPU during active play
- **Network:** No network requirements for basic functionality

## Security Notes

- **Assets:** All game assets are bundled with the app
- **Permissions:** No special permissions required
- **Data:** No user data is collected or transmitted
- **Native access:** Limited to platform version information only

## Example Apps

See `/example` folder for complete integration examples showing:
- Basic SDK integration
- Advanced navigation patterns  
- Error handling best practices
- Platform compatibility checking
