# Flutter Package Sample

A Flutter package with miniapp plugin functionality including a complete Tetris game implementation.

## Features

- **MiniappPluginView**: A complete Tetris game widget ready for integration
- **Game Engine**: Full Tetris game logic with different levels and scoring
- **Keyboard Controls**: Support for keyboard input (arrow keys, space, P for pause, R for reset)
- **Responsive UI**: Optimized for both portrait and landscape modes
- **Localization**: Support for English and Chinese
- **Customizable**: Easy to integrate and customize for different use cases

## Getting started

Add this package to your Flutter app's `pubspec.yaml`:

```yaml
dependencies:
  flutter_package_sample:
    path: ../flutter_package_sample  # or your package path
```

## Usage

### Basic Usage

Import the package and use the `MiniappPluginView` widget:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_package_sample/flutter_package_sample.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MiniappPluginView(),
      ),
    );
  }
}
```

### Navigation Usage

Use it with navigation to open the game as a separate screen:

```dart
import 'package:flutter_package_sample/flutter_package_sample.dart';

// Open the game
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const MiniappPluginView()),
);
```

### Advanced Usage

For more control, you can use individual components:

```dart
import 'package:flutter_package_sample/flutter_package_sample.dart';
import 'package:flutter/material.dart';

class CustomGameView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom Game')),
      body: Game(
        child: KeyboardController(
          child: PagePortrait(),
        ),
      ),
    );
  }
}
```

## Game Controls

- **Arrow Keys**: Move and rotate blocks
- **Space**: Drop block immediately  
- **P**: Pause/Resume game
- **R**: Reset game
- **S**: Sound toggle (currently disabled)

## Components

### Main Widget
- `MiniappPluginView`: The main game widget with app bar and full game functionality

### Game Engine
- `Game`: Core game logic and state management
- `Block`: Tetris block definitions and operations
- `GameStates`: Game state enumeration

### UI Components  
- `PagePortrait`: Portrait layout for the game
- `Screen`: Game screen displaying the play field
- `GameController`: Control buttons for mobile devices
- `KeyboardController`: Keyboard input handler

### Utilities
- `Calculator`: Simple calculator utility
- Localization support via generated l10n files

## Localization

The package supports:
- English (en)
- Chinese (zh_CN)

To add more languages, edit the `.arb` files in `/lib/l10n/` and regenerate with:

```bash
flutter packages pub run intl_utils:generate
```

## Requirements

- Flutter SDK: ^3.5.0
- Dart: ^3.5.0

## Dependencies

This package includes:
- flutter_localizations
- plugin_platform_interface  
- overlay_support
- vector_math
- intl

## Example

See the example folder for a complete implementation showing how to integrate this package into your Flutter app.

## Development

To contribute to this package:

1. Fork the repository
2. Create your feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
