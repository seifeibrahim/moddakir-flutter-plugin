package com.moddakir.moddakir_flutter_plugin

import android.app.Activity
import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.moddakir.moddakir_flutter_plugin.core.CallFlutterManager
import com.moddakir.moddakir_flutter_plugin.core.listeners.CallListenersSetup
import com.moddakir.callslib.core.CallsApp

/** ModdakirFlutterPlugin */
class ModdakirFlutterPlugin: FlutterPlugin, MethodCallHandler, ActivityAware, EventChannel.StreamHandler {
  private lateinit var methodChannel: MethodChannel
  private lateinit var eventChannel: EventChannel
  private var activity: Activity? = null
  private var context: Context? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    
    methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "moddakir_flutter_plugin")
    methodChannel.setMethodCallHandler(this)
    
    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "moddakir_flutter_plugin/events")
    eventChannel.setStreamHandler(this)
    
    CallFlutterManager.init(flutterPluginBinding.applicationContext as android.app.Application)
    CallListenersSetup.setupAllListeners()
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "initializeCallSDK" -> {
        initializeCallSDK(call, result)
      }
      "startCall" -> {
        startCall(call, result)
      }
      else -> {
        result.notImplemented()
      }
    }
  }
  
  private fun initializeCallSDK(call: MethodCall, result: Result) {
    try {
      val appContext = context ?: run {
        result.error("NO_CONTEXT", "Application context not available", null)
        return
      }
      
      CallsApp.context = appContext
      result.success(true)
    } catch (e: Exception) {
      result.error("INIT_ERROR", e.message, null)
    }
  }
  
  private fun startCall(call: MethodCall, result: Result) {
    try {
      val currentActivity = activity ?: run {
        result.error("NO_ACTIVITY", "Activity not available", null)
        return
      }
      
      val callId = call.argument<String>("callId") ?: run {
        result.error("INVALID_ARGS", "callId is required", null)
        return
      }
      
      val userId = call.argument<String>("userId")
      val sessionId = call.argument<String>("sessionId")
      
      // TODO: Replace with actual SDK call method
      // Example based on typical SDK usage:
      // CallsSDK.startCall(
      //     activity = currentActivity,
      //     callId = callId,
      //     userId = userId,
      //     sessionId = sessionId
      // )
      
      result.success(true)
    } catch (e: Exception) {
      result.error("CALL_ERROR", e.message, null)
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
    eventChannel.setStreamHandler(null)
  }
  
  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }
  
  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }
  
  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }
  
  override fun onDetachedFromActivity() {
    activity = null
  }
  
  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    CallFlutterManager.setEventSink(events)
  }
  
  override fun onCancel(arguments: Any?) {
    CallFlutterManager.setEventSink(null)
  }
}
