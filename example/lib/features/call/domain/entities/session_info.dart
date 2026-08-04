class SessionInfo {
  final String? title;
  final String? description;
  final Map<String, dynamic>? metadata;

  const SessionInfo({
    this.title,
    this.description,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'metadata': metadata,
      };

  factory SessionInfo.fromJson(Map<String, dynamic> json) => SessionInfo(
        title: json['title'] as String?,
        description: json['description'] as String?,
        metadata: json['metadata'] as Map<String, dynamic>?,
      );
}
