# Publishing Guide - Moddakir Flutter Plugin

## Prerequisites

1. **GitHub Account** - للنشر على GitHub
2. **pub.dev Account** - للنشر على pub.dev (استخدم Google account)
3. **Git installed** - للتحكم بالإصدارات

## Part 1: النشر على GitHub

### 1. إنشاء Repository على GitHub

```bash
# افتح https://github.com/new
# اسم الـ repo: moddakir-flutter-n-sdk
# Description: Flutter plugin for Moddakir Call SDK
# Public repository
# لا تضيف README (موجود already)
```

### 2. Initialize Git و Push

```bash
cd "/Users/seif/Desktop/Moddakir Project/moddakir-flutter-n-sdk"

# Initialize git (if not already)
git init

# Add all files
git add .

# Commit
git commit -m "Initial release v1.0.0 - Moddakir Flutter Plugin"

# Add remote (استبدل YOUR_USERNAME باسم المستخدم بتاعك)
git remote add origin https://github.com/YOUR_USERNAME/moddakir-flutter-n-sdk.git

# Push
git branch -M main
git push -u origin main
```

### 3. Create Release Tag

```bash
# Create version tag
git tag v1.0.0

# Push tag
git push origin v1.0.0
```

### 4. Create GitHub Release

1. اذهب إلى: `https://github.com/YOUR_USERNAME/moddakir-flutter-n-sdk/releases/new`
2. اختر Tag: `v1.0.0`
3. Release title: `v1.0.0 - Initial Release`
4. Description: انسخ من `CHANGELOG.md`
5. اضغط "Publish release"

## Part 2: النشر على pub.dev

### 1. تحديث pubspec.yaml

**⚠️ مهم جداً:** استبدل `YOUR_USERNAME` في `pubspec.yaml`:

```yaml
homepage: https://github.com/YOUR_ACTUAL_USERNAME/moddakir-flutter-n-sdk
repository: https://github.com/YOUR_ACTUAL_USERNAME/moddakir-flutter-n-sdk
```

### 2. Verify Package

```bash
# Check package quality
flutter pub publish --dry-run
```

هذا الأمر سيفحص:
- ✅ Package structure
- ✅ pubspec.yaml validity
- ✅ Documentation
- ✅ License
- ⚠️ Warnings (إذا في)

### 3. Publish to pub.dev

```bash
# Publish (سيطلب منك تسجيل الدخول)
flutter pub publish
```

**الخطوات:**
1. سيفتح browser للتسجيل
2. سجل دخول بـ Google account
3. وافق على الـ permissions
4. ارجع للـ terminal واضغط Enter
5. سيتم رفع الـ package

### 4. Verify Publication

بعد النشر، افتح:
```
https://pub.dev/packages/moddakir_flutter_n_sdk
```

## Part 3: استخدام الـ Plugin في مشروع آخر

### في أي Flutter Project جديد:

#### 1. أضف الـ Dependency

في `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  moddakir_flutter_n_sdk: ^1.0.0
```

أو من GitHub مباشرة:

```yaml
dependencies:
  moddakir_flutter_n_sdk:
    git:
      url: https://github.com/YOUR_USERNAME/moddakir-flutter-n-sdk.git
      ref: v1.0.0
```

#### 2. Install

```bash
flutter pub get
```

#### 3. Configure Android

في `android/build.gradle` (project level):

```gradle
allprojects {
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("https://maven.pkg.github.com/Mibrahim511/moddakir-sdk-andorid")
            credentials {
                username = project.findProperty("gpr.user") ?: System.getenv("GITHUB_USERNAME")
                password = project.findProperty("gpr.token") ?: System.getenv("GITHUB_TOKEN")
            }
        }
    }
}
```

في `android/gradle.properties`:

```properties
gpr.user=your-github-username
gpr.token=your-github-token
```

**أو** استخدم environment variables:

```bash
export GITHUB_USERNAME=your-github-username
export GITHUB_TOKEN=your-github-token
```

**See `CREDENTIALS_SETUP.md` for detailed instructions on getting a GitHub token.**

#### 4. Use in Code

```dart
import 'package:flutter/material.dart';
import 'package:moddakir_flutter_n_sdk/moddakir_flutter_n_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize SDK
  await ModdakirFlutterNSdk.instance.initializeCallSDK();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CallScreen(),
    );
  }
}

class CallScreen extends StatefulWidget {
  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  void initState() {
    super.initState();
    
    // Listen to call events
    ModdakirFlutterNSdk.instance.callEvents.listen((event) {
      if (event is CallEndedEvent) {
        print('Call ended: ${event.state}, duration: ${event.duration}s');
      }
    });
  }

  Future<void> _startCall() async {
    final config = CallConfig(
      callId: 'call-123',
      userId: 'user-456',
      sessionId: 'session-789',
    );
    
    await ModdakirFlutterNSdk.instance.startCall(config);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Moddakir Call')),
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

## Part 4: Update Plugin (Future Versions)

### عند عمل تحديثات:

```bash
# 1. Update version in pubspec.yaml
# version: 1.0.1 (or 1.1.0, 2.0.0)

# 2. Update CHANGELOG.md
# Add new version section

# 3. Commit changes
git add .
git commit -m "Release v1.0.2 - Bug fixes"

# 4. Create tag
git tag v1.0.1
git push origin main
git push origin v1.0.1

# 5. Publish to pub.dev
flutter pub publish
```

## Important Notes

### ⚠️ قبل النشر على pub.dev

1. **تأكد من:**
   - ✅ Package name فريد (check على pub.dev)
   - ✅ Description واضح (min 60 characters)
   - ✅ Homepage/repository URLs صحيحة
   - ✅ LICENSE file موجود
   - ✅ README.md شامل
   - ✅ CHANGELOG.md محدث
   - ✅ Example app يشتغل

2. **لا تنشر:**
   - ❌ Credentials (GitHub tokens)
   - ❌ API keys
   - ❌ Private information

### 📝 Package Naming

إذا `moddakir_flutter_n_sdk` مأخوذ على pub.dev، استخدم:
- `moddakir_call_sdk`
- `moddakir_sdk`
- `moddakir_calls`

### 🔒 Security

**في الـ .gitignore:**
```
android/gradle.properties
android/local.properties
*.keystore
*.jks
```

## Verification Checklist

قبل النشر، تأكد:

- [ ] `flutter pub publish --dry-run` ينجح بدون errors
- [ ] Example app يشتغل على Android
- [ ] Documentation كامل
- [ ] GitHub repository public
- [ ] Version tag موجود
- [ ] CHANGELOG محدث
- [ ] No sensitive data في الكود

## Support & Maintenance

بعد النشر:

1. **Monitor Issues**: راقب GitHub issues
2. **Respond to Questions**: رد على الأسئلة
3. **Update Dependencies**: حدث الـ dependencies بانتظام
4. **Add Features**: أضف features جديدة
5. **Fix Bugs**: اصلح الـ bugs بسرعة

## Quick Commands Reference

```bash
# Check package
flutter pub publish --dry-run

# Publish to pub.dev
flutter pub publish

# Create git tag
git tag v1.0.0
git push origin v1.0.0

# Update in project
flutter pub upgrade moddakir_flutter_n_sdk
```

## Example pubspec.yaml for Users

```yaml
name: my_app
description: My Flutter app using Moddakir

environment:
  sdk: ^3.5.0

dependencies:
  flutter:
    sdk: flutter
  moddakir_flutter_n_sdk: ^1.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
```

---

**🎉 بعد النشر، الـ plugin بتاعك هيكون متاح لأي حد يستخدمه في أي Flutter project!**
