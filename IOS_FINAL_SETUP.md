# iOS Integration - Final Setup Guide

## ✅ Current Status

All code is ready! You just need to **add the Swift Package manually** in Xcode.

## 📋 What's Already Done

### ✅ 1. iOS Plugin Code
- `ios/Classes/ModdakirFlutterPlugin.swift` - Complete implementation
- Handles `startCallSession` with all required parameters
- Implements `ModdakirSDKDelegate` callbacks
- Event channel for SDK events

### ✅ 2. Platform Channel
- `lib/src/platform/moddakir_platform_channel.dart` - Updated with `token` and `theme`
- `lib/moddakir_flutter_plugin.dart` - Public API updated

### ✅ 3. Example App
- `example/lib/features/call/presentation/screens/simple_call_screen.dart`
- Passes `token` and `sdkSessionId` from Session API

### ✅ 4. Permissions
- `example/ios/Runner/Info.plist` - Camera and Microphone permissions added

### ✅ 5. Documentation
- `README_IOS_SETUP.md` - Detailed setup guide
- `README.md` - Updated with iOS instructions
- `ios/moddakir_flutter_plugin.podspec` - Clear warning about manual setup

## 🚀 What You Need to Do (One-Time Setup)

### Step 1: Open Xcode

```bash
cd example
open ios/Runner.xcworkspace
```

**Important:** Open `.xcworkspace`, NOT `.xcodeproj`!

### Step 2: Add Swift Package

1. In Xcode, click on **Runner** project (blue icon in left sidebar)
2. Select the **Runner** project (not target)
3. Go to **"Package Dependencies"** tab
4. Click **"+"** button at the bottom
5. Enter package URL:
   ```
   https://github.com/Moddakir-App/moddakir-ios-n-sdk
   ```
6. Select version: **1.0.0** (or "Up to Next Major Version" from 1.0.0)
7. Click **"Add Package"**
8. Wait for Xcode to resolve dependencies (1-2 minutes)
9. When prompted, select **ModdakirNativeSDK** and click **"Add Package"**

### Step 3: Verify SSH Access

The SDK has private Bitbucket dependencies. Test your SSH:

```bash
ssh -T git@bitbucket.org
```

**Expected:** `authenticated via ssh key`

**If failed:**
```bash
ssh-add ~/.ssh/id_ed25519
ssh -T git@bitbucket.org
```

### Step 4: Build & Run

```bash
flutter clean
flutter run
```

## 🎯 Expected Flow

```
1. User calls Session API
   POST /auth/protected/sdk/session
   ← {token: "...", sdkSessionId: "..."}

2. User calls plugin.startCallSession(
     token: "...",           // ← From API
     sdkSessionId: "...",    // ← From API
     appName: "...",
     sessionInfo: {...}
   )

3. iOS Plugin creates SDKConfig with:
   - accessToken (required)
   - sdkSessionId (required)
   - appName (required)
   - sessionInfo, user data, etc.

4. Calls SDKManager.shared.start(config)

5. SDK UI launches! 🎉
```

## 🐛 Troubleshooting

### Error: "Module 'ModdakirNativeSDK' not found"

**Solution:** You haven't added the Swift Package yet. Follow Step 2 above.

### Error: "Permission denied (publickey)"

**Solution:**
```bash
ssh-add ~/.ssh/id_ed25519
ssh -T git@bitbucket.org
```

### Error: "Unable to resolve package dependencies"

**Solution:**
1. In Xcode: **File > Packages > Reset Package Caches**
2. **File > Packages > Update to Latest Package Versions**
3. Clean build: **Product > Clean Build Folder** (Cmd+Shift+K)
4. Try again

### Build is slow or stuck

**Solution:**
```bash
# Clean everything
flutter clean
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# Rebuild
flutter run
```

## 📝 Why Manual Setup?

**CocoaPods doesn't support Swift Package Manager dependencies.**

The iOS SDK is distributed as a Swift Package on GitHub with private Bitbucket dependencies. It cannot be automatically included via the `.podspec` file.

This is a **one-time setup** per project. Once added, all team members with Bitbucket SSH access can build the project.

## ✅ Verification Checklist

- [ ] Opened `ios/Runner.xcworkspace` in Xcode
- [ ] Added Swift Package: `https://github.com/Moddakir-App/moddakir-ios-n-sdk`
- [ ] SSH access to Bitbucket verified
- [ ] Project builds without errors
- [ ] No "Module 'ModdakirNativeSDK' not found" errors
- [ ] SDK UI launches when calling `startCallSession()`

## 🎉 You're Done!

Once the Swift Package is added, the integration is complete!

The plugin will work exactly like Android:
- Call Session API to get credentials
- Pass credentials to `startCallSession()`
- SDK handles everything else

---

**Need help?** Check `README_IOS_SETUP.md` for more details.
