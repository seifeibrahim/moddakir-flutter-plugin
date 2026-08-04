class SdkLoginResponse {
  final String accessToken;
  final Consumer consumer;
  final String sdkSessionId;

  const SdkLoginResponse({
    required this.accessToken,
    required this.consumer,
    required this.sdkSessionId,
  });

  factory SdkLoginResponse.fromJson(Map<String, dynamic> json) {
    return SdkLoginResponse(
      accessToken: json['accessToken'] as String,
      consumer: Consumer.fromJson(json['consumer'] as Map<String, dynamic>),
      sdkSessionId: json['sdkSessionId'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'consumer': consumer.toJson(),
        'sdkSessionId': sdkSessionId,
      };
}

class Consumer {
  final String id;
  final String? username;
  final String? gender;
  final String? email;
  final String? fullName;
  final String? phone;
  final String? createdAt;
  final String? avatarUrl;
  final String? country;
  final String? city;
  final String? address;

  const Consumer({
    required this.id,
    this.username,
    this.gender,
    this.email,
    this.fullName,
    this.phone,
    this.createdAt,
    this.avatarUrl,
    this.country,
    this.city,
    this.address,
  });

  factory Consumer.fromJson(Map<String, dynamic> json) {
    return Consumer(
      id: json['id'] as String,
      username: json['username'] as String?,
      gender: json['gender'] as String?,
      email: json['email'] as String?,
      fullName: json['fullName'] as String?,
      phone: json['phone'] as String?,
      createdAt: json['createdAt'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'gender': gender,
        'email': email,
        'fullName': fullName,
        'phone': phone,
        'createdAt': createdAt,
        'avatarUrl': avatarUrl,
        'country': country,
        'city': city,
        'address': address,
      };
}
