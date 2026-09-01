# iOS Setup Guide

## Prerequisites

The Moddakir iOS SDK has private dependencies on Bitbucket that require SSH access.

### Required Access

You need access to the following private Bitbucket repositories:
- `git@bitbucket.org:moddakir-workspace/moddakir_utils.git`
- `git@bitbucket.org:moddakir-workspace/moddakir_network.git`
- `git@bitbucket.org:moddakir-workspace/ios_call_module.git`

### SSH Key Setup

The Moddakir team SSH key for Bitbucket:
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBm+LjZdgYoUW04VHiPMiJPSDr44FJe74RsnpEoeBX4I a.abdallah@moddakir.com
```

**Note:** This key should already be configured in your Bitbucket account. If not, contact the Moddakir team.

## Installation Steps

### 1. Add Swift Package to Your iOS Project

1. Open your iOS project in Xcode: `example/ios/Runner.xcworkspace`
2. Go to **File > Add Package Dependencies**
3. Enter the repository URL: `https://github.com/Moddakir-App/moddakir-ios-n-sdk`
4. Select version: `1.0.5`
5. Click **Add Package**

**Note:** Xcode will automatically fetch the dependencies from Bitbucket using your SSH credentials.

### 2. Update Info.plist

Add the following permissions to your `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required for video calls</string>
<key>NSMicrophoneUsageDescription</key>
<string>Microphone access is required for calls</string>
```

### 3. Set Minimum iOS Version

Ensure your iOS deployment target is **iOS 13.0** or higher:

1. Open `ios/Podfile`
2. Uncomment and update: `platform :ios, '13.0'`
3. Run `pod install` in the `ios` directory

## Usage

The plugin is now ready to use! See the main README for Flutter usage examples.

## Troubleshooting

### SSH Key Issues

If you get authentication errors when Xcode tries to fetch dependencies:

```bash
# 1. Test SSH connection to Bitbucket
ssh -T git@bitbucket.org
# Should see: "authenticated via ssh key"

# 2. If authentication fails, ensure your SSH key is loaded
ssh-add -l
# Should show: ssh-ed25519 ... a.abdallah@moddakir.com

# 3. If key is not loaded, add it
ssh-add ~/.ssh/id_ed25519
# Or wherever your private key is stored

# 4. Test again
ssh -T git@bitbucket.org
```

**Common Issues:**
- **"Permission denied"**: Your SSH key is not added to Bitbucket or not loaded in ssh-agent
- **"Host key verification failed"**: Add Bitbucket to known hosts: `ssh-keyscan bitbucket.org >> ~/.ssh/known_hosts`

### Build Errors

If you encounter build errors:

1. Clean build folder: **Product > Clean Build Folder** (Cmd+Shift+K)
2. Delete derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData`
3. Run `pod install` again
4. Rebuild the project

### Package Resolution Issues

If Swift Package Manager fails to resolve dependencies:

1. Go to **File > Packages > Reset Package Caches**
2. Go to **File > Packages > Update to Latest Package Versions**
3. Rebuild the project
