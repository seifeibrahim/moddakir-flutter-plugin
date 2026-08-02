package com.moddakir.moddakir_flutter_plugin.core.listeners

import android.util.Log
import androidx.fragment.app.FragmentManager
import com.moddakir.callslib.providers.agora.listeners.*
import com.moddakir.moddakir_flutter_plugin.core.CallFlutterManager

object CallListenersSetup {
    
    private const val TAG = "CallListenersSetup"
    
    fun setupAllListeners() {
        setupUpdateCallListener()
        setupRTMListener()
        setupRTCListener()
        setupActionButtonsListener()
    }
    
    private fun setupUpdateCallListener() {
        Log.d(TAG, "setupUpdateCallListener")
        CallbackUpdateCallListener.updateCallListener = object : UpdateCallListener {
            override fun onCallStateUpdated(state: String, callDurationSeconds: Double?) {
                Log.d(TAG, "onCallStateUpdated: state=$state, duration=$callDurationSeconds")
                CallFlutterManager.onCallEnded(state, callDurationSeconds)
            }
        }
    }
    
    private fun setupRTMListener() {
        Log.d(TAG, "setupRTMListener")
        CallbackRTMListener.rtmListener = object : RTMListener {
            override fun onPublishMessage(
                channelName: String,
                message: String,
                isSuccess: Boolean,
                errorCode: String
            ) {
                Log.d(TAG, "RTM Message Published: $message")
            }
            
            override fun onReceivedMessage(channelName: String, message: String) {
                Log.d(TAG, "RTM Message Received: $message")
            }
            
            override fun onRtmLogin(
                token: String?,
                isSuccess: Boolean,
                errorCode: String,
                fragmentManager: FragmentManager?
            ) {
                Log.d(TAG, "RTM Login: success=$isSuccess, errorCode=$errorCode")
            }
            
            override fun onSubscribe(
                channelName: String,
                isSuccess: Boolean,
                errorCode: String
            ) {
                Log.d(TAG, "RTM Subscribe Success: $channelName")
            }
            
            override fun onUnsubscribe(
                channelName: String,
                isSuccess: Boolean,
                errorCode: String
            ) {
                Log.d(TAG, "RTM Unsubscribe: $channelName")
            }
            
            override fun onLogout(isSuccess: Boolean) {
                Log.d(TAG, "RTM Logout: $isSuccess")
            }
        }
    }
    
    private fun setupRTCListener() {
        Log.d(TAG, "setupRTCListener")
        CallbackRTCListener.rtcListener = object : RTCListener {
            override fun onUserJoinedRTC(uid: Int) {
                Log.d(TAG, "RTC User Joined: $uid")
            }
            
            override fun onUserOfflineRTC(uid: Int) {
                Log.d(TAG, "RTC User Offline: $uid")
            }
            
            override fun onJoinChannelSuccessRTC(channel: String?, uid: String) {
                Log.d(TAG, "RTC Join Channel Success: channel=$channel, uid=$uid")
            }
        }
    }
    
    private fun setupActionButtonsListener() {
        Log.d(TAG, "setupActionButtonsListener")
        CallbackActionButtonsListener.consumerActionButtonsListener = object : ConsumerActionButtonsListener {
            override fun onSessionPreferencesClicked() {
                Log.d(TAG, "Session Preferences Clicked")
            }
            
            override fun onCallInfoClicked() {
                Log.d(TAG, "Call Info Clicked")
            }
        }
    }
}
