import 'dart:convert';

List<AdminUser> userFromJson(String str) =>
    List<AdminUser>.from(json.decode(str).map((x) => AdminUser.fromJson(x)));

class AdminUser {
  String firstName;
  String lastName;
  String email;
  String? profilePicture;
  String? bio;
  String id;
  String role;
  String password;

  AdminUser({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profilePicture,
    this.bio,
    required this.id,
    required this.role,
    required this.password,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) => AdminUser(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        bio: '',
        profilePicture: '',
        role: 'admin',
        password: '',
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "profilePicture": profilePicture,
        "role": role,
        "bio": '',
        "password": password,
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
      'role': role,
    };
  }

  AdminUser copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? profilePicture,
    String? bio,
    String? id,
    DateTime? createdAt,
  }) {
    return AdminUser(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      bio: bio ?? this.bio,
      id: id ?? this.id,
      role: role,
      password: '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'profilePicture': profilePicture,
      'role': role,
      'bio': bio,
      'id': id,
    };
  }

  factory AdminUser.fromMap(Map<String, dynamic> map) {
    return AdminUser(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      profilePicture: map['profilePicture'] ?? '',
      bio: map['bio'] ?? '',
      id: map['id'] ?? '',
      role: map['role'] ?? 'admin',
      password: '',
    );
  }
}
