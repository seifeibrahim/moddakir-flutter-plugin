import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'logging_interceptor.dart';
import '../models/sdk_login_request.dart';
import '../models/sdk_login_response.dart';
import '../models/random_provider_response.dart';
import '../models/create_call_request.dart';
import '../models/create_call_response.dart';
import '../models/update_call_request.dart';
import '../models/session_request_model.dart';
import '../models/session_response_model.dart';

class CallApiService {
  static const String baseUrl = 'https://revamp-auth-stage.moddakir.com/api'; // Replace with actual base URL
  
  final http.Client _client;
  String? _accessToken;

  CallApiService({http.Client? client}) 
      : _client = client ?? InterceptedClient.build(
          interceptors: [LoggingInterceptor()],
          requestTimeout: const Duration(seconds: 30),
        );

  void setAccessToken(String token) {
    _accessToken = token;
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
      };

  /// POST /auth/protected/sdk/login
  Future<SdkLoginResponse> sdkLogin(SdkLoginRequest request) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/auth/protected/sdk/login'),
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return SdkLoginResponse.fromJson(json['data'] as Map<String, dynamic>);
    } else {
      throw Exception('Failed to login: ${response.statusCode} ${response.body}');
    }
  }

  /// GET /core/private/provider/random
  Future<RandomProviderResponse> getRandomProvider() async {
    final response = await _client.get(
      Uri.parse('$baseUrl/core/private/provider/random'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return RandomProviderResponse.fromJson(json['data'] as Map<String, dynamic>);
    } else {
      throw Exception('Failed to get random provider: ${response.statusCode} ${response.body}');
    }
  }

  /// POST /call/private/create-call
  Future<CreateCallResponse> createCall(CreateCallRequest request) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/call/private/create-call'),
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return CreateCallResponse.fromJson(json['data'] as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create call: ${response.statusCode} ${response.body}');
    }
  }

  /// POST /call/private/update-call-log
  Future<void> updateCall(UpdateCallRequest request) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/call/private/update-call-log'),
      headers: _headers,
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to update call: ${response.statusCode} ${response.body}');
    }
  }

  /// POST /call/private/join-agora-signaling
  Future<void> joinAgoraSignaling({
    required String channelName,
    required bool voip,
    required bool huawei,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/call/private/join-agora-signaling'),
      headers: _headers,
      body: jsonEncode({
        'channelName': channelName,
        'voip': voip,
        'huawei': huawei,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to join agora signaling: ${response.statusCode} ${response.body}');
    }
  }

  void dispose() {
    _client.close();
  }
}

enum Environment {
  stage,
  production,
}

abstract class SessionRemoteDataSource { Future<SessionResponseModel> getSdkSession(SessionRequestModel request); }

class SessionRemoteDataSourceImpl implements SessionRemoteDataSource {
  static const Environment environment = Environment.production;

  static const String baseDomain = 'https://revamp-auth';
  static const String stageSuffix = '-stage';

  static String get baseUrl {
    const suffix = environment == Environment.stage ? stageSuffix : '';

    return '$baseDomain$suffix.moddakir.com/api';
  }

  final http.Client client;

  SessionRemoteDataSourceImpl({required this.client});

  @override
  Future<SessionResponseModel> getSdkSession(
      SessionRequestModel request,
      ) async {
    final url = Uri.parse('$baseUrl/auth/protected/sdk/session');

    debugPrint('\n🌐 ========== API REQUEST ==========');
    debugPrint('📍 URL: $url');
    debugPrint('🔧 Environment: ${environment.name}');
    debugPrint('📋 Headers:');
    debugPrint('   Content-Type: application/json');
    debugPrint('   Accept-Language: ${request.language}');
    debugPrint('   Moddakir-ID: ${request.moddakirId}');
    debugPrint('   platformType: mobile');
    debugPrint('   Moddakir-Key: ${request.moddakirKey.substring(0, 20)}...');
    debugPrint('📦 Body: ${jsonEncode(request.toJson())}');
    debugPrint('===================================\n');

    try {
      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept-Language': request.language,
          'Moddakir-ID': request.moddakirId,
          'platformType': 'mobile',
          'Moddakir-Key': request.moddakirKey,
        },
        body: jsonEncode(request.toJson()),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Connection timeout after 30 seconds');
        },
      );

      debugPrint('\n🌐 ========== API RESPONSE ==========');
      debugPrint('📊 Status Code: ${response.statusCode}');
      debugPrint('📦 Response Body: ${response.body}');
      debugPrint('====================================\n');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse =
        jsonDecode(response.body) as Map<String, dynamic>;

        final data = jsonResponse['data'] as Map<String, dynamic>;
        
        debugPrint('✅ Session created successfully');
        debugPrint('   Token: ${data['token']?.toString().substring(0, 30)}...');
        debugPrint('   SDK Session ID: ${data['sdkSessionId']}');

        return SessionResponseModel.fromJson(data);
      } else {
        debugPrint('❌ API Error: ${response.statusCode}');
        debugPrint('   Response: ${response.body}');
        throw Exception(
          'Failed to get SDK session: '
              '${response.statusCode} - ${response.body}',
        );
      }
    } on SocketException catch (e) {
      debugPrint('❌ Network Error: $e');
      throw const SocketException(
        'No internet connection. Please check your network settings.',
      );
    } on TimeoutException catch (e) {
      debugPrint('❌ Timeout Error: $e');
      throw TimeoutException(
        'Connection timeout. Please check your internet connection.',
      );
    } on FormatException catch (e) {
      debugPrint('❌ Format Error: $e');
      throw const FormatException(
        'Invalid server response format.',
      );
    } catch (e) {
      debugPrint('❌ Unexpected Error: $e');
      rethrow;
    }
  }
}
