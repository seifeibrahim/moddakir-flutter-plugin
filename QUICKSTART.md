# Quick Start Guide

## 1. Setup GitHub Credentials

You need GitHub credentials to access the Moddakir Android SDK.

### Option A: Environment Variables (Recommended)
```bash
export GITHUB_USERNAME=your-github-username
export GITHUB_TOKEN=your-github-token
```

Add to `~/.zshrc`:
```bash
echo 'export GITHUB_USERNAME=your-username' >> ~/.zshrc
echo 'export GITHUB_TOKEN=your-token' >> ~/.zshrc
source ~/.zshrc
```

**Note:** See `CREDENTIALS_SETUP.md` for detailed instructions on getting a GitHub token.

### Option B: gradle.properties (Local Only)
```bash
cd android
cp gradle.properties.example gradle.properties
# File already contains your credentials
```

## 2. Test the Build

```bash
# Clean and get dependencies
flutter clean
flutter pub get

# Build example app
cd example
flutter pub get
flutter build apk --debug
```

## 3. Run on Device

```bash
# Make sure device is connected
flutter devices

# Run the example app
flutter run
```

## 4. Test the Integration

The example app will:
1. ✅ Initialize the SDK on startup
2. 📱 Show a UI with call configuration
3. 📞 Allow you to start a call
4. 📡 Display events in real-time

## 5. Next Steps - Complete SDK Integration

The plugin is ready but needs the actual SDK call implementation. Open:
```
android/src/main/kotlin/com/moddakir/moddakir_flutter_n_sdk/ModdakirFlutterNSdk.kt
```

Find the `startCall()` method (line ~69) and replace the TODO with actual SDK code:

```kotlin
private fun startCall(call: MethodCall, result: Result) {
    try {
        val currentActivity = activity ?: run {
            result.error("NO_ACTIVITY", "Activity not available", null)
            return
        }
        
        val callId = call.argument<String>("callId") ?: run {
            result.error("INVALID_ARGS", "callId is required", null)
            return
        }
        
        val userId = call.argument<String>("userId")
        val sessionId = call.argument<String>("sessionId")
        
        // TODO: Replace with actual SDK call
        // Check the Moddakir SDK documentation for the exact method
        // Example (adjust based on actual SDK API):
        
        // CallsSDK.startCall(
        //     activity = currentActivity,
        //     callId = callId,
        //     userId = userId,
        //     sessionId = sessionId,
        //     callback = object : CallCallback {
        //         override fun onSuccess() {
        //             result.success(true)
        //         }
        //         override fun onError(error: String) {
        //             result.error("CALL_ERROR", error, null)
        //         }
        //     }
        // )
        
        result.success(true)
    } catch (e: Exception) {
        result.error("CALL_ERROR", e.message, null)
    }
}
```

## 6. Check SDK Documentation

You need to check the Moddakir Call SDK documentation to find:

1. **How to start a call**:
   - What class/method to call?
   - What parameters does it need?
   - Does it return a callback or open an Activity?

2. **Example from your Android sample**:
   ```kotlin
   // From SampleApp.kt, the SDK is initialized like:
   CallsApp.context = applicationContext
   
   // And listeners are set up via:
   CallbackUpdateCallListener.updateCallListener = ...
   CallbackRTMListener.rtmListener = ...
   // etc.
   ```

3. **Look for methods like**:
   - `CallsSDK.startCall()`
   - `CallsSDK.initiateCall()`
   - `CallsSDK.joinCall()`
   - Or similar

## 7. Verify Everything Works

```bash
# Rebuild after changes
cd example
flutter clean
flutter build apk --debug
flutter run
```

## Common Issues

### "Could not resolve com.moddakir:call-sdk"
```bash
# Verify credentials
echo $GITHUB_USERNAME
echo $GITHUB_TOKEN

# If empty, set them:
export GITHUB_USERNAME=your-github-username
export GITHUB_TOKEN=your-github-token
```

### Build fails with Gradle error
```bash
# Clean everything
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
```

### SDK not found
```bash
# Check if you can access the package (replace YOUR_TOKEN with your actual token)
curl -H "Authorization: token YOUR_TOKEN" \
  https://maven.pkg.github.com/Mibrahim511/moddakir-sdk-andorid/com/moddakir/call-sdk/1.0.21/
```

## Project Structure Summary

```
moddakir-flutter-n-sdk/
├── lib/
│   ├── moddakir_flutter_n_sdk.dart          # ✅ Public API (Complete)
│   └── src/
│       ├── models/
│       │   ├── call_event.dart               # ✅ Event models (Complete)
│       │   └── call_config.dart              # ✅ Config model (Complete)
│       └── platform/
│           └── moddakir_platform_channel.dart # ✅ Platform bridge (Complete)
├── android/
│   ├── build.gradle                           # ✅ Gradle config (Complete)
│   ├── gradle.properties.example              # ✅ Credentials template
│   └── src/main/kotlin/.../
│       ├── ModdakirFlutterNSdk.kt          # 🚧 Main plugin (Needs SDK integration)
│       └── core/
│           ├── CallFlutterManager.kt         # ✅ Flutter bridge (Complete)
│           └── listeners/
│               └── CallListenersSetup.kt     # ✅ Listeners (Complete)
└── example/
    └── lib/main.dart                          # ✅ Demo app (Complete)
```

## What's Done ✅

1. ✅ Flutter plugin structure
2. ✅ Android Gradle configuration with Maven repo
3. ✅ Platform channels (Method + Event)
4. ✅ Event models and type-safe parsing
5. ✅ Listener setup matching Android sample
6. ✅ Complete example app with UI
7. ✅ Documentation (README, SETUP, IMPLEMENTATION_GUIDE)

## What's Needed 🚧

1. 🚧 Complete `startCall()` with actual SDK method
2. 🚧 Test on real device with actual call
3. 🚧 Add more SDK methods (end call, mute, etc.)
4. 🚧 iOS implementation

## Ready to Test!

Everything is set up. Just need to:
1. Set environment variables
2. Run `flutter build apk`
3. Complete the SDK integration in `startCall()`

Good luck! 🚀
