# iOS Quick Start Guide

## 🚀 5-Minute Setup

### Step 1: Verify SSH Access (1 min)

```bash
# Test Bitbucket SSH connection
ssh -T git@bitbucket.org
```

**Expected output:** `authenticated via ssh key`

**If failed:**
```bash
# Load your SSH key
ssh-add ~/.ssh/id_ed25519

# Test again
ssh -T git@bitbucket.org
```

### Step 2: Open Project in Xcode (1 min)

```bash
cd example/ios
open Runner.xcworkspace
```

**Important:** Open `.xcworkspace`, NOT `.xcodeproj`!

### Step 3: Add Swift Package (2 min)

1. In Xcode: **File > Add Package Dependencies**
2. Enter URL: `https://github.com/Moddakir-App/moddakir-ios-n-sdk`
3. Version: `1.0.0`
4. Click **Add Package**
5. Wait for Xcode to resolve dependencies (may take 1-2 minutes)

**Note:** Xcode will automatically fetch private Bitbucket dependencies using your SSH key.

### Step 4: Update Info.plist (30 sec)

Add these permissions to `Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required for video calls</string>
<key>NSMicrophoneUsageDescription</key>
<string>Microphone access is required for calls</string>
```

### Step 5: Update Podfile (30 sec)

In `ios/Podfile`, ensure minimum iOS version:

```ruby
platform :ios, '13.0'
```

Then run:
```bash
cd ios
pod install
```

### Step 6: Run! (1 min)

```bash
cd ..
flutter run
```

## ✅ Verification

If everything is set up correctly:

1. ✅ App builds without errors
2. ✅ You can tap "Start Audio Call"
3. ✅ Session API call succeeds
4. ✅ SDK UI launches

## 🔥 Common Issues

### Issue: "Permission denied (publickey)"

**Solution:**
```bash
ssh-add ~/.ssh/id_ed25519
ssh -T git@bitbucket.org
```

### Issue: "Package resolution failed"

**Solution:**
1. Xcode > File > Packages > Reset Package Caches
2. Xcode > File > Packages > Update to Latest Package Versions
3. Try adding package again

### Issue: "Module 'ModdakirNativeSDK' not found"

**Solution:**
1. Clean build: Cmd+Shift+K
2. Delete derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData`
3. Rebuild: Cmd+B

### Issue: Build succeeds but SDK doesn't launch

**Solution:**
Check console logs for errors. Common causes:
- Missing Info.plist permissions
- Invalid session credentials
- Network connectivity issues

## 📱 Test Flow

```dart
// 1. Get session from API
final sessionData = await SessionApi.getSdkSession(...);

// 2. Start SDK with session ID
await ModdakirFlutterPlugin.instance.startCallSession(
  sdkSessionId: sessionData['sdkSessionId'],
  sessionInfo: {
    'fromSurah': '1',
    'toSurah': '2',
    'fromAyah': '1',
    'toAyah': '50',
    'pathType': 'initiation',
    'notes': 'Test'
  },
  ...
);

// 3. SDK UI launches! 🎉
```

## 🎯 Next Steps

- Test voice calls
- Test video calls
- Test different languages (ar/en)
- Test permission denied scenarios
- Implement event listeners

## 📞 Support

If you encounter issues:
1. Check console logs in Xcode
2. Verify SSH access to Bitbucket
3. Ensure all dependencies are resolved
4. Contact Moddakir team if needed
