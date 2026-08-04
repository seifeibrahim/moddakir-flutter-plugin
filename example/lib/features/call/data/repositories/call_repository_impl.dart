import 'package:flutter/foundation.dart';
import '../../domain/entities/sdk_login.dart';
import '../../domain/entities/provider.dart';
import '../../domain/entities/call_session.dart';
import '../../domain/entities/session_input.dart';
import '../../domain/repositories/call_repository.dart';
import '../datasources/call_api_service.dart';
import '../models/sdk_login_request.dart';
import '../models/create_call_request.dart';
import '../models/update_call_request.dart';
import '../mappers/sdk_login_mapper.dart';
import '../mappers/provider_mapper.dart';
import '../mappers/call_session_mapper.dart';

class CallRepositoryImpl implements CallRepository {
  final CallApiService apiService;

  CallRepositoryImpl(this.apiService);

  @override
  Future<SdkLogin> loginToSdk(SessionInput sessionInput) async {
    debugPrint('🔐 [Repository] SDK Login request');
    debugPrint('   Name: ${sessionInput.name}');
    debugPrint('   Email: ${sessionInput.email}');
    debugPrint('   Phone: ${sessionInput.phone}');
    debugPrint('   Gender: ${sessionInput.gender}');
    debugPrint('   Call Type: ${sessionInput.callType}');
    
    final request = SdkLoginRequest(
      fullName: sessionInput.name,
      email: sessionInput.email,
      phone: sessionInput.phone,
      gender: sessionInput.gender,
      callType: sessionInput.callType,
      callDuration: sessionInput.callDuration,
      startDate: DateTime.now().toIso8601String(),
      sessionInfo: sessionInput.sessionInfo?.toJson(),
      metaData: sessionInput.metaData,
    );

    try {
      debugPrint('📤 [Repository] Sending SDK login API call...');
      final response = await apiService.sdkLogin(request);
      debugPrint('📥 [Repository] SDK login response received');
      debugPrint('   Access Token: ${response.accessToken.substring(0, 20)}...');
      debugPrint('   Session ID: ${response.sdkSessionId}');
      
      apiService.setAccessToken(response.accessToken);
      
      final entity = SdkLoginMapper.toEntity(response);
      debugPrint('✅ [Repository] SDK login successful');
      return entity;
    } catch (e, stackTrace) {
      debugPrint('❌ [Repository] SDK login failed: $e');
      debugPrint('📍 [Repository] Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<Provider> getRandomProvider() async {
    debugPrint('🔍 [Repository] Getting random provider...');
    
    try {
      debugPrint('📤 [Repository] Sending get random provider API call...');
      final response = await apiService.getRandomProvider();
      debugPrint('📥 [Repository] Random provider response received');
      
      final entity = ProviderMapper.toEntity(response);
      debugPrint('✅ [Repository] Provider found: ${entity.fullName} (${entity.id})');
      return entity;
    } catch (e, stackTrace) {
      debugPrint('❌ [Repository] Get random provider failed: $e');
      debugPrint('📍 [Repository] Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<CallSession> createCall({
    required String consumerId,
    required String providerId,
    required String consumerName,
    required String providerName,
    required String consumerCountry,
    required String consumerAvatarUrl,
    required String providerAvatarUrl,
    required String callType,
  }) async {
    debugPrint('📞 [Repository] Creating call session...');
    debugPrint('   Consumer: $consumerName ($consumerId)');
    debugPrint('   Provider: $providerName ($providerId)');
    debugPrint('   Call Type: $callType');
    
    final request = CreateCallRequest(
      consumerId: consumerId,
      providerId: providerId,
      consumerName: consumerName,
      providerName: providerName,
      status: 'INITIATE',
      consumerCountry: consumerCountry,
      consumerAvatarUrl: consumerAvatarUrl,
      providerAvatarUrl: providerAvatarUrl,
      callProviderType: 'agora',
      callType: callType,
    );

    try {
      debugPrint('📤 [Repository] Sending create call API request...');
      final response = await apiService.createCall(request);
      debugPrint('📥 [Repository] Create call response received');
      
      final entity = CallSessionMapper.toEntity(response);
      debugPrint('✅ [Repository] Call session created: ${entity.callId}');
      return entity;
    } catch (e, stackTrace) {
      debugPrint('❌ [Repository] Create call failed: $e');
      debugPrint('📍 [Repository] Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<void> updateCallLog({
    required String callId,
    required String status,
    required DateTime endDateTime,
    required int duration,
    required bool isHangupByTeacher,
    required bool isHangupByStudent,
  }) async {
    debugPrint('📝 [Repository] Updating call log...');
    debugPrint('   Call ID: $callId');
    debugPrint('   Status: $status');
    debugPrint('   Duration: $duration seconds');
    
    final request = UpdateCallRequest(
      callId: callId,
      status: status,
      endDateTime: endDateTime.toIso8601String(),
      duration: duration,
      isHangupByTeacher: isHangupByTeacher,
      isHangupByStudent: isHangupByStudent,
      isPackageEnded: false,
      isSilenceTimeout: false,
    );

    try {
      debugPrint('📤 [Repository] Sending update call API request...');
      await apiService.updateCall(request);
      debugPrint('✅ [Repository] Call log updated successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ [Repository] Update call log failed: $e');
      debugPrint('📍 [Repository] Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<void> joinAgoraSignaling({
    required String channelName,
    required bool voip,
    required bool huawei,
  }) async {
    await apiService.joinAgoraSignaling(
      channelName: channelName,
      voip: voip,
      huawei: huawei,
    );
  }
}
