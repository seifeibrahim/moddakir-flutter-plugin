# iOS Quick Start (5 Minutes)

## ⚡ TL;DR

All code is ready. You just need to add one Swift Package in Xcode.

## 🚀 Steps

### 1. Open Xcode (30 seconds)

```bash
cd example
open ios/Runner.xcworkspace
```

### 2. Add Swift Package (2 minutes)

In Xcode:
1. Click **Runner** (blue icon) → **Package Dependencies** tab
2. Click **"+"**
3. Paste: `https://github.com/Moddakir-App/moddakir-ios-n-sdk`
4. Version: `1.0.0`
5. Click **"Add Package"**
6. Wait... (Xcode is fetching dependencies)
7. Select **ModdakirNativeSDK** → **"Add Package"**

### 3. Verify SSH (30 seconds)

```bash
ssh -T git@bitbucket.org
```

Should say: `authenticated via ssh key`

If not:
```bash
ssh-add ~/.ssh/id_ed25519
```

### 4. Run (2 minutes)

```bash
flutter clean
flutter run
```

## ✅ Done!

If it builds without errors, you're all set! 🎉

---

**Having issues?** See `IOS_FINAL_SETUP.md` for detailed troubleshooting.
