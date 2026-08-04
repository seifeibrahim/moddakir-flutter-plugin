class RandomProviderResponse {
  final String id;
  final String username;
  final String gender;
  final String email;
  final String fullName;
  final String phone;
  final String createdAt;
  final String avatarUrl;
  final String country;
  final String city;
  final String address;
  final String certificate;
  final String status;

  const RandomProviderResponse({
    required this.id,
    required this.username,
    required this.gender,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.createdAt,
    required this.avatarUrl,
    required this.country,
    required this.city,
    required this.address,
    required this.certificate,
    required this.status,
  });

  factory RandomProviderResponse.fromJson(Map<String, dynamic> json) {
    return RandomProviderResponse(
      id: json['id'] as String,
      username: json['username'] as String,
      gender: json['gender'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String,
      createdAt: json['createdAt'] as String,
      avatarUrl: json['avatarUrl'] as String,
      country: json['country'] as String,
      city: json['city'] as String,
      address: json['address'] as String,
      certificate: json['certificate'] as String,
      status: json['status'] as String,
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
        'certificate': certificate,
        'status': status,
      };
}
