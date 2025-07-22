# API Documentation

## Main Widgets

### MiniappPluginView

The main widget that provides a complete Tetris game experience.

```dart
class MiniappPluginView extends StatefulWidget {
  const MiniappPluginView({super.key});
}
```

**Usage:**
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const MiniappPluginView()),
);
```

**Features:**
- Complete Tetris game with app bar
- Back button for navigation
- Integrated localization
- Full game controls

## Game Components

### Game

Core game widget that manages game state and logic.

```dart
class Game extends StatefulWidget {
  final Widget child;
  const Game({super.key, required this.child});
  
  static GameControl of(BuildContext context) // Access game controller
}
```

### GameControl

The main game controller that handles:
- Block movement and rotation
- Line clearing logic
- Level progression
- Scoring system
- Game state management

**Methods:**
- `rotate()` - Rotate current block
- `left()` - Move block left
- `right()` - Move block right  
- `down()` - Move block down
- `drop()` - Drop block immediately
- `pause()` - Pause game
- `pauseOrResume()` - Toggle pause state
- `reset()` - Reset game

### Block

Represents Tetris blocks with different shapes and orientations.

```dart
class Block {
  static Block getRandom() // Get random block
  Block rotate() // Rotate block
  Block left() // Move left
  Block right() // Move right  
  Block fall({int step = 1}) // Move down
  bool isValidInMatrix(List<List<int>> matrix) // Check valid position
  int get(int x, int y) // Get block value at position
}
```

**Block Types:**
- I, O, T, S, Z, J, L blocks
- Each with 4 rotation states

## UI Components

### PagePortrait

Main game layout for portrait mode.

```dart
class PagePortrait extends StatelessWidget {
  const PagePortrait({super.key});
}
```

### Screen

Game screen that displays the playing field.

```dart
class Screen extends StatelessWidget {
  final double width;
  const Screen({super.key, required this.width});
}
```

### GameController

Touch controls for mobile devices.

```dart
class GameController extends StatelessWidget {
  const GameController({super.key});
}
```

**Includes:**
- Direction pad for movement/rotation
- Drop button
- System buttons (pause, reset, sound)

### KeyboardController

Handles keyboard input for desktop/web.

```dart
class KeyboardController extends StatefulWidget {
  final Widget child;
  const KeyboardController({super.key, required this.child});
}
```

**Keyboard Mappings:**
- Arrow Keys: Move/rotate
- Space: Drop
- P: Pause/Resume  
- R: Reset
- S: Sound toggle

## Game State

### GameStates Enum

```dart
enum GameStates {
  none,     // Initial state
  paused,   // Game paused
  running,  // Game active
  reset,    // Resetting
  mixing,   // Block mixing animation
  clear,    // Line clear animation
  drop,     // Drop animation
}
```

### GameState

Inherited widget that provides game data to child widgets.

```dart
class GameState extends InheritedWidget {
  final List<List<int>> data;      // Game grid data
  final GameStates states;         // Current game state
  final int level;                 // Current level
  final int points;                // Current score
  final int cleared;               // Lines cleared
  final Block next;                // Next block
  
  static GameState of(BuildContext context) // Access game state
}
```

## Utilities

### Calculator

Simple utility class for demonstration.

```dart
class Calculator {
  int addOne(int value) => value + 1;
}
```

## Localization

### Generated L10n Class

Provides localized strings for the game interface.

```dart
class S {
  static S of(BuildContext context) // Get localization instance
  static const LocalizationsDelegate<S> delegate // Delegate for MaterialApp
  static List<Locale> get supportedLocales // Supported locales
  
  // Available strings:
  String get sounds;
  String get pause_resume;  
  String get reset;
  // ... more strings
}
```

**Supported Languages:**
- English (en)
- Chinese (zh_CN)

## Advanced Usage

### Custom Game Implementation

```dart
class CustomGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Game(
        child: Builder(
          builder: (context) {
            final gameState = GameState.of(context);
            return Column(
              children: [
                Text('Level: ${gameState.level}'),
                Text('Score: ${gameState.points}'),
                Expanded(
                  child: KeyboardController(
                    child: PagePortrait(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
```

### Accessing Game Controller

```dart
class GameButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final game = Game.of(context);
        game.rotate(); // Rotate current block
      },
      child: Text('Rotate'),
    );
  }
}
```

### Custom Controls

```dart
class CustomControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final game = Game.of(context);
    
    return Row(
      children: [
        IconButton(
          onPressed: game.left,
          icon: Icon(Icons.arrow_left),
        ),
        IconButton(
          onPressed: game.right,
          icon: Icon(Icons.arrow_right),
        ),
        IconButton(
          onPressed: game.rotate,
          icon: Icon(Icons.rotate_right),
        ),
        IconButton(
          onPressed: game.drop,
          icon: Icon(Icons.arrow_downward),
        ),
      ],
    );
  }
}
```

## Constants

### Game Constants

```dart
const gamePadMatrixH = 20;  // Game field height
const gamePadMatrixW = 10;  // Game field width
const levelMax = 6;         // Maximum level
const levelMin = 1;         // Minimum level
const screenBorderWidth = 3.0;
const backgroundColor = Color(0xffefcc19);
```

### Speed Settings

```dart
const speed = [
  Duration(milliseconds: 800),  // Level 1
  Duration(milliseconds: 650),  // Level 2
  Duration(milliseconds: 500),  // Level 3
  Duration(milliseconds: 370),  // Level 4
  Duration(milliseconds: 250),  // Level 5
  Duration(milliseconds: 160),  // Level 6
];
```
