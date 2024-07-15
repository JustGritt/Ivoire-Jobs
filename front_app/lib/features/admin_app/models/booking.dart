class Booking {
  final String id;
  final DateTime endTime;
  final DateTime startTime;
  final String serviceID;
  final String status;
  final String userID;

  Booking({
    required this.id,
    required this.endTime,
    required this.startTime,
    required this.serviceID,
    required this.status,
    required this.userID,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      endTime: DateTime.parse(json['endTime']),
      startTime: DateTime.parse(json['startTime']),
      serviceID: json['serviceID'],
      status: json['status'],
      userID: json['userID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'endTime': endTime.toIso8601String(),
      'startTime': startTime.toIso8601String(),
      'serviceID': serviceID,
      'status': status,
      'userID': userID,
    };
  }

  Booking copyWith({
    String? id,
    DateTime? endTime,
    DateTime? startTime,
    String? serviceID,
    String? status,
    String? userID,
  }) {
    return Booking(
      id: id ?? this.id,
      endTime: endTime ?? this.endTime,
      startTime: startTime ?? this.startTime,
      serviceID: serviceID ?? this.serviceID,
      status: status ?? this.status,
      userID: userID ?? this.userID,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Booking &&
      other.id == id &&
      other.endTime == endTime &&
      other.startTime == startTime &&
      other.serviceID == serviceID &&
      other.status == status &&
      other.userID == userID;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      endTime.hashCode ^
      startTime.hashCode ^
      serviceID.hashCode ^
      status.hashCode ^
      userID.hashCode;
  }
}