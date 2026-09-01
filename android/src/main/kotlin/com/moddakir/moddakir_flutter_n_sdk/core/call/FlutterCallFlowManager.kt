package com.moddakir.moddakir_flutter_n_sdk.core.call

import android.app.Activity
import android.content.Context
import android.util.Log
import com.moddakir.moddakir_flutter_n_sdk.core.SdkCallbackManager
import com.moddakir.moddakir_flutter_n_sdk.core.SdkPreferences
import com.example.sdksample.feature.call.domain.entity.Language
import com.example.sdksample.feature.call.domain.entity.CallType
import com.example.sdksample.feature.call.presentation.manager.CallFlowManager
import com.example.sdksample.feature.call.presentation.manager.CallsSdk
import com.example.sdksample.feature.call.presentation.manager.SdkListener
import com.example.sdksample.core.network.Environment

/**
 * Manager to prepare credentials and launch SDK
 */
object FlutterCallFlowManager {
    private const val TAG = "FlutterCallFlow"
    
    private lateinit var appContext: Context
    private var isInitialized = false
    
    /**
     * Initialize the manager
     */
    fun init(context: Context) {
        if (isInitialized) {
            Log.d(TAG, "⚠️ Already initialized")
            return
        }
        
        appContext = context.applicationContext
        // com.moddakir.callslib.core.CallsApp.context = appContext // TODO: Update for SDK 1.0.24
        isInitialized = true
        Log.d(TAG, "✅ FlutterCallFlowManager initialized")
    }
    
    /**
     * Prepare credentials for SDK
     * The SDK will read the token from SharedPreferences when it needs it
     */
    fun prepareCredentials() {
        if (!isInitialized) {
            Log.e(TAG, "❌ Not initialized!")
            return
        }
        
        if (!SdkCallbackManager.hasCredentials()) {
            Log.e(TAG, "❌ No credentials available!")
            return
        }
        
        val token = SdkCallbackManager.token!!
        val sdkSessionId = SdkCallbackManager.sdkSessionId!!
        
        Log.d(TAG, "💾 Preparing credentials for SDK")
        Log.d(TAG, "   Token: ${token.take(20)}...")
        Log.d(TAG, "   SDK Session ID: $sdkSessionId")
        
        // Save to SharedPreferences - SDK will read from here
        SdkPreferences.setAccessToken(appContext, token)
        SdkPreferences.setSdkSessionId(appContext, sdkSessionId)
        
        Log.d(TAG, "✅ Credentials ready - SDK can now use them via callback")
    }
    
    /**
     * Start SDK call flow
     */
    fun startSdkCall(
        activity: Activity,
        language: String = "ar",
        callType: CallType = CallType.Voice,
        isDark: Boolean = false,
        primaryColor: Int? = null
    ) {
        if (!isInitialized) {
            Log.e(TAG, "❌ Not initialized!")
            return
        }
        
        if (!SdkCallbackManager.hasCredentials()) {
            Log.e(TAG, "❌ No credentials available!")
            return
        }
        
        val token = SdkCallbackManager.token!!
        val sdkSessionId = SdkCallbackManager.sdkSessionId!!
        
        Log.d(TAG, "🚀 Starting SDK call flow")
        Log.d(TAG, "   Token: ${token.take(20)}...")
        Log.d(TAG, "   SDK Session ID: $sdkSessionId")
        Log.d(TAG, "   Language: $language")
        Log.d(TAG, "   Call Type: $callType")
        Log.d(TAG, "   Dark Mode: $isDark")
        
        try {
            // Setup SDK listener
            CallFlowManager.sdkListener = object : SdkListener {
                override fun statusUpdate(sessionId: String, status: String) {
                    Log.d(TAG, "📊 SDK Status Update: $status (Session: $sessionId)")
                }
                
                override fun reviewUpdate(sessionId: String, review: Map<String, String>) {
                    Log.d(TAG, "⭐ SDK Review Update (Session: $sessionId)")
                }
                
                override fun onUnauthorized(sessionId: String) {
                    Log.e(TAG, "🚫 SDK Unauthorized - session expired (Session: $sessionId)")
                }
                
                override fun onError(sessionId: String, errorMessage: String, errorCode: String?) {
                    Log.e(TAG, "❌ SDK Error: $errorMessage (Code: $errorCode, Session: $sessionId)")
                }
            }
            
            // Launch SDK using builder
            CallsSdk.builder(activity)
                .setSDkSessionId(sdkSessionId)
                .setToken(token)
                .setAppName("sdk_5")
                .setLanguage(if (language == "ar") Language.ar else Language.en)
                .setPrimaryColor(primaryColor ?: android.graphics.Color.parseColor("#2196F3"))
                .setCallType(callType)
                .setEnvironment(Environment.SANDBOX)
                .setDarkMode(isDark)
                .start()
            
            Log.d(TAG, "✅ SDK call flow started successfully!")
        } catch (e: Exception) {
            Log.e(TAG, "❌ Error starting SDK call flow", e)
        }
    }
    
    /**
     * Get ready status
     */
    fun isReady(): Boolean {
        return isInitialized && SdkCallbackManager.hasCredentials()
    }
    
    /**
     * Clear credentials
     */
    fun clear() {
        Log.d(TAG, "🧹 Clearing credentials")
        SdkCallbackManager.clearCredentials()
        SdkPreferences.clear(appContext)
    }
}
