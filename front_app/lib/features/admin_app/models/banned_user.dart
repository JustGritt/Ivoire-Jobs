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

  factory BannedUser.fromJson(Map<String, dynamic> json) => BannedUser(
        id: json['id'],
        userId: json['userId'],
        reason: json['reason'],
        nbReports: json['nbReports'],
        createdAt: DateTime.parse(json['createdAt']),
      );

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