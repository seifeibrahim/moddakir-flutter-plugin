# Complete Integration Guide - Moddakir Flutter Plugin

## 📋 Overview

This Flutter plugin integrates both **Android** and **iOS** native SDKs for Moddakir call functionality.

**Key Feature:** Unified flow across both platforms using session credentials from a single API call.

## 🎯 Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      Flutter Layer                          │
│  - Call Session API once                                    │
│  - Get sdkSessionId                                         │
│  - Pass to native platform                                  │
└─────────────────┬───────────────────────────────────────────┘
                  │
        ┌─────────┴─────────┐
        │                   │
┌───────▼────────┐  ┌───────▼────────┐
│    Android     │  │      iOS       │
│                │  │                │
│ CallsSdk       │  │ SDKManager     │
│ .builder()     │  │ .shared        │
│ .start()       │  │ .start()       │
└───────┬────────┘  └───────┬────────┘
        │                   │
        └─────────┬─────────┘
                  │
          ┌───────▼────────┐
          │   SDK UI       │
          │   (Native)     │
          └────────────────┘
```

## 🔄 Unified Flow

### Step 1: Session API Call (Flutter)

```dart
final sessionData = await SessionApi.getSdkSession(
  name: 'John Doe',
  email: 'john@example.com',
  phone: '+1234567890',
  gender: 'male',
  language: 'ar',
  moddakirId: 'sdk_5',
  moddakirKey: 'YOUR_API_KEY',
  sessionInfo: {...},
);

// Response: { token: "...", sdkSessionId: "..." }
```

### Step 2: Launch SDK (Both Platforms)

```dart
await ModdakirFlutterNSdk.instance.startCallSession(
  name: 'John Doe',
  email: 'john@example.com',
  phone: '+1234567890',
  gender: 'male',
  language: 'ar',
  appName: 'sdk_5',
  apiKey: 'YOUR_API_KEY',
  callType: 'Voice',
  sdkSessionId: sessionData['sdkSessionId'],  // 🔥 From API
  sessionInfo: {  // Required for iOS
    'fromSurah': '1',
    'toSurah': '2',
    'fromAyah': '1',
    'toAyah': '50',
    'pathType': 'initiation',
    'notes': 'Test session'
  },
);
```

### Step 3: SDK Handles Everything

- ✅ Authentication
- ✅ Teacher search
- ✅ Call creation
- ✅ Call UI
- ✅ Call management
- ✅ Call reporting

## 📱 Platform-Specific Details

### Android

**SDK:** `com.moddakir:call-sdk:1.0.64`

**Setup:**
1. SDK dependency in `android/build.gradle`
2. Maven repo: GitHub Packages (requires credentials)
3. Kotlin version: 2.2.20
4. Min SDK: 24

**Implementation:**
```kotlin
// FlutterCallFlowManager.kt
CallsSdk.builder(activity)
    .setSDkSessionId(sdkSessionId)
    .setToken(token)
    .setAppName("sdk_5")
    .setLanguage(Language.ar)
    .setCallType("Voice")
    .setEnvironment(Environment.SANDBOX)
    .start()
```

**Files:**
- `android/src/main/kotlin/com/moddakir/moddakir_flutter_n_sdk/ModdakirFlutterNSdk.kt`
- `android/src/main/kotlin/com/moddakir/moddakir_flutter_n_sdk/core/call/FlutterCallFlowManager.kt`
- `android/src/main/kotlin/com/moddakir/moddakir_flutter_n_sdk/core/SdkCallbackManager.kt`

### iOS

**SDK:** `ModdakirNativeSDK` v1.0.5 (Swift Package)

**Setup:**
1. Add Swift Package from GitHub
2. Bitbucket SSH access required for dependencies
3. Min iOS: 13.0
4. Swift 5.9+

**Implementation:**
```swift
// ModdakirFlutterNSdk.swift
let config = SDKConfig(
    fullName: fullName,
    email: email,
    phone: phone,
    gender: gender,
    startDate: startDate,
    callType: .voice,
    callDuration: callDuration,
    sessionInfo: sessionInfo,
    sdkSessionId: sdkSessionId,  // 🔥 From API
    language: language,
    environment: .sandbox
)

SDKManager.shared.start(from: viewController, config: config)
```

**Files:**
- `ios/Classes/ModdakirFlutterNSdk.swift`

## 🔧 Setup Instructions

### Android Setup

1. **Add GitHub credentials** to `~/.gradle/gradle.properties`:
   ```properties
   gpr.user=YOUR_GITHUB_USERNAME
   gpr.token=YOUR_GITHUB_TOKEN
   ```

2. **Build:**
   ```bash
   cd example
   flutter build apk --debug
   ```

### iOS Setup

1. **Verify SSH access:**
   ```bash
   ssh -T git@bitbucket.org
   # Should see: "authenticated via ssh key"
   ```

2. **Open in Xcode:**
   ```bash
   cd example/ios
   open Runner.xcworkspace
   ```

3. **Add Swift Package:**
   - File > Add Package Dependencies
   - URL: `https://github.com/Moddakir-App/moddakir-ios-n-sdk`
   - Version: `1.0.5`

4. **Update Info.plist:**
   ```xml
   <key>NSCameraUsageDescription</key>
   <string>Camera access is required for video calls</string>
   <key>NSMicrophoneUsageDescription</key>
   <string>Microphone access is required for calls</string>
   ```

5. **Run:**
   ```bash
   flutter run
   ```

## 📊 Comparison Table

| Feature | Android | iOS |
|---------|---------|-----|
| **SDK Source** | Maven (GitHub Packages) | Swift Package (GitHub) |
| **Dependencies** | Public | Private (Bitbucket SSH) |
| **Session API** | ✅ Required | ✅ Required |
| **sdkSessionId** | ✅ Used | ✅ Used |
| **User Info** | ❌ Not needed | ✅ Required |
| **SessionInfo** | ❌ Optional | ✅ Required |
| **Min Version** | Android 7.0 (API 24) | iOS 13.0 |
| **Language** | Kotlin 2.2.20 | Swift 5.9 |

## 🎨 Event Handling

Both platforms send events back to Flutter:

```dart
ModdakirFlutterNSdk.instance.callEvents.listen((event) {
  switch (event.type) {
    case 'onCallStateChanged':
      print('Call state: ${event.state}');
      break;
    case 'onCallReportSubmitted':
      print('Report submitted');
      break;
    case 'onPermissionDenied':
      print('Permissions denied');
      break;
    case 'onUnauthorizedAccess':
      print('Unauthorized');
      break;
  }
});
```

## 📝 API Reference

### Session API

**Endpoint:** `POST /auth/protected/sdk/session`

**Headers:**
```
Moddakir-ID: sdk_5
Moddakir-Key: YOUR_API_KEY
Content-Type: application/json
```

**Body:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "+1234567890",
  "gender": "male",
  "language": "ar",
  "sessionInfo": {
    "fromSurah": "البقرة",
    "fromAyah": "1",
    "toSurah": "البقرة",
    "toAyah": "50"
  }
}
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "sdkSessionId": "550e8400-e29b-41d4-a716-446655440000"
}
```

## 🔐 Security

- ✅ API credentials stored securely
- ✅ Session tokens expire
- ✅ SDK handles authentication internally
- ✅ No credentials stored in Flutter layer

## 🐛 Troubleshooting

### Android

**Build fails:**
- Check GitHub credentials in `gradle.properties`
- Verify Kotlin version: 2.2.20
- Clean build: `flutter clean`

**SDK doesn't launch:**
- Check logs for errors
- Verify session credentials
- Ensure Activity context is valid

### iOS

**Package resolution fails:**
- Test SSH: `ssh -T git@bitbucket.org`
- Load SSH key: `ssh-add ~/.ssh/id_ed25519`
- Reset package cache in Xcode

**Build fails:**
- Clean build folder (Cmd+Shift+K)
- Delete derived data
- Rebuild

**SDK doesn't launch:**
- Check Info.plist permissions
- Verify session credentials
- Check console logs

## 📚 Documentation Files

- `README.md` - Main documentation
- `SETUP.md` - General setup guide
- `IOS_SETUP.md` - iOS-specific setup
- `IOS_QUICK_START.md` - iOS quick start (5 min)
- `IOS_INTEGRATION_SUMMARY.md` - iOS implementation details
- `COMPLETE_INTEGRATION_GUIDE.md` - This file

## ✅ Checklist

### Android
- [x] SDK dependency configured
- [x] GitHub credentials set
- [x] Plugin implementation complete
- [x] Session API integration
- [x] Event callbacks
- [x] Build successful

### iOS
- [x] Swift Package setup documented
- [x] SSH access documented
- [x] Plugin implementation complete
- [x] Session API integration
- [x] Event callbacks
- [x] Info.plist permissions

### Flutter
- [x] Platform channel unified
- [x] Public API complete
- [x] Example app updated
- [x] Event stream working
- [x] Documentation complete

## 🚀 Next Steps

1. **Test on real devices**
   - Android: Test on API 24+
   - iOS: Test on iOS 13+

2. **Test all scenarios**
   - Voice calls
   - Video calls
   - Permission denied
   - Network errors
   - Different languages

3. **Production setup**
   - Update environment URLs
   - Test with production credentials
   - Verify all callbacks

4. **Publish plugin**
   - Update version
   - Update changelog
   - Publish to pub.dev

## 📞 Support

For issues or questions:
- Check console logs
- Review documentation
- Contact Moddakir team

---

**Version:** 1.0.5  
**Last Updated:** January 4, 2027  
**Platforms:** Android (API 24+), iOS (13.0+)
