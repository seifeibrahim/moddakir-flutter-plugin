package com.moddakir.moddakir_flutter_plugin.core

import android.app.Application
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

object CallFlutterManager {
    private var eventSink: EventChannel.EventSink? = null
    private var application: Application? = null
    
    fun init(app: Application) {
        application = app
    }
    
    fun setEventSink(sink: EventChannel.EventSink?) {
        eventSink = sink
    }
    
    fun onCallEnded(state: String, callDurationSeconds: Double?) {
        eventSink?.success(mapOf(
            "event" to "callEnded",
            "state" to state,
            "duration" to callDurationSeconds
        ))
    }
    
    fun onCallStateUpdated(state: String) {
        eventSink?.success(mapOf(
            "event" to "callStateUpdated",
            "state" to state
        ))
    }
    
    fun onError(error: String) {
        eventSink?.error("CALL_ERROR", error, null)
    }
}
