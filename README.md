# Moddakir Flutter Plugin

Flutter plugin wrapper for Moddakir Call SDK (Android & iOS).

## Features

- Initialize Moddakir Call SDK
- Start video/audio calls
- Listen to call events (ended, state updates)
- Clean architecture with platform channels
- Type-safe event models
- Full Android & iOS support

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

### Android Setup

See [SETUP.md](SETUP.md) for Android setup instructions.

### iOS Setup ⚠️

**IMPORTANT:** iOS requires manual Swift Package setup due to CocoaPods limitations.

See [README_IOS_SETUP.md](README_IOS_SETUP.md) for detailed iOS setup instructions.

**Quick Summary:**
1. Open `ios/Runner.xcworkspace` in Xcode
2. Add Swift Package: `https://github.com/Moddakir-App/moddakir-ios-n-sdk` (v1.0.0)
3. Requires SSH access to Bitbucket

### Quick Start

1. Add dependency:
```yaml
dependencies:
  moddakir_flutter_plugin:
    git:
      url: https://github.com/your-org/moddakir-flutter-plugin.git
```

2. **Android:** Configure GitHub credentials:
```bash
export GITHUB_USERNAME=your-username
export GITHUB_TOKEN=your-token
```

3. **iOS:** Add Swift Package in Xcode (see README_IOS_SETUP.md)

4. Initialize SDK:
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
| Android  | ✅ Supported |
| iOS      | ✅ Supported |

## Requirements

- Flutter SDK: >=3.3.0
- Android: minSdk 21, compileSdk 34
- iOS: iOS 13.0+

## License

See [LICENSE](LICENSE) file.
