import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'logging_interceptor.dart';
import '../models/sdk_login_request.dart';
import '../models/sdk_login_response.dart';
import '../models/random_provider_response.dart';
import '../models/create_call_request.dart';
import '../models/create_call_response.dart';
import '../models/update_call_request.dart';

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
