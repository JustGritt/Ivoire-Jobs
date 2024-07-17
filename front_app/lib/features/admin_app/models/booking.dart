import "package:barassage_app/features/admin_app/models/service_booking.dart";
import 'package:barassage_app/features/admin_app/models/contact.dart';

class Booking {
  final String id;
  final DateTime endTime;
  final DateTime startTime;
  final Contact contact;
  final String serviceID;
  final ServiceBooking service;
  final String status;
  final String userID;

  Booking({
    required this.id,
    required this.endTime,
    required this.contact,
    required this.startTime,
    required this.serviceID,
    required this.service,
    required this.status,
    required this.userID,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? '',
      endTime:
          DateTime.parse(json['endTime'] ?? DateTime.now().toIso8601String()),
      startTime:
          DateTime.parse(json['startTime'] ?? DateTime.now().toIso8601String()),
      contact: json['contact'] != null
          ? Contact.fromJson(json['contact'])
          : Contact.fromJson({}),
      serviceID: json['serviceID'] ?? '',
      service: json['service'] != null
          ? ServiceBooking.fromJson(json['service'])
          : ServiceBooking.fromJson({}),
      status: json['status'] ?? '',
      userID: json['userID'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'endTime': endTime.toIso8601String(),
      'startTime': startTime.toIso8601String(),
      'contact': contact.toJson(),
      'serviceID': serviceID,
      'service': service.toJson(),
      'status': status,
      'userID': userID,
    };
  }

  Booking copyWith({
    String? id,
    DateTime? endTime,
    DateTime? startTime,
    Contact? contact,
    String? serviceID,
    ServiceBooking? service,
    String? status,
    String? userID,
  }) {
    return Booking(
      id: id ?? this.id,
      endTime: endTime ?? this.endTime,
      startTime: startTime ?? this.startTime,
      contact: contact ?? this.contact,
      serviceID: serviceID ?? this.serviceID,
      service: service ?? this.service,
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
        other.contact == contact &&
        other.serviceID == serviceID &&
        other.service == service &&
        other.status == status &&
        other.userID == userID;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        endTime.hashCode ^
        startTime.hashCode ^
        contact.hashCode ^
        serviceID.hashCode ^
        service.hashCode ^
        status.hashCode ^
        userID.hashCode;
  }
}
