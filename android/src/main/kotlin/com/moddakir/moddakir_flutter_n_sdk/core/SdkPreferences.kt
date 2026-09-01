package com.moddakir.moddakir_flutter_n_sdk.core

import android.content.Context
import android.content.SharedPreferences
import android.util.Log

/**
 * Manages SDK credentials in SharedPreferences
 * The SDK can read these preferences to get the token
 */
object SdkPreferences {
    private const val TAG = "SdkPreferences"
    private const val PREF_NAME = "moddakir_sdk_prefs"
    private const val KEY_ACCESS_TOKEN = "access_token"
    private const val KEY_SDK_SESSION_ID = "sdk_session_id"
    
    private fun getPrefs(context: Context): SharedPreferences {
        return context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE)
    }
    
    /**
     * Save the access token to preferences
     * The SDK will read this when making API calls
     */
    fun setAccessToken(context: Context, token: String) {
        Log.d(TAG, "💾 Saving access token to preferences")
        getPrefs(context).edit()
            .putString(KEY_ACCESS_TOKEN, token)
            .apply()
        Log.d(TAG, "✅ Token saved: ${token.take(20)}...")
    }
    
    /**
     * Get the access token from preferences
     */
    fun getAccessToken(context: Context): String? {
        val token = getPrefs(context).getString(KEY_ACCESS_TOKEN, null)
        Log.d(TAG, "📖 Reading access token: ${token?.take(20)}...")
        return token
    }
    
    /**
     * Save the SDK session ID
     */
    fun setSdkSessionId(context: Context, sessionId: String) {
        Log.d(TAG, "💾 Saving SDK session ID: $sessionId")
        getPrefs(context).edit()
            .putString(KEY_SDK_SESSION_ID, sessionId)
            .apply()
    }
    
    /**
     * Get the SDK session ID
     */
    fun getSdkSessionId(context: Context): String? {
        return getPrefs(context).getString(KEY_SDK_SESSION_ID, null)
    }
    
    /**
     * Clear all saved credentials
     */
    fun clear(context: Context) {
        Log.d(TAG, "🧹 Clearing all credentials")
        getPrefs(context).edit().clear().apply()
    }
}
