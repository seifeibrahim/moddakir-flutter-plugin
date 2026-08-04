class CreateCallRequest {
  final String consumerId;
  final String providerId;
  final String consumerName;
  final String providerName;
  final String status;
  final String consumerCountry;
  final String consumerAvatarUrl;
  final String providerAvatarUrl;
  final String callProviderType;
  final String callType;

  const CreateCallRequest({
    required this.consumerId,
    required this.providerId,
    required this.consumerName,
    required this.providerName,
    required this.status,
    required this.consumerCountry,
    required this.consumerAvatarUrl,
    required this.providerAvatarUrl,
    required this.callProviderType,
    required this.callType,
  });

  Map<String, dynamic> toJson() => {
        'consumerId': consumerId,
        'providerId': providerId,
        'consumerName': consumerName,
        'providerName': providerName,
        'status': status,
        'consumerCountry': consumerCountry,
        'consumerAvatarUrl': consumerAvatarUrl,
        'providerAvatarUrl': providerAvatarUrl,
        'callProviderType': callProviderType,
        'callType': callType,
      };
}
