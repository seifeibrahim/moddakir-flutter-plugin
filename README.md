# Moddakir Flutter Plugin

Flutter plugin wrapper for Moddakir Call SDK (Android & iOS).

## Features

- Initialize Moddakir Call SDK
- Start video/audio calls
- Listen to call events (ended, state updates)
- Clean architecture with platform channels
- Type-safe event models
- iOS support (coming soon)

## Architecture

Flutter App
    │
    ▼
ModdakirFlutterPlugin (Dart)
    │
    ├─► MethodChannel ──► Android/iOS Plugin ──► Native SDK
    │
    └─► EventChannel ◄── Listeners ◄── SDK Callbacks

## Installation

See [SETUP.md](SETUP.md) for detailed setup instructions.

### Quick Start

1. Add dependency:
```yaml
dependencies:
  moddakir_flutter_plugin:
    git:
      url: https://github.com/your-org/moddakir-flutter-plugin.git
```

2. Configure GitHub credentials (for Android SDK):
```bash
export GITHUB_USERNAME=your-username
export GITHUB_TOKEN=your-token
```

3. Initialize SDK:
```dart
await ModdakirFlutterPlugin.instance.initializeCallSDK();
```

## Usage

```dart
import 'package:moddakir_flutter_plugin/moddakir_flutter_plugin.dart';

// Listen to call events
ModdakirFlutterPlugin.instance.callEvents.listen((event) {
  if (event is CallEndedEvent) {
    print('Call ended: ${event.state}, duration: ${event.duration}s');
  }
});

// Start a call
await ModdakirFlutterPlugin.instance.startCall(
  callId: 'call-123',
  additionalParams: {'userId': 'user-456'},
);
```

## Documentation

- [Setup Guide](SETUP.md) - Detailed setup instructions
- [Architecture](lib/src/README.md) - Internal architecture documentation

## Platform Support

| Platform | Status |
|----------|--------|
| Android  | Supported |
| iOS      | In Progress |

## Requirements

- Flutter SDK: >=3.0.0
- Android: minSdk 21, compileSdk 34
- iOS: iOS 12.0+ (coming soon)

## License

See [LICENSE](LICENSE) file.
