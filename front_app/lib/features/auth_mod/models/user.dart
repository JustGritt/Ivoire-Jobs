import 'dart:convert';

import 'package:barassage_app/features/auth_mod/models/notification_preferences.dart';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

class User {
  String firstName;
  String lastName;
  String email;
  String profilePicture;
  String? bio;
  String id;
  DateTime createdAt;
  NotificationPreferences notificationPreferences;


  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profilePicture,
    required this.notificationPreferences,
    this.bio,
    required this.id,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        bio: json['bio'],
        profilePicture: '',
        notificationPreferences: NotificationPreferences.fromJson(
            json["notificationPreferences"]),
        createdAt:
            DateTime.parse(json["createdAt"] ?? DateTime.now().toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "profilePicture": profilePicture,
        "bio": bio,
        "createdAt": createdAt,
      };

  //toJSONEncodable
  Map<String, dynamic> toJsonEncodable() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'profilePicture': profilePicture,
      'bio': bio,
      'id': id,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  User copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? profilePicture,
    String? bio,
    String? id,
    DateTime? createdAt,
  }) {
    return User(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      bio: bio ?? this.bio,
      notificationPreferences: notificationPreferences,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'profilePicture': profilePicture,
      'bio': bio,
      'id': id,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      profilePicture: map['profilePicture'] ?? '',
      bio: map['bio'] ?? '',
      id: map['id'] ?? '',
      notificationPreferences:
          NotificationPreferences.fromJson(map["notificationPreferences"]),
      createdAt: map['createdAt'] ?? DateTime.now(),
    );
  }
}
