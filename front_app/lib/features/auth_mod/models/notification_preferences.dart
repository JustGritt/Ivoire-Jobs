class NotificationPreferences {
  final bool pushNotification;
  final bool messageNotification;
  final bool serviceNotification;
  final bool bookingNotification;

  NotificationPreferences({
    required this.pushNotification,
    required this.messageNotification,
    required this.serviceNotification,
    required this.bookingNotification,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
  NotificationPreferences(
    pushNotification: json["pushNotification"],
    messageNotification: json["messageNotification"],
    serviceNotification: json["serviceNotification"],
    bookingNotification: json["bookingNotification"],
  );

  Map<String, dynamic> toJson() => {
    "pushNotification": pushNotification,
    "messageNotification": messageNotification,
    "serviceNotification": serviceNotification,
    "bookingNotification": bookingNotification,
  };
}
