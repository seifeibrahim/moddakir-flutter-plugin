package com.moddakir.moddakir_flutter_plugin

import android.app.Activity
import android.content.Context
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
// import com.moddakir.callslib.core.CallsApp // TODO: Find correct package in SDK 1.0.24
import com.moddakir.moddakir_flutter_plugin.core.CallFlutterManager
import com.moddakir.moddakir_flutter_plugin.core.SdkCallbackManager
import com.moddakir.moddakir_flutter_plugin.core.SdkPreferences
import com.moddakir.moddakir_flutter_plugin.core.call.FlutterCallFlowManager
import com.moddakir.moddakir_flutter_plugin.core.listeners.CallListenersSetup
import com.example.sdksample.feature.call.domain.entity.CallType

/** ModdakirFlutterPlugin */
class ModdakirFlutterPlugin: FlutterPlugin, MethodCallHandler, ActivityAware, EventChannel.StreamHandler {
  companion object {
    private const val TAG = "ModdakirPlugin"
  }
  private lateinit var methodChannel: MethodChannel
  private lateinit var eventChannel: EventChannel
  private var activity: Activity? = null
  private var context: Context? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    Log.d(TAG, "🔌 Plugin attached to engine")
    context = flutterPluginBinding.applicationContext
    
    methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "moddakir_flutter_plugin")
    methodChannel.setMethodCallHandler(this)
    Log.d(TAG, "✅ Method channel initialized")
    
    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "moddakir_flutter_plugin/events")
    eventChannel.setStreamHandler(this)
    Log.d(TAG, "✅ Event channel initialized")
    
    try {
      CallFlutterManager.init(flutterPluginBinding.applicationContext as android.app.Application)
      Log.d(TAG, "✅ CallFlutterManager initialized")
      
      CallListenersSetup.setupAllListeners()
      Log.d(TAG, "✅ Call listeners setup complete")
    } catch (e: Exception) {
      Log.e(TAG, "❌ Error during initialization", e)
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    Log.d(TAG, "📥 Method call received: ${call.method}")
    when (call.method) {
      "getPlatformVersion" -> {
        val version = "Android ${android.os.Build.VERSION.RELEASE}"
        Log.d(TAG, "📱 Platform version: $version")
        result.success(version)
      }
      "initializeCallSDK" -> {
        initializeCallSDK(call, result)
      }
      "startCallSession" -> {
        startCallSession(call, result)
      }
      else -> {
        Log.w(TAG, "⚠️ Method not implemented: ${call.method}")
        result.notImplemented()
      }
    }
  }
  
  private fun initializeCallSDK(call: MethodCall, result: Result) {
    Log.d(TAG, "🔧 Initializing Call SDK...")
    try {
      val appContext = context ?: run {
        Log.e(TAG, "❌ Application context not available")
        result.error("NO_CONTEXT", "Application context not available", null)
        return
      }
      
      Log.d(TAG, "📤 Initializing FlutterCallFlowManager...")
      FlutterCallFlowManager.init(appContext)
      
      Log.d(TAG, "✅ Call SDK initialized successfully")
      result.success(true)
    } catch (e: Exception) {
      Log.e(TAG, "❌ Error initializing SDK", e)
      result.error("INIT_ERROR", e.message, null)
    }
  }
  
  private fun startCallSession(call: MethodCall, result: Result) {
    Log.d(TAG, "📞 Starting call session...")
    Log.d(TAG, "   Arguments: ${call.arguments}")
    
    try {
      val name = call.argument<String>("name") ?: ""
      val email = call.argument<String>("email") ?: ""
      val phone = call.argument<String>("phone") ?: ""
      val gender = call.argument<String>("gender") ?: "male"
      val language = call.argument<String>("language") ?: "en"
      val appName = call.argument<String>("appName") ?: ""
      val apiKey = call.argument<String>("apiKey") ?: ""
      val callType = when (
        call.argument<String>("callType")?.lowercase()
      ) {
        "video" -> CallType.Video
        "voice" -> CallType.Voice
        else -> CallType.Voice
      }
      val isDark = call.argument<Boolean>("isDark") ?: false
      val primaryColor = call.argument<Int>("primaryColor")
      val secondaryColor = call.argument<Int>("secondaryColor")
      val sessionInfo = call.argument<Map<String, Any>>("sessionInfo")
      
      Log.d(TAG, "📋 Session parameters:")
      Log.d(TAG, "   name: $name")
      Log.d(TAG, "   email: $email")
      Log.d(TAG, "   phone: $phone")
      Log.d(TAG, "   gender: $gender")
      Log.d(TAG, "   language: $language")
      Log.d(TAG, "   appName: $appName")
      Log.d(TAG, "   apiKey: ${apiKey.take(10)}...")
      Log.d(TAG, "   callType: $callType")
      Log.d(TAG, "   isDark: $isDark")
      
      val appContext = context ?: run {
        Log.e(TAG, "❌ Application context not available")
        result.error("NO_CONTEXT", "Application context not available", null)
        return
      }
      
      // Get token and sdkSessionId from root arguments
      val token = call.argument<String>("token")
      val sdkSessionId = call.argument<String>("sdkSessionId")
      
      if (token != null && sdkSessionId != null) {
        // Store in memory for quick access
        SdkCallbackManager.setSessionCredentials(
          token = token,
          sdkSessionId = sdkSessionId
        )
        
        // Store in SharedPreferences so SDK can access it
        SdkPreferences.setAccessToken(appContext, token)
        SdkPreferences.setSdkSessionId(appContext, sdkSessionId)
        
        Log.d(TAG, "✅ Credentials stored: token=${token.take(20)}..., sdkSessionId=$sdkSessionId")
      } else {
        Log.e(TAG, "❌ Token or SDK Session ID is null!")
      }
      
      Log.d(TAG, "✅ Session credentials ready for SDK")
      Log.d(TAG, "💡 Preparing credentials for SDK...")
      
      // Prepare credentials
      FlutterCallFlowManager.prepareCredentials()
      
      // Get current activity
      val currentActivity = activity ?: run {
        Log.e(TAG, "❌ Activity not available")
        result.error("NO_ACTIVITY", "Activity not available", null)
        return
      }
      
      // Start SDK call flow
      Log.d(TAG, "🚀 Launching SDK call flow...")
      FlutterCallFlowManager.startSdkCall(
        activity = currentActivity,
        language = language,
        callType = callType,
        isDark = isDark,
        primaryColor = primaryColor
      )
      
      Log.d(TAG, "✅ SDK call flow launched!")
      result.success(true)
    } catch (e: Exception) {
      Log.e(TAG, "❌ Error starting call session", e)
      result.error("CALL_ERROR", e.message, null)
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    Log.d(TAG, "🔌 Plugin detached from engine")
    methodChannel.setMethodCallHandler(null)
    eventChannel.setStreamHandler(null)
  }
  
  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    Log.d(TAG, "🎯 Activity attached: ${binding.activity}")
    activity = binding.activity
  }
  
  override fun onDetachedFromActivityForConfigChanges() {
    Log.d(TAG, "🔄 Activity detached for config changes")
    activity = null
  }
  
  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    Log.d(TAG, "🔄 Activity reattached after config changes")
    activity = binding.activity
  }
  
  override fun onDetachedFromActivity() {
    Log.d(TAG, "🎯 Activity detached")
    activity = null
  }
  
  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    Log.d(TAG, "👂 Event listener attached")
    CallFlutterManager.setEventSink(events)
  }
  
  override fun onCancel(arguments: Any?) {
    Log.d(TAG, "🚫 Event listener canceled")
    CallFlutterManager.setEventSink(null)
  }
}
