import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// Simple API service for getting SDK session credentials
class SessionApi {
  static const String baseUrl = 'https://revamp-auth-stage.moddakir.com/api';
  
  /// Get SDK session credentials
  /// This is the ONLY API call we make from Flutter
  /// The Android SDK handles everything else (login, search, create call, etc.)
  static Future<Map<String, dynamic>> getSdkSession({
    required String name,
    required String email,
    required String phone,
    required String gender,
    required String language,
    required String moddakirId,
    required String moddakirKey,
    Map<String, dynamic>? sessionInfo,
  }) async {
    final url = Uri.parse('$baseUrl/auth/protected/sdk/session');
    
    final body = {
      'callDuration': 30,
      'callType': 'Voice',
      'email': email,
      'fullName': name,
      'gender': gender,
      'phone': phone,
      if (sessionInfo != null) 'sessionInfo': sessionInfo,
      'startDate': DateTime.now().toIso8601String(),
    };
    
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('📤 GET SDK SESSION REQUEST');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('🔗 URL: $url');
    debugPrint('📦 Body: ${jsonEncode(body)}');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept-Language': language,
          'Moddakir-ID': moddakirId,
          'platformType': 'mobile',
          'Moddakir-Key': moddakirKey,
        },
        body: jsonEncode(body),
      );
      
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('📥 GET SDK SESSION RESPONSE');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('📊 Status Code: ${response.statusCode}');
      debugPrint('📦 Body: ${response.body}');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        final data = jsonResponse['data'] as Map<String, dynamic>;
        
        debugPrint('✅ SDK Session retrieved successfully');
        debugPrint('   Token: ${data['token']?.toString().substring(0, 20)}...');
        debugPrint('   SDK Session ID: ${data['sdkSessionId']}');
        
        return data;
      } else {
        debugPrint('❌ Failed to get SDK session: ${response.statusCode}');
        throw Exception('Failed to get SDK session: ${response.statusCode} - ${response.body}');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error getting SDK session: $e');
      debugPrint('📍 Stack trace: $stackTrace');
      rethrow;
    }
  }
}
