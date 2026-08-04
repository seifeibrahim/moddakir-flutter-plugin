# ✅ API Integration Complete

## 🎯 تم إضافة الـ APIs من Android Example

تم نقل كل الـ APIs من Android example إلى Flutter example بنفس الـ structure.

## 📁 الملفات المُنشأة

### 1. Data Models

#### Request Models
- ✅ `sdk_login_request.dart` - Login to SDK request
- ✅ `create_call_request.dart` - Create call request
- ✅ `update_call_request.dart` - Update call log request

#### Response Models
- ✅ `sdk_login_response.dart` - Login response with Consumer
- ✅ `random_provider_response.dart` - Random teacher response
- ✅ `create_call_response.dart` - Call creation response with tokens

### 2. Data Source

#### `call_api_service.dart`
HTTP client for all API calls:

**Endpoints:**
```dart
// POST /auth/protected/sdk/login
Future<SdkLoginResponse> sdkLogin(SdkLoginRequest)

// GET /core/private/provider/random
Future<RandomProviderResponse> getRandomProvider()

// POST /call/private/create-call
Future<CreateCallResponse> createCall(CreateCallRequest)

// POST /call/private/update-call-log
Future<void> updateCall(UpdateCallRequest)

// POST /call/private/join-agora-signaling
Future<void> joinAgoraSignaling({channelName, voip, huawei})
```

### 3. Updated CallFlowManager

الآن الـ CallFlowManager يستخدم الـ APIs الحقيقية:

**Flow:**
```
1. Login to SDK
   ↓
2. Get Random Teacher
   ↓
3. Create Call
   ↓
4. Start Call (SDK)
   ↓
5. Update Call Log (on end)
```

## 🔄 Complete API Flow

### Step 1: SDK Login
```dart
POST /auth/protected/sdk/login
Body: {
  "fullName": "mariam Omar",
  "email": "m.omar@moddakir.com",
  "phone": "+201099034061",
  "gender": "male",
  "callType": "video",
  "startDate": "2026-08-02T03:35:00.000Z",
  "sessionInfo": {...},
  "metaData": {...}
}

Response: {
  "accessToken": "eyJhbGc...",
  "consumer": {
    "id": "consumer-123",
    "fullName": "mariam Omar",
    "phone": "+201099034061",
    ...
  },
  "sdkSessionId": "session-456"
}
```

### Step 2: Get Random Teacher
```dart
GET /core/private/provider/random
Headers: {
  "Authorization": "Bearer eyJhbGc..."
}

Response: {
  "id": "teacher-789",
  "fullName": "Ahmed Mohamed",
  "avatarUrl": "https://...",
  "status": "AVAILABLE",
  ...
}
```

### Step 3: Create Call
```dart
POST /call/private/create-call
Headers: {
  "Authorization": "Bearer eyJhbGc..."
}
Body: {
  "consumerId": "consumer-123",
  "providerId": "teacher-789",
  "consumerName": "mariam Omar",
  "providerName": "Ahmed Mohamed",
  "status": "INITIATE",
  "consumerCountry": "EG",
  "consumerAvatarUrl": "https://...",
  "providerAvatarUrl": "https://...",
  "callProviderType": "agora",
  "callType": "Voice"
}

Response: {
  "call": {
    "id": "call-abc123",
    "consumerId": "consumer-123",
    "providerId": "teacher-789",
    "status": "INITIATE"
  },
  "callApiKey": "agora-key",
  "callApiCertificate": "agora-cert",
  "hostRtcToken": "rtc-token-host",
  "guestRtcToken": "rtc-token-guest",
  "hostRtmToken": "rtm-token-host",
  "guestRtmToken": "rtm-token-guest",
  "callProviderType": "agora",
  "channelName": "channel-xyz"
}
```

### Step 4: Start Call (SDK)
```dart
final callConfig = CallConfig(
  callId: "call-abc123",
  userId: "consumer-123",
  sessionId: "session-456",
);

await ModdakirFlutterPlugin.instance.startCall(callConfig);
```

### Step 5: Update Call Log (on end)
```dart
POST /call/private/update-call-log
Headers: {
  "Authorization": "Bearer eyJhbGc..."
}
Body: {
  "callId": "call-abc123",
  "status": "HUNG_UP",
  "endDateTime": "2026-08-02T03:45:00.000Z",
  "duration": 600,
  "isHangupByTeacher": false,
  "isHangupByStudent": false,
  "isPackageEnded": false,
  "isSilenceTimeout": false
}
```

## 🎨 Architecture

```
CallScreen (UI)
    ↓
CallProvider (State Management)
    ↓
CallFlowManager (Business Logic)
    ↓
CallApiService (HTTP Client)
    ↓
API Endpoints
```

## 📊 State Machine with APIs

```
IDLE
  ↓ startSession()
  ↓ → API: Login to SDK
SEARCHING (1/3)
  ↓ → API: Get Random Teacher
  ↓ (if found)
  ↓ → API: Create Call
READY_TO_CALL
  ↓ → SDK: Start Call
CALLING
  ↓ (call ends)
  ↓ → API: Update Call Log
ENDED
```

## 🔧 Error Handling

### Network Errors
```dart
try {
  final response = await _apiService.sdkLogin(request);
} catch (e) {
  debugPrint('Login error: $e');
  _updateState(EndedState(reason: EndReason.networkError));
}
```

### Retry Logic
- **Teacher not found:** Retry up to 3 times (10s interval)
- **Teacher rejected:** Update call log, retry next teacher
- **Network error:** End with network error state

## 📝 API Response Models

### Consumer (from Login)
```dart
class Consumer {
  final String id;
  final String? username;
  final String? gender;
  final String? email;
  final String? fullName;
  final String? phone;
  final String? avatarUrl;
  final String? country;
  // ... more fields
}
```

### RandomProvider (Teacher)
```dart
class RandomProviderResponse {
  final String id;
  final String username;
  final String fullName;
  final String phone;
  final String avatarUrl;
  final String status;
  // ... more fields
}
```

### CreateCallResponse
```dart
class CreateCallResponse {
  final Call call;              // Call info
  final String callApiKey;      // Agora API key
  final String channelName;     // Agora channel
  final String hostRtcToken;    // RTC tokens
  final String guestRtcToken;
  final String hostRtmToken;    // RTM tokens
  final String guestRtmToken;
}
```

## 🔐 Authentication

الـ API service يحفظ الـ access token بعد الـ login:

```dart
_loginResponse = await _login();
_apiService.setAccessToken(_loginResponse!.accessToken);
```

وبعدين كل الـ requests تستخدم الـ token:

```dart
Map<String, String> get _headers => {
  'Content-Type': 'application/json',
  if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
};
```

## 🎯 Usage Example

```dart
// في CallProvider
Future<void> startCall(CallType type) async {
  final sessionInput = SessionInput(
    name: _user.name,
    gender: _user.gender,
    phone: _user.phone,
    email: _user.email,
    language: _user.language,
    callType: type.name,
    isDark: _themeMode == ThemeMode.dark,
  );

  // هيعمل كل الـ API calls automatically:
  // 1. Login
  // 2. Get teacher
  // 3. Create call
  // 4. Start call
  // 5. Update on end
  await _flowManager.startSession(sessionInput);
}
```

## 📦 Dependencies

```yaml
dependencies:
  http: ^1.2.0  # For API calls
  provider: ^6.1.2  # State management
```

## 🚀 Configuration

لتغيير الـ base URL:

```dart
// في call_api_service.dart
static const String baseUrl = 'https://api.moddakir.com';
```

## ✅ Checklist

- [x] SDK Login API
- [x] Get Random Teacher API
- [x] Create Call API
- [x] Update Call Log API
- [x] Join Agora Signaling API
- [x] Request/Response models
- [x] HTTP client with auth
- [x] Error handling
- [x] Integration with CallFlowManager
- [x] Automatic retry logic
- [x] Call log updates

---

**🎉 كل الـ APIs من Android تم نقلها بنجاح إلى Flutter!**

الـ example app الآن يستخدم الـ APIs الحقيقية بدل الـ mock data.
