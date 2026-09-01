package com.moddakir.moddakir_flutter_n_sdk.core

import android.util.Log

/**
 * Manages SDK session credentials provided from Flutter
 * This acts as a bridge between Flutter and the Android SDK
 */
object SdkCallbackManager {
    private const val TAG = "SdkCallbackManager"
    
    // Session credentials from Flutter
    var token: String? = null
        private set
    var sdkSessionId: String? = null
        private set
    
    /**
     * Store session credentials received from Flutter
     */
    fun setSessionCredentials(
        token: String?,
        sdkSessionId: String?
    ) {
        Log.d(TAG, "📦 Storing session credentials")
        this.token = token
        this.sdkSessionId = sdkSessionId
        
        Log.d(TAG, "✅ Credentials stored:")
        Log.d(TAG, "   Token: ${token?.take(20)}...")
        Log.d(TAG, "   SDK Session ID: $sdkSessionId")
    }
    
    /**
     * Clear stored credentials
     */
    fun clearCredentials() {
        Log.d(TAG, "🧹 Clearing session credentials")
        token = null
        sdkSessionId = null
    }
    
    /**
     * Check if credentials are available
     */
    fun hasCredentials(): Boolean {
        return token != null && sdkSessionId != null
    }
}
