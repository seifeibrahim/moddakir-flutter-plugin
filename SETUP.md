# Moddakir Flutter Plugin Setup Guide

## Prerequisites

1. **GitHub Personal Access Token** with `read:packages` permission
   - Go to GitHub Settings → Developer settings → Personal access tokens
   - Generate new token with `read:packages` scope
   - Save the token securely

## Setup Steps

### 1. Configure GitHub Credentials

You have two options:

#### Option A: Environment Variables (Recommended)
```bash
export GITHUB_USERNAME=your-github-username
export GITHUB_TOKEN=your-github-token
```

Add to your `~/.zshrc` or `~/.bash_profile`:
```bash
echo 'export GITHUB_USERNAME=your-github-username' >> ~/.zshrc
echo 'export GITHUB_TOKEN=your-github-token' >> ~/.zshrc
source ~/.zshrc
```

#### Option B: gradle.properties
Edit `android/gradle.properties`:
```properties
gpr.user=your-github-username
gpr.token=your-github-token
```

**⚠️ IMPORTANT**: If using Option B, add `gradle.properties` to `.gitignore`

### 2. Install Dependencies

```bash
cd moddakir-flutter-n-sdk
flutter pub get
```

### 3. Build Android

```bash
cd example
flutter build apk
```

## Project Structure

```
moddakir-flutter-n-sdk/
├── lib/
│   ├── moddakir_flutter_n_sdk.dart          # Public API
│   └── src/
│       ├── models/
│       │   └── call_event.dart               # Event models
│       └── platform/
│           └── moddakir_platform_channel.dart # Platform channel
├── android/
│   ├── build.gradle                           # Gradle config with Maven repo
│   ├── gradle.properties                      # GitHub credentials (gitignored)
│   └── src/main/kotlin/com/moddakir/moddakir_flutter_n_sdk/
│       ├── ModdakirFlutterNSdk.kt          # Main plugin
│       └── core/
│           ├── CallFlutterManager.kt         # Flutter bridge
│           └── listeners/
│               └── CallListenersSetup.kt     # SDK listeners
└── example/                                   # Example app
```

## Usage in Your Flutter App

### 1. Add Dependency

In your `pubspec.yaml`:
```yaml
dependencies:
  moddakir_flutter_n_sdk:
    git:
      url: https://github.com/your-org/moddakir-flutter-n-sdk.git
      ref: main
```

Or for local development:
```yaml
dependencies:
  moddakir_flutter_n_sdk:
    path: ../moddakir-flutter-n-sdk
```

### 2. Initialize SDK

```dart
import 'package:moddakir_flutter_n_sdk/moddakir_flutter_n_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the Call SDK
  await ModdakirFlutterNSdk.instance.initializeCallSDK();
  
  runApp(MyApp());
}
```

### 3. Listen to Call Events

```dart
class CallScreen extends StatefulWidget {
  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  StreamSubscription<CallEvent>? _callEventsSubscription;

  @override
  void initState() {
    super.initState();
    
    _callEventsSubscription = ModdakirFlutterNSdk.instance.callEvents.listen((event) {
      if (event is CallEndedEvent) {
        print('Call ended: ${event.state}');
        print('Duration: ${event.duration} seconds');
        
        // Navigate back or show summary
        Navigator.pop(context);
      } else if (event is CallStateUpdatedEvent) {
        print('Call state: ${event.state}');
      }
    });
  }

  @override
  void dispose() {
    _callEventsSubscription?.cancel();
    super.dispose();
  }

  Future<void> _startCall() async {
    try {
      await ModdakirFlutterNSdk.instance.startCall(
        callId: 'call-123',
        additionalParams: {
          'userId': 'user-456',
          'sessionId': 'session-789',
        },
      );
    } catch (e) {
      print('Error starting call: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Call')),
      body: Center(
        child: ElevatedButton(
          onPressed: _startCall,
          child: Text('Start Call'),
        ),
      ),
    );
  }
}
```

## Android Configuration

### Required Permissions

Add to your app's `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### GitHub Credentials in CI/CD

For GitHub Actions:
```yaml
- name: Build Android
  env:
    GITHUB_USERNAME: ${{ secrets.GH_USERNAME }}
    GITHUB_TOKEN: ${{ secrets.GH_TOKEN }}
  run: flutter build apk
```

## Troubleshooting

### Issue: "Could not resolve com.moddakir:call-sdk:1.0.64"

**Solution**: Check GitHub credentials
```bash
echo $GITHUB_USERNAME
echo $GITHUB_TOKEN
```

### Issue: "Activity not available"

**Solution**: Ensure you're calling `startCall()` from a screen with an active Activity context.

### Issue: Events not received

**Solution**: Make sure you're listening to events before starting the call:
```dart
// ✅ Correct
_subscription = plugin.callEvents.listen(...);
await plugin.startCall(...);

// ❌ Wrong
await plugin.startCall(...);
_subscription = plugin.callEvents.listen(...); // Too late!
```

## Next Steps

1. **Add iOS Support**: Create similar layer for iOS SDK
2. **Add More Methods**: Implement additional SDK features
3. **Add Tests**: Write unit and integration tests
4. **Documentation**: Add API documentation

## Architecture Reference

Based on the Android sample from:
- GitHub: `Mibrahim511/moddakir-sdk-andorid`
- Package: `com.moddakir:call-sdk:1.0.64`

The plugin follows the same listener pattern:
- `CallbackUpdateCallListener` → `CallFlutterManager.onCallEnded()`
- `CallbackRTMListener` → RTM events
- `CallbackRTCListener` → RTC events
- `CallbackActionButtonsListener` → UI action events

All callbacks are forwarded to Flutter via `EventChannel`.
