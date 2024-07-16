class NotificationPreferences {
  bool bookingNotification;
  bool messageNotification;
  bool pushNotification;
  bool serviceNotification;

  NotificationPreferences({
    required this.bookingNotification,
    required this.messageNotification,
    required this.pushNotification,
    required this.serviceNotification,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      NotificationPreferences(
        bookingNotification: json["bookingNotification"] ?? false,
        messageNotification: json["messageNotification"] ?? false,
        pushNotification: json["pushNotification"] ?? false,
        serviceNotification: json["serviceNotification"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "bookingNotification": bookingNotification,
        "messageNotification": messageNotification,
        "pushNotification": pushNotification,
        "serviceNotification": serviceNotification,
      };

  NotificationPreferences copyWith({
    bool? bookingNotification,
    bool? messageNotification,
    bool? pushNotification,
    bool? serviceNotification,
  }) =>
      NotificationPreferences(
        bookingNotification: bookingNotification ?? this.bookingNotification,
        messageNotification: messageNotification ?? this.messageNotification,
        pushNotification: pushNotification ?? this.pushNotification,
        serviceNotification: serviceNotification ?? this.serviceNotification,
      );
}
