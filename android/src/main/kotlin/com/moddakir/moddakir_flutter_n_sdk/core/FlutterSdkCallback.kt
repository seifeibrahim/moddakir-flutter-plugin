package com.moddakir.moddakir_flutter_n_sdk.core

import android.util.Log

/**
 * Callback implementation for SDK network operations
 * Uses credentials from SdkCallbackManager (token + sdkSessionId)
 * 
 * The SDK will call these methods to get data.
 * We return the token and let the SDK handle the rest.
 */
object FlutterSdkCallback {
    private const val TAG = "FlutterSdkCallback"
    
    /**
     * Provide the authentication token to the SDK
     * The SDK will use this token for all API calls
     */
    fun getAuthToken(): String? {
        val token = SdkCallbackManager.token
        Log.d(TAG, "📤 SDK requested auth token: ${token?.take(20)}...")
        return token
    }
    
    /**
     * Provide the SDK session ID
     */
    fun getSdkSessionId(): String? {
        val sessionId = SdkCallbackManager.sdkSessionId
        Log.d(TAG, "📤 SDK requested session ID: $sessionId")
        return sessionId
    }
}
