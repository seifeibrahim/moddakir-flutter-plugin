class Consumer {
  final String id;
  final String? username;
  final String? gender;
  final String? email;
  final String? fullName;
  final String? phone;
  final String? avatarUrl;
  final String? country;

  const Consumer({
    required this.id,
    this.username,
    this.gender,
    this.email,
    this.fullName,
    this.phone,
    this.avatarUrl,
    this.country,
  });
}
