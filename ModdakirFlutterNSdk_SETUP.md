# Moddakir Flutter N SDK Setup Guide

## Table of Contents

1. [Installation](#installation)
   - [Add Dependency](#1-add-dependency)
   - [Configure GitHub Access](#2-configure-github-access-for-android-sdk)
   - [Install Dependencies](#3-install-dependencies)
   - [Configure Android](#4-configure-android)
   - [Configure iOS](#5-configure-ios)
2. [Usage](#usage)
   - [Complete Setup Example](#complete-setup-example)
   - [Initialize SDK](#1-initialize-sdk)
   - [Start a Call Session](#2-start-a-call-session)
   - [SDK Parameters Explained](#3-sdk-parameters-explained)
   - [How It Works](#4-how-it-works)
3. [Call Events](#call-events)
4. [Troubleshooting](#troubleshooting)
5. [Advanced Usage](#advanced-usage)
6. [Architecture](#architecture)
7. [Platform-Specific Notes](#platform-specific-notes)
   - [Android](#android)
   - [iOS](#ios)
   - [Cross-Platform Considerations](#cross-platform-considerations)
8. [Quick Reference](#quick-reference)
9. [Support](#support)

---

## Installation

### 1. Add Dependency

Add the SDK to your `pubspec.yaml`:

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

### 2. Configure GitHub Access (For Android SDK)

The Android SDK is hosted on GitHub Packages and requires authentication.

#### Option A: Environment Variables (Recommended)

Add to your shell profile (`~/.zshrc` or `~/.bash_profile`):

```bash
export GITHUB_USERNAME=your-github-username
export GITHUB_TOKEN=your-personal-access-token
```

Then reload:
```bash
source ~/.zshrc
```

#### Option B: gradle.properties

Create or edit `android/gradle.properties`:

```properties
gpr.user=your-github-username
gpr.token=your-personal-access-token
```

**⚠️ Important**: Add `gradle.properties` to `.gitignore` to avoid committing credentials:
```bash
echo "android/gradle.properties" >> .gitignore
```

**How to get GitHub Token:**
1. Go to GitHub Settings → Developer settings → Personal access tokens
2. Generate new token (classic)
3. Select scope: `read:packages`
4. Copy and save the token

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Configure Android

#### 4.1 Add Permissions

Add required permissions to your `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    
    <!-- Required Permissions -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    <uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
    <uses-permission android:name="android.permission.BLUETOOTH" />
    <uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
    
    <!-- Camera and Microphone Features -->
    <uses-feature android:name="android.hardware.camera" android:required="false" />
    <uses-feature android:name="android.hardware.camera.autofocus" android:required="false" />
    <uses-feature android:name="android.hardware.microphone" android:required="true" />
    
    <application>
        <!-- Your app content -->
    </application>
</manifest>
```

#### 4.2 Update Gradle Configuration

Update your `android/app/build.gradle`:

```gradle
android {
    compileSdkVersion 36  // or higher
    
    defaultConfig {
        minSdkVersion 24  // Minimum SDK 24 (Android 7.0)
        targetSdkVersion 36
        ndkVersion = "28.2.13676358"
        
        // Enable multidex if needed
        multiDexEnabled true
    }
    
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
    
    kotlinOptions {
        jvmTarget = '1.8'
    }
}

dependencies {
    // Add if you need multidex support
    implementation 'androidx.multidex:multidex:2.0.1'
}
```

#### 4.3 Request Runtime Permissions

Add runtime permission requests in your Flutter app:

```dart
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  // Request camera and microphone permissions
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.microphone,
  ].request();
  
  if (statuses[Permission.camera]!.isDenied || 
      statuses[Permission.microphone]!.isDenied) {
    // Handle denied permissions
    print('Permissions denied');
  }
}
```

**Note**: Add `permission_handler` to your `pubspec.yaml`:
```yaml
dependencies:
  permission_handler: ^11.0.0
```

### 5. Configure iOS

#### Requirements

| Requirement | Version |
|-------------|----------|
| iOS | 13.0+ |
| Swift | 5.9+ |
| Xcode | 15+ |

#### 5.1 Configure GitHub Access (Swift Package Manager)

1. Open Xcode and go to **Settings** → **Accounts**
2. Click **+** → **GitHub** and enter your credentials:
   - **Username**: Your GitHub username
   - **Token**: Your GitHub Personal Access Token

**How to get GitHub Token:**
1. Go to GitHub Settings → Developer settings → Personal access tokens
2. Generate new token (classic)
3. Select scope: `read:packages`
4. Copy and save the token

3. Add the package by URL in Xcode

#### 5.2 Add Privacy Permissions

Add required permissions to your `ios/Runner/Info.plist`:

```xml
<dict>
    <!-- Microphone — required for all call types -->
    <key>NSMicrophoneUsageDescription</key>
    <string>This app needs microphone access to make audio and video calls.</string>
    
    <!-- Camera — required only for video calls -->
    <key>NSCameraUsageDescription</key>
    <string>This app needs camera access to make video calls.</string>
</dict>
```

> **Note:** If the user denies these permissions, the SDK will automatically display an alert and will **not** present the call screen.

#### 5.3 Update iOS Deployment Target

Update your `ios/Podfile`:

```ruby
platform :ios, '13.0'  # Minimum iOS 13.0

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    
    # Set minimum deployment target
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
```

#### 5.4 Install iOS Dependencies

```bash
cd ios
pod install
cd ..
```

## Usage

### Complete Setup Example

Here's a complete example showing all setup steps:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moddakir_flutter_n_sdk/moddakir_flutter_n_sdk.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the Call SDK
  await ModdakirFlutterNSdk.instance.initializeCallSDK();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moddakir SDK Demo',
      home: BlocProvider(
        create: (context) => CallInjection.instance.sessionCubit,
        child: CallSetupScreen(),
      ),
    );
  }
}

class CallSetupScreen extends StatefulWidget {
  @override
  _CallSetupScreenState createState() => _CallSetupScreenState();
}

class _CallSetupScreenState extends State<CallSetupScreen> {
  bool _permissionsGranted = false;
  
  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }
  
  Future<void> _checkPermissions() async {
    final statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();
    
    setState(() {
      _permissionsGranted = statuses.values.every((status) => status.isGranted);
    });
    
    if (!_permissionsGranted) {
      _showPermissionDialog();
    }
  }
  
  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('الصلاحيات مطلوبة'),
        content: Text('نحتاج إلى صلاحيات الكاميرا والميكروفون لإجراء المكالمات'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('فتح الإعدادات'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _startCall() async {
    if (!_permissionsGranted) {
      _showPermissionDialog();
      return;
    }
    
    // Get session first
    await context.read<SessionCubit>().getSdkSession(
      name: 'John Doe',
      email: 'john@example.com',
      phone: '+201234567890',
      gender: 'male',
      language: 'ar',
      moddakirId: 'your-moddakir-id',
      moddakirKey: 'your-moddakir-key',
    );
  }
  
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Moddakir SDK')),
      body: BlocListener<SessionCubit, SessionState>(
        listener: (context, state) async {
          if (state is SessionSuccess) {
            // Start call with session credentials
            final success = await ModdakirFlutterNSdk.instance.startCallSession(
              token: state.session.token,
              sdkSessionId: state.session.sdkSessionId,
              appName: 'your-app-name',
              language: 'ar',
              callType: 'Voice',
              isDark: false,
            );
            
            if (!success) {
              _showError('فشل بدء المكالمة');
            }
          } else if (state is SessionError) {
            _showError(state.message);
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_permissionsGranted)
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'يرجى منح الصلاحيات المطلوبة',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              
              BlocBuilder<SessionCubit, SessionState>(
                builder: (context, state) {
                  final isLoading = state is SessionLoading;
                  return ElevatedButton(
                    onPressed: isLoading ? null : _startCall,
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('بدء المكالمة'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### 1. Initialize SDK

Initialize the SDK in your `main.dart`:

```dart
import 'package:moddakir_flutter_n_sdk/moddakir_flutter_n_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the Call SDK
  await ModdakirFlutterNSdk.instance.initializeCallSDK();
  
  runApp(MyApp());
}
```

### 2. Start a Call Session

The SDK uses a **two-step process**:

#### Step 1: Get Session Credentials

First, get session credentials from your backend API:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';

// Use SessionCubit to get credentials
await context.read<SessionCubit>().getSdkSession(
  name: 'John Doe',
  email: 'john@example.com',
  phone: '+201234567890',
  gender: 'male',
  language: 'ar',
  moddakirId: 'your-moddakir-id',
  moddakirKey: 'your-moddakir-key',
);
```

#### Step 2: Start Call with Credentials

Listen to session state and start call when credentials are ready:

```dart
BlocListener<SessionCubit, SessionState>(
  listener: (context, state) async {
    if (state is SessionSuccess) {
      final success = await ModdakirFlutterNSdk.instance.startCallSession(
        token: state.session.token,
        sdkSessionId: state.session.sdkSessionId,
        appName: 'your-app-name',
        language: 'ar',
        callType: 'Voice',
        isDark: false,
      );
      
      if (success) {
        print('Call started successfully');
      }
    } else if (state is SessionError) {
      print('Error: ${state.message}');
    }
  },
  child: YourWidget(),
)
```

### 3. SDK Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `token` | String | Yes | - | Access token from session API |
| `sdkSessionId` | String | Yes | - | SDK session ID from session API |
| `appName` | String | Yes | - | Your Moddakir app name |
| `language` | String | Yes | - | Interface language: `'ar'` or `'en'` |
| `callType` | String | Yes | - | Call type: `'Voice'` or `'Video'` |
| `isDark` | bool | No | false | Enable dark mode |

### 4. How It Works

**Android Flow:**
```kotlin
CallsSdk.builder()
    .setSdkSessionId(sdkSessionId)
    .setToken(token)
    .setAppName(appName)
    .setLanguage(language)
    .setDarkMode(isDark ? "dark" : "light")
    .setCallType(callType)
    .start(from: activity)
```

**iOS Flow:**
```swift
SDKManager.start(
    from: viewController,
    config: SDKConfig(
        fullName: name,
        email: email,
        phone: phone,
        gender: gender,
        startDate: startDate,
        callType: callType,
        callDuration: duration,
        sessionInfo: sessionInfo,
        accessToken: token,
        sdkSessionId: sdkSessionId,
        appName: appName,
        language: language,
        environment: environment,
        theme: theme,
        mainColor: mainColor
    )
)
```

**Flow:**
1. Flutter calls `getSdkSession()` to get credentials from API
2. SessionCubit emits `SessionSuccess` with token and sdkSessionId
3. Flutter calls `startCallSession()` with credentials
4. Parameters are passed to native platform via MethodChannel
5. Native SDK launches the call interface
6. Events are sent back to Flutter via EventChannel

## Call Events

The SDK emits events during the call lifecycle. Listen to these events to handle call state changes:

```dart
ModdakirFlutterNSdk.instance.callEvents.listen((event) {
  if (event is CallEndedEvent) {
    // Call has ended
    print('Call ended with state: ${event.state}');
    print('Duration: ${event.duration} seconds');
    
    // Handle call end (e.g., navigate back, show summary)
    Navigator.pop(context);
    
  } else if (event is CallStateUpdatedEvent) {
    // Call state changed
    print('Call state updated: ${event.state}');
    
    // Handle state changes (e.g., connecting, connected, disconnected)
    
  } else if (event is CallErrorEvent) {
    // Error occurred
    print('Call error: ${event.message}');
    
    // Handle errors (e.g., show error dialog)
  }
});
```

### Event Types

| Event | Description | Properties |
|-------|-------------|------------|
| `CallEndedEvent` | Call has ended | `state`, `duration` |
| `CallStateUpdatedEvent` | Call state changed | `state` |
| `CallErrorEvent` | Error occurred | `message`, `code` |

## Troubleshooting

### GitHub Packages Authentication Failed

**Issue**: `Could not resolve com.moddakir:call-sdk:x.x.x`

**Solution**: Verify GitHub credentials are set:
```bash
echo $GITHUB_USERNAME
echo $GITHUB_TOKEN
```

If empty, add them to your environment or `gradle.properties`.

### Gradle Version Incompatible

**Issue**: `Unsupported class file major version 69`

**Solution**: Update Gradle version in `android/gradle/wrapper/gradle-wrapper.properties`:
```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-8.11.1-all.zip
```

And set Java home in `android/gradle.properties`:
```properties
org.gradle.java.home=/path/to/java-17
```

### Android Manifest Merger Failed

**Issue**: `Attribute activity@exported value=(true) from AndroidManifest.xml is also present`

**Solution**: Add `tools:replace` to your AndroidManifest.xml:
```xml
<activity
    android:name="com.example.sdksample.feature.call.presentation.ui.MainActivity"
    android:exported="true"
    tools:replace="android:theme,android:exported" />
```

### Events Not Received

**Issue**: Call events are not being received

**Solution**: Listen to events **before** starting the call:
```dart
_subscription = ModdakirFlutterNSdk.instance.callEvents.listen(...);
await ModdakirFlutterNSdk.instance.startCallSession(...);
```

### Invalid Credentials

**Issue**: 401 Unauthorized error

**Solution**: Verify your Moddakir `moddakirId` and `moddakirKey` are correct.

## Advanced Usage

### Custom Theming

Customize the SDK appearance:

```dart
await ModdakirFlutterNSdk.instance.startCallSession(
  token: 'your-access-token',
  sdkSessionId: 'your-sdk-session-id',
  appName: 'your-app-name',
  language: 'ar',
  callType: 'Voice',
  isDark: true,  // Enable dark mode
);
```

### Using BLoC Pattern

The SDK integrates seamlessly with BLoC pattern:

```dart
// 1. Create SessionCubit instance
final sessionCubit = CallInjection.instance.sessionCubit;

// 2. Provide it to your widget tree
BlocProvider(
  create: (context) => sessionCubit,
  child: YourScreen(),
)

// 3. Use it in your widgets
BlocBuilder<SessionCubit, SessionState>(
  builder: (context, state) {
    if (state is SessionLoading) {
      return CircularProgressIndicator();
    } else if (state is SessionSuccess) {
      return Text('Session ready!');
    } else if (state is SessionError) {
      return Text('Error: ${state.message}');
    }
    return SizedBox();
  },
)
```

## Architecture

### SDK Flow

```
Flutter App
    ↓
ModdakirFlutterNSdk (Dart)
    ↓
MethodChannel
    ↓
ModdakirFlutterNSdk (Kotlin/Swift)
    ↓
Native SDK (Android: CallsSdk / iOS: SDKManager)
    ↓
Call Interface
    ↓
EventChannel
    ↓
Flutter App (Events)
```

### Key Components

| Component | Description |
|-----------|-------------|
| `ModdakirFlutterNSdk.dart` | Main Flutter API |
| `ModdakirPlatformChannel.dart` | Platform channel bridge |
| `ModdakirFlutterNSdk.kt` | Kotlin plugin entry point (Android) |
| `ModdakirFlutterNSdk.swift` | Swift plugin entry point (iOS) |
| `CallsSdk` | Native Android SDK |
| `SDKManager` | Native iOS SDK |
| `SessionCubit` | BLoC state management for sessions |

### Clean Architecture

The example app follows clean architecture principles:

```
lib/
├── core/
│   └── utils/
│       └── error_handler.dart
├── features/
│   └── call/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── call_api_service.dart
│       │   ├── models/
│       │   │   ├── session_request_model.dart
│       │   │   └── session_response_model.dart
│       │   ├── mappers/
│       │   │   └── session_mapper.dart
│       │   └── repositories/
│       │       └── session_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── session_entity.dart
│       │   ├── repositories/
│       │   │   └── session_repository.dart
│       │   └── usecases/
│       │       └── get_sdk_session_usecase.dart
│       ├── presentation/
│       │   ├── screens/
│       │   │   └── simple_call_screen.dart
│       │   ├── state/
│       │   │   └── session_state.dart
│       │   └── viewmodels/
│       │       └── session_viewmodel.dart
│       └── di/
│           └── call_injection.dart
└── main.dart
```

## Platform-Specific Notes

### Android

#### Minimum Requirements
- **Min SDK**: 24 (Android 7.0 Nougat)
- **Target SDK**: 36 (Android 14)
- **Compile SDK**: 36 or higher
- **Kotlin**: 2.2.20 or higher
- **Gradle**: 8.11.1 or higher
- **NDK**: 28.2.13676358

#### ProGuard Rules

If you're using ProGuard/R8, add these rules to `android/app/proguard-rules.pro`:

```proguard
# Moddakir SDK
-keep class com.moddakir.** { *; }
-keepclassmembers class com.moddakir.** { *; }

# Agora
-keep class io.agora.** { *; }
-dontwarn io.agora.**
```

#### Build Issues

**Issue**: `Duplicate class found`

**Solution**: Add to `android/app/build.gradle`:
```gradle
android {
    packagingOptions {
        exclude 'META-INF/DEPENDENCIES'
        exclude 'META-INF/LICENSE'
        exclude 'META-INF/LICENSE.txt'
        exclude 'META-INF/NOTICE'
        exclude 'META-INF/NOTICE.txt'
    }
}
```

**Issue**: `Execution failed for task ':app:mergeDebugNativeLibs'`

**Solution**: Add to `android/gradle.properties`:
```properties
android.useAndroidX=true
android.enableJetifier=true
```

#### Testing on Physical Device

For best results, test on a physical Android device:
```bash
# Check connected devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Build APK for testing
flutter build apk --debug
```

### iOS

#### Minimum Requirements
- **iOS Version**: 13.0 or higher
- **Xcode**: 15.0 or higher
- **Swift**: 5.9 or higher

#### Signing & Capabilities

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select **Runner** target
3. Go to **Signing & Capabilities**
4. Enable the following capabilities:
   - ✅ **Background Modes**: Audio, Voice over IP
   - ✅ **Camera** (automatically added via Info.plist)
   - ✅ **Microphone** (automatically added via Info.plist)

#### Build Issues

**Issue**: `Undefined symbol` or `Library not found`

**Solution**: Clean and reinstall pods:
```bash
cd ios
rm -rf Pods Podfile.lock
pod cache clean --all
pod install
cd ..
flutter clean
flutter pub get
```

**Issue**: `The iOS deployment target 'IPHONEOS_DEPLOYMENT_TARGET' is set to 8.0`

**Solution**: Already handled in Podfile post_install. If issue persists:
```bash
cd ios
pod update
cd ..
```

#### Testing on Physical Device

For iOS, you need:
1. Apple Developer Account (free or paid)
2. Physical iOS device
3. Proper code signing

```bash
# List iOS devices
flutter devices

# Run on iOS device
flutter run -d <device-id>

# Build for iOS
flutter build ios --debug
```

#### Simulator Limitations

⚠️ **Note**: iOS Simulator has limitations:
- No camera access (camera calls will fail)
- No microphone access
- Network conditions may differ

**Always test on a physical iOS device for call functionality.**

### Cross-Platform Considerations

#### Permission Handling

| Platform | Permission Request Timing | Notes |
|----------|---------------------------|-------|
| **Android** | Runtime (on first use) | Can be requested anytime |
| **iOS** | Runtime (on first use) | Must show usage description |

#### Network Requirements

Both platforms require:
- ✅ Active internet connection (WiFi or cellular)
- ✅ Stable connection (minimum 1 Mbps for voice, 2 Mbps for video)
- ✅ Low latency (< 200ms recommended)

#### Background Behavior

| Platform | Background Audio | Background Video | Notes |
|----------|------------------|------------------|-------|
| **Android** | ✅ Supported | ❌ Paused | Audio continues in background |
| **iOS** | ✅ Supported | ❌ Paused | Requires Background Modes capability |

## Quick Reference

### Android Setup Checklist

- [ ] Add SDK dependency to `pubspec.yaml`
- [ ] Configure GitHub credentials (username & token)
- [ ] Add permissions to `AndroidManifest.xml`
- [ ] Update `minSdkVersion` to 24 in `build.gradle`
- [ ] Set `ndkVersion` to 28.2.13676358
- [ ] Add `permission_handler` package
- [ ] Request runtime permissions in app
- [ ] Initialize SDK in `main.dart`
- [ ] Test on physical device

### iOS Setup Checklist

- [ ] Add SDK dependency to `pubspec.yaml`
- [ ] Configure GitHub credentials in Xcode (Settings → Accounts)
- [ ] Add privacy descriptions to `Info.plist` (Microphone & Camera)
- [ ] Update iOS deployment target to 13.0 in `Podfile`
- [ ] Run `pod install`
- [ ] Configure code signing in Xcode
- [ ] Initialize SDK in `main.dart`
- [ ] Test on physical device (Simulator has limitations)

### Common Commands

```bash
# Install dependencies
flutter pub get

# iOS pod install
cd ios && pod install && cd ..

# Clean build
flutter clean
flutter pub get

# Run on device
flutter run

# Build APK (Android)
flutter build apk --release

# Build IPA (iOS)
flutter build ios --release

# Check for issues
flutter doctor -v
```

### File Locations

| File | Path | Purpose |
|------|------|---------|
| Android Manifest | `android/app/src/main/AndroidManifest.xml` | Permissions |
| Android Gradle | `android/app/build.gradle` | Build config |
| iOS Info.plist | `ios/Runner/Info.plist` | Privacy permissions |
| iOS Podfile | `ios/Podfile` | Dependencies |
| Main Dart | `lib/main.dart` | SDK initialization |

## Support

For issues or questions:
- GitHub Issues: [Create an issue](https://github.com/your-org/moddakir-flutter-n-sdk/issues)
- Documentation: [README.md](README.md)
- API Reference: [Moddakir API Docs](https://docs.moddakir.com)
