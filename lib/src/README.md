# Moddakir Flutter Plugin Architecture

## Structure

```
lib/
├── moddakir_flutter_plugin.dart          # Public API
├── src/
│   ├── models/
│   │   └── call_event.dart               # Event models
│   ├── platform/
│   │   └── moddakir_platform_channel.dart # Platform channel layer
│   └── README.md                          # This file
```

## Android Layer

```
android/src/main/kotlin/com/moddakir/moddakir_flutter_plugin/
├── ModdakirFlutterPlugin.kt              # Main plugin entry point
├── core/
│   ├── CallFlutterManager.kt             # Manages Flutter-Android bridge
│   └── listeners/
│       └── CallListenersSetup.kt         # Sets up SDK listeners
```

## Usage Example

```dart
import 'package:moddakir_flutter_plugin/moddakir_flutter_plugin.dart';

// Initialize SDK
await ModdakirFlutterPlugin.instance.initializeCallSDK();

// Listen to call events
ModdakirFlutterPlugin.instance.callEvents.listen((event) {
  if (event is CallEndedEvent) {
    print('Call ended: ${event.state}, duration: ${event.duration}');
  }
});

// Start a call
await ModdakirFlutterPlugin.instance.startCall(
  callId: '123',
  additionalParams: {
    'userId': 'user123',
  },
);
```

## Architecture Flow

```
Flutter App
    │
    ▼
ModdakirFlutterPlugin (Dart)
    │
    ▼
ModdakirPlatformChannel
    │
    ├─► MethodChannel ──► Android Plugin ──► Moddakir Call SDK
    │
    └─► EventChannel ◄── CallFlutterManager ◄── SDK Listeners
```

## Key Components

### Flutter Side
- **ModdakirFlutterPlugin**: Singleton public API
- **ModdakirPlatformChannel**: Handles platform communication
- **CallEvent Models**: Type-safe event classes

### Android Side
- **ModdakirFlutterPlugin.kt**: Implements FlutterPlugin, ActivityAware, EventChannel.StreamHandler
- **CallFlutterManager**: Singleton that bridges SDK callbacks to Flutter
- **CallListenersSetup**: Configures all SDK listeners (RTM, RTC, UpdateCall, ActionButtons)

## Adding New Methods

### 1. Add to Android Plugin
```kotlin
override fun onMethodCall(call: MethodCall, result: Result) {
  when (call.method) {
    "yourMethod" -> {
      yourMethod(call, result)
    }
  }
}
```

### 2. Add to Platform Channel
```dart
Future<bool> yourMethod(Map<String, dynamic> params) async {
  final result = await _methodChannel.invokeMethod<bool>('yourMethod', params);
  return result ?? false;
}
```

### 3. Add to Public API
```dart
Future<bool> yourMethod({required String param}) {
  return _platform.yourMethod({'param': param});
}
```
