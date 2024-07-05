class Report {
  String id;
  String userId;
  String serviceId;
  String reason;
  DateTime createdAt;
  bool status;

  Report({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.reason,
    required this.createdAt,
    required this.status,
  });

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        id: json['id'],
        userId: json['userId'],
        serviceId: json['serviceId'],
        reason: json['reason'],
        createdAt: DateTime.parse(json['createdAt']),
        status: json['status'],
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'serviceId': serviceId,
      'reason': reason,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }
}
