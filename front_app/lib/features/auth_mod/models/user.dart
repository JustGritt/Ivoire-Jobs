import 'dart:convert';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  String firstName;
  String lastName;
  String email;
  String profilePicture;
  String bio;
  String id;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profilePicture,
    required this.bio,
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        bio: '',
        profilePicture: '',
      );

  Map<String, dynamic> toJson() => {
       "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "profilePicture": profilePicture,
        "bio": bio,
      };

  User copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? profilePicture,
    String? bio,
    String? id,
  }) {
    return User(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      bio: bio ?? this.bio,
      id: id ?? this.id,
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
    );
  }
}
