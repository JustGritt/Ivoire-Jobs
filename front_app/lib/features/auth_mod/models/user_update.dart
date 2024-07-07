class UserUpdate {
  int? id;
  String firstName;
  String lastName;
  String email;
  String bio;

  UserUpdate({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.bio,
  });

  factory UserUpdate.fromJson(Map<String, dynamic> json) => UserUpdate(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        bio: json["bio"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstName,
        "lastname": lastName,
        "email": email,
        "bio": bio,
      };
}