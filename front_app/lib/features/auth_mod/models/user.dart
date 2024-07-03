import 'dart:convert';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

class User {
  String firstName;
  String lastName;
  String email;
  String profilePicture;
  String bio;
  String id;
  DateTime createdAt;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profilePicture,
    required this.bio,
    required this.id,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        bio: '',
        profilePicture: '',
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
      createdAt: map['createdAt'] ?? DateTime.now(),
    );
  }
}
