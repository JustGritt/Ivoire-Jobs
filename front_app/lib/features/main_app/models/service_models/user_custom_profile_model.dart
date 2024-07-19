class UserCustomProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String profilePicture;
  final String bio;
  final String member;
  final DateTime createdAt;
  final DateTime updatedAt;
  final NotificationPreferences notificationPreferences;

  UserCustomProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profilePicture,
    required this.bio,
    required this.member,
    required this.createdAt,
    required this.updatedAt,
    required this.notificationPreferences,
  });

  factory UserCustomProfile.fromJson(Map<String, dynamic> json) {
    return UserCustomProfile(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      profilePicture: json['profilePicture'],
      bio: json['bio'],
      member: json['member'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      notificationPreferences: NotificationPreferences.fromJson(json['notificationPreferences']),
    );
  }
}

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

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      pushNotification: json['pushNotification'],
      messageNotification: json['messageNotification'],
      serviceNotification: json['serviceNotification'],
      bookingNotification: json['bookingNotification'],
    );
  }
}
