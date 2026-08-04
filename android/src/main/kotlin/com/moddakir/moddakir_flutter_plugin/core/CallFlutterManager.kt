package com.moddakir.moddakir_flutter_plugin.core

import android.app.Application
import android.util.Log
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

object CallFlutterManager {
    private const val TAG = "CallFlutterManager"
    private var eventSink: EventChannel.EventSink? = null
    private var application: Application? = null
    
    fun init(app: Application) {
        Log.d(TAG, "🔧 Initializing CallFlutterManager")
        application = app
        Log.d(TAG, "✅ CallFlutterManager initialized")
    }
    
    fun setEventSink(sink: EventChannel.EventSink?) {
        Log.d(TAG, "📡 Event sink ${if (sink != null) "attached" else "detached"}")
        eventSink = sink
    }
    
    fun onCallEnded(state: String, callDurationSeconds: Double?) {
        Log.d(TAG, "📞 Call ended event")
        Log.d(TAG, "   State: $state")
        Log.d(TAG, "   Duration: $callDurationSeconds seconds")
        
        val event = mapOf(
            "event" to "callEnded",
            "state" to state,
            "duration" to callDurationSeconds
        )
        
        if (eventSink != null) {
            Log.d(TAG, "📤 Sending call ended event to Flutter")
            eventSink?.success(event)
        } else {
            Log.w(TAG, "⚠️ Event sink is null, cannot send event")
        }
    }
    
    fun onCallStateUpdated(state: String) {
        Log.d(TAG, "🔄 Call state updated: $state")
        
        val event = mapOf(
            "event" to "callStateUpdated",
            "state" to state
        )
        
        if (eventSink != null) {
            Log.d(TAG, "📤 Sending state update to Flutter")
            eventSink?.success(event)
        } else {
            Log.w(TAG, "⚠️ Event sink is null, cannot send event")
        }
    }
    
    fun onError(error: String) {
        Log.e(TAG, "❌ Call error: $error")
        
        if (eventSink != null) {
            Log.d(TAG, "📤 Sending error to Flutter")
            eventSink?.error("CALL_ERROR", error, null)
        } else {
            Log.w(TAG, "⚠️ Event sink is null, cannot send error")
        }
    }
}
