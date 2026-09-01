# iOS Setup - REQUIRED STEPS

## ⚠️ Important: Manual Swift Package Setup Required

Due to CocoaPods limitations with Swift Package Manager, you **must** manually add the iOS SDK to your Xcode project.

## 📋 One-Time Setup (Required for all users)

### Step 1: Verify SSH Access to Bitbucket

The SDK has private dependencies on Bitbucket. Test your SSH access:

```bash
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

### Step 2: Open Your iOS Project in Xcode

```bash
cd your_flutter_project
open ios/Runner.xcworkspace
```

**Important:** Open `.xcworkspace`, NOT `.xcodeproj`!

### Step 3: Add Swift Package Dependency

1. In Xcode, click on **Runner** project (blue icon in sidebar)
2. Select the **Runner** project (not target)
3. Go to **"Package Dependencies"** tab
4. Click **"+"** button at the bottom
5. Enter package URL:
   ```
   https://github.com/Moddakir-App/moddakir-ios-n-sdk
   ```
6. Select version: **1.0.5** (or "Up to Next Major Version" from 1.0.5)
7. Click **"Add Package"**
8. Wait for Xcode to resolve dependencies (may take 1-2 minutes)
9. When prompted, select **ModdakirNativeSDK** and click **"Add Package"**

### Step 4: Update Info.plist

Add required permissions to `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required for video calls</string>
<key>NSMicrophoneUsageDescription</key>
<string>Microphone access is required for calls</string>
```

### Step 5: Build Your Project

```bash
flutter clean
flutter pub get
flutter run
```

## ✅ Verification

If setup is correct:
- ✅ Project builds without errors
- ✅ No "Module 'ModdakirNativeSDK' not found" errors
- ✅ SDK UI launches when you call `startCallSession()`

## 🐛 Troubleshooting

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
3. Try adding package again

### Error: "Module 'ModdakirNativeSDK' not found"

**Solution:**
1. Verify package is added in Xcode (Package Dependencies tab)
2. Clean build: **Product > Clean Build Folder** (Cmd+Shift+K)
3. Delete derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData`
4. Rebuild: **Product > Build** (Cmd+B)

## 📝 Why Manual Setup?

CocoaPods doesn't support Swift Package Manager dependencies. The iOS SDK is distributed as a Swift Package on GitHub with private Bitbucket dependencies, so it cannot be automatically included via the `.podspec` file.

This is a **one-time setup** per project. Once added, all team members with Bitbucket SSH access can build the project.

## 🔗 Links

- iOS SDK: https://github.com/Moddakir-App/moddakir-ios-n-sdk
- Bitbucket SSH Setup: https://support.atlassian.com/bitbucket-cloud/docs/set-up-an-ssh-key/
