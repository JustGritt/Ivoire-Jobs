import 'dart:convert';

class NotificationPreferences {
  String bookingNotification;
  String messageNotification;
  String pushNotification;
  String serviceNotification;

  NotificationPreferences({
    required this.bookingNotification,
    required this.messageNotification,
    required this.pushNotification,
    required this.serviceNotification,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) => NotificationPreferences(
    bookingNotification: json["booking_notification"],
    messageNotification: json["message_notification"],
    pushNotification: json["push_notification"],
    serviceNotification: json["service_notification"],
  );

  Map<String, dynamic> toJson() => {
    "booking_notification": bookingNotification,
    "message_notification": messageNotification,
    "push_notification": pushNotification,
    "service_notification": serviceNotification,
  };


  NotificationPreferences copyWith({
    String? bookingNotification,
    String? messageNotification,
    String? pushNotification,
    String? serviceNotification,
  }) =>
    NotificationPreferences(
      bookingNotification: bookingNotification ?? this.bookingNotification,
      messageNotification: messageNotification ?? this.messageNotification,
      pushNotification: pushNotification ?? this.pushNotification,
      serviceNotification: serviceNotification ?? this.serviceNotification,
    );



}