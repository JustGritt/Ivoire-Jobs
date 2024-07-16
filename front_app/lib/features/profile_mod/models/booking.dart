class Booking {
  final String id;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String userId;
  final String serviceId;
  final String status;
  final DateTime startTime;
  final DateTime endTime;
  final String creatorId;
  final String contactId;

  Booking({
    required this.id,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.userId,
    required this.serviceId,
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.creatorId,
    required this.contactId,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['ID'] ?? '',
      createdAt: DateTime.parse(json['CreatedAt'] ?? '0000-00-00T00:00:00Z'),
      updatedAt:
          json['UpdatedAt'] != null ? DateTime.parse(json['UpdatedAt']) : null,
      deletedAt:
          json['DeletedAt'] != null ? DateTime.parse(json['DeletedAt']) : null,
      userId: json['UserID'] ?? '',
      serviceId: json['ServiceID'] ?? '',
      status: json['Status'] ?? '',
      startTime: DateTime.parse(json['StartTime'] ?? '0000-00-00T00:00:00Z'),
      endTime: DateTime.parse(json['EndTime'] ?? '0000-00-00T00:00:00Z'),
      creatorId: json['CreatorID'] ?? '',
      contactId: json['ContactID'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'CreatedAt': createdAt.toIso8601String(),
      'UpdatedAt': updatedAt?.toIso8601String(),
      'DeletedAt': deletedAt?.toIso8601String(),
      'UserID': userId,
      'ServiceID': serviceId,
      'Status': status,
      'StartTime': startTime.toIso8601String(),
      'EndTime': endTime.toIso8601String(),
      'CreatorID': creatorId,
      'ContactID': contactId,
    };
  }
}
