# Miniapp Plugin

A Flutter plugin for miniapp functionality with native platform integration.

## Features

- Cross-platform support (iOS and Android)
- Native platform integration
- Modern UI components
- Counter functionality
- Task management
- Platform version detection

## Getting started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  miniapp_plugin:
    path: ../miniapp_plugin
```

## Usage

```dart
import 'package:miniapp_plugin/miniapp_plugin_view.dart';

// Navigate to miniapp
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const MiniappPluginView(),
  ),
);
```

## Platform Integration

### iOS
The plugin integrates with iOS using Objective-C and provides access to:
- Device information
- Platform version

### Android
The plugin integrates with Android using Java and provides access to:
- Device information  
- Platform version

## Architecture

This plugin follows the federated plugin architecture:
- `miniapp_plugin`: The main plugin package
- `miniapp_plugin_platform_interface`: Platform interface
- `miniapp_plugin_method_channel`: Method channel implementation

## Development

To run the example:

```bash
cd example
flutter run
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first.

## License

[MIT](https://choosealicense.com/licenses/mit/)
