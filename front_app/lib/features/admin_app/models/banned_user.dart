class BannedUser {
  String id;
  String userId;
  String reason;
  String nbReports;
  DateTime createdAt;

  BannedUser({
    required this.id,
    required this.userId,
    required this.reason,
    required this.nbReports,
    required this.createdAt,
  });

  factory BannedUser.fromJson(Map<String, dynamic> json) {
    return BannedUser(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      reason: json['reason'] ?? 'No reason provided',
      nbReports: json['nbReports'] ?? '0', // Default to '0' if nbReports is null
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'reason': reason,
      'nbReports': nbReports,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
