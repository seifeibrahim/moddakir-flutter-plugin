# Android Architecture Implementation in Flutter

## ✅ تم تطبيق الـ Architecture من Android في Flutter Example

تم دراسة الكود في:
```
/Users/seif/Desktop/moddakir-sdk-andorid-feature-call-flow-manager/app/src/main/java/com/example/sdksample/feature/call
```

وتطبيق نفس الـ pattern في Flutter example.

## 📁 الملفات المُنشأة

### 1. Domain Entities

#### `call_flow_state.dart`
State machine states مثل Android:
- `IdleState` - Ready to start
- `SearchingState` - Searching for teacher (with attempt/maxAttempts)
- `ReadyToCallState` - Found teacher, ready to call
- `CallingState` - In active call
- `EndedState` - Call ended with reason

#### `end_reason.dart` (في call_flow_state.dart)
```dart
enum EndReason {
  completed,      // Call finished successfully
  noTeachers,     // No teachers available
  canceled,       // User canceled
  networkError,   // Network issue
  serverError,    // Server error
}
```

#### `session_input.dart`
Session configuration (مثل Android SessionInput):
```dart
class SessionInput {
  final String? requestId;
  final String? name;
  final String? gender;
  final String? email;
  final String? phone;
  final String? language;
  final String? appName;
  final String? apiKey;
  final int? callDuration;
  final String? callType;
  final bool? isDark;
  final int? primaryColor;
  final Map<String, dynamic>? metaData;
  final SessionInfo? sessionInfo;
}
```

#### `session_info.dart`
```dart
class SessionInfo {
  final String? title;
  final String? description;
  final Map<String, dynamic>? metadata;
}
```

### 2. Presentation Manager

#### `call_flow_manager.dart`
State machine manager (مثل Android CallFlowManager):

**Features:**
- ✅ Singleton pattern
- ✅ State machine: `IDLE → SEARCHING → READY_TO_CALL → CALLING → ENDED`
- ✅ Retry logic with attempts (default 3 attempts, 10 seconds interval)
- ✅ Stream-based state updates
- ✅ Call events listening
- ✅ Automatic retry on teacher rejection/no answer

**Key Methods:**
```dart
void init()                                    // Initialize manager
Future<void> startSession(SessionInput)        // Start call flow
void markCalling()                             // Mark as in-call
void reset()                                   // Reset to idle
void _onCallEnded(CallEndedEvent)             // Handle call end
```

**State Flow:**
```
IDLE 
  ↓ startSession()
SEARCHING (attempt 1/3)
  ↓ teacher found
READY_TO_CALL
  ↓ markCalling()
CALLING
  ↓ call ends
ENDED (with reason)
  OR
  ↓ no answer/denied
SEARCHING (attempt 2/3)
  ... retry loop ...
```

### 3. Updated CallProvider

**Changes:**
- ✅ Uses `CallFlowManager` instead of direct SDK calls
- ✅ Listens to flow state changes
- ✅ Updates UI based on state
- ✅ Handles loading states automatically
- ✅ Shows search progress (attempt/maxAttempts)

**State Handling:**
```dart
void _handleFlowState(CallFlowState state) {
  if (state is IdleState) {
    _status = 'Ready';
    _isLoading = false;
  } else if (state is SearchingState) {
    _status = '🔍 Searching... (${state.attempt}/${state.maxAttempts})';
    _isLoading = true;
  } else if (state is ReadyToCallState) {
    _status = '📞 Ready to call';
  } else if (state is CallingState) {
    _status = '📞 In call...';
  } else if (state is EndedState) {
    _status = state.reason.message;
    _isLoading = false;
  }
}
```

## 🔄 Architecture Comparison

### Android (Original)
```
MainActivity
    ↓
CallViewModel
    ↓
CallFlowManager (State Machine)
    ↓
UseCases (Login, GetRandomTeacher, CreateCall)
    ↓
Repository
    ↓
DataSource (API)
```

### Flutter (Implemented)
```
CallScreen
    ↓
CallProvider (ChangeNotifier)
    ↓
CallFlowManager (State Machine)
    ↓
ModdakirFlutterNSdk
    ↓
Platform Channel
    ↓
Native SDK
```

## 🎯 Key Features Implemented

### 1. State Machine Pattern ✅
- Idle → Searching → ReadyToCall → Calling → Ended
- Same flow as Android

### 2. Retry Logic ✅
- Max 3 attempts by default
- 10 second interval between attempts
- Automatic retry on teacher rejection

### 3. Call Event Handling ✅
- Listens to `CallEndedEvent`
- Handles different end states:
  - `no_answer` / `denied` → retry
  - `hung_up` / `completed` → end successfully
  - `canceled` → end with canceled reason

### 4. Session Configuration ✅
- Full session input with all parameters
- Support for dark/light theme
- Custom colors and metadata
- Session info for call details

### 5. Clean Architecture ✅
```
example/lib/features/call/
├── domain/
│   ├── entities/
│   │   ├── call_flow_state.dart       ✅ NEW
│   │   ├── session_input.dart         ✅ NEW
│   │   └── session_info.dart          ✅ NEW
│   └── models/
│       └── call_user.dart
└── presentation/
    ├── manager/
    │   └── call_flow_manager.dart     ✅ NEW
    ├── providers/
    │   └── call_provider.dart         ✅ UPDATED
    ├── screens/
    │   └── call_screen.dart
    └── widgets/
        ├── call_button.dart
        └── call_text_field.dart
```

## 📊 State Flow Example

### Scenario: Call Random Teacher

1. **User taps "CALL RANDOM TEACHER"**
   ```
   State: IdleState
   Status: "Ready"
   ```

2. **Manager starts searching**
   ```
   State: SearchingState(attempt: 1, maxAttempts: 3)
   Status: "🔍 Searching... (1/3)"
   Loading: true
   ```

3. **Teacher found**
   ```
   State: ReadyToCallState
   Status: "📞 Ready to call"
   → Automatically starts call
   ```

4. **Call started**
   ```
   State: CallingState
   Status: "📞 In call..."
   ```

5. **Call ended successfully**
   ```
   State: EndedState(reason: EndReason.completed)
   Status: "Call completed successfully"
   Loading: false
   ```

### Scenario: No Teacher Available (with retry)

1. **Attempt 1** - No teacher
   ```
   SearchingState(1/3) → wait 10s
   ```

2. **Attempt 2** - No teacher
   ```
   SearchingState(2/3) → wait 10s
   ```

3. **Attempt 3** - No teacher
   ```
   SearchingState(3/3) → max attempts reached
   ```

4. **Give up**
   ```
   EndedState(reason: EndReason.noTeachers)
   Status: "No teachers available"
   ```

## 🔧 Usage in UI

```dart
// In CallProvider
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

  await _flowManager.startSession(sessionInput);
}

// UI automatically updates based on state changes
```

## 🎨 UI Updates

The UI now shows:
- ✅ Search progress: "🔍 Searching... (1/3)"
- ✅ Ready state: "📞 Ready to call"
- ✅ In-call state: "📞 In call..."
- ✅ End reasons: "Call completed successfully", "No teachers available", etc.
- ✅ Loading indicators during search/call

## 🚀 Benefits

1. **Separation of Concerns**
   - UI logic separated from business logic
   - State machine handles all flow logic
   - Provider just updates UI

2. **Testability**
   - State machine can be tested independently
   - Mock states for UI testing
   - Clear state transitions

3. **Maintainability**
   - Easy to add new states
   - Clear flow logic
   - Matches Android architecture

4. **Reliability**
   - Automatic retry logic
   - Proper error handling
   - State consistency

## 📝 Next Steps

To complete the implementation:

1. **Add API Integration**
   - Login API call
   - Get random teacher API
   - Create call log API
   - Update call API

2. **Add More States**
   - `ConnectingState` - Connecting to teacher
   - `RingingState` - Teacher phone ringing
   - `WaitingState` - Waiting for teacher to join

3. **Add Permissions**
   - Camera permission
   - Microphone permission
   - Notification permission

4. **Add Error Recovery**
   - Network error retry
   - Server error handling
   - Permission denied handling

---

**✅ Architecture successfully implemented matching Android pattern!**
