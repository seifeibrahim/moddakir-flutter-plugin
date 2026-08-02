class CallUser {
  final String name;
  final String gender;
  final String phone;
  final String email;
  final String language;
  final String sdkVersion;
  final String sessionId;

  CallUser({
    required this.name,
    required this.gender,
    required this.phone,
    required this.email,
    required this.language,
    required this.sdkVersion,
    required this.sessionId,
  });

  CallUser copyWith({
    String? name,
    String? gender,
    String? phone,
    String? email,
    String? language,
    String? sdkVersion,
    String? sessionId,
  }) {
    return CallUser(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      language: language ?? this.language,
      sdkVersion: sdkVersion ?? this.sdkVersion,
      sessionId: sessionId ?? this.sessionId,
    );
  }
}
