import 'dart:convert';

List<BannedUser> bannedUserFromJson(String str) => List<BannedUser>.from(
  json.decode(str).map((x) => BannedUser.fromJson(x))
);

class BannedUser {
  String id;
  String userId;
  String reason;
  int nbReports;
  DateTime createdAt;

  BannedUser({
    required this.id,
    required this.userId,
    required this.reason,
    required this.nbReports,
    required this.createdAt,
  });

  factory BannedUser.fromJson(Map<String, dynamic> json) => BannedUser(
    id: json["id"] ?? '',
    userId: json["userId"] ?? '',
    reason: json["reason"] ?? '',
    nbReports: json["nbReports"] ?? 0,
    createdAt: DateTime.parse(json["createdAt"] ?? DateTime.now().toIso8601String()),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "reason": reason,
    "nbReports": nbReports,
    "createdAt": createdAt.toIso8601String(),
  };
}
