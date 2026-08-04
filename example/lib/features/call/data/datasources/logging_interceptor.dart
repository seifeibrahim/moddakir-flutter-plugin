import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http_interceptor/http_interceptor.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('📤 HTTP REQUEST');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('🔗 URL: ${request.url}');
    debugPrint('📋 Method: ${request.method}');
    debugPrint('📝 Headers:');
    request.headers.forEach((key, value) {
      debugPrint('   $key: $value');
    });
    
    if (request is Request) {
      if (request.body.isNotEmpty) {
        debugPrint('📦 Body:');
        try {
          final prettyJson = JsonEncoder.withIndent('  ').convert(jsonDecode(request.body));
          debugPrint(prettyJson);
        } catch (e) {
          debugPrint(request.body);
        }
      }
    }
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({required BaseResponse response}) async {
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('📥 HTTP RESPONSE');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('🔗 URL: ${response.request?.url}');
    debugPrint('📊 Status Code: ${response.statusCode}');
    debugPrint('📝 Headers:');
    response.headers.forEach((key, value) {
      debugPrint('   $key: $value');
    });
    
    if (response is Response) {
      if (response.body.isNotEmpty) {
        debugPrint('📦 Body:');
        try {
          final prettyJson = JsonEncoder.withIndent('  ').convert(jsonDecode(response.body));
          debugPrint(prettyJson);
        } catch (e) {
          debugPrint(response.body);
        }
      }
    }
    
    if (response.statusCode >= 400) {
      debugPrint('❌ ERROR RESPONSE');
    } else {
      debugPrint('✅ SUCCESS RESPONSE');
    }
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    
    return response;
  }

  @override
  Future<bool> shouldInterceptRequest() async => true;

  @override
  Future<bool> shouldInterceptResponse() async => true;
}
