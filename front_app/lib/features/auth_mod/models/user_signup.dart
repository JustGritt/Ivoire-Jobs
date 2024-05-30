class UserSignup {
  int? id;
  String firstName;
  String lastName;
  String email;
  String password;

  UserSignup({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  factory UserSignup.fromJson(Map<String, dynamic> json) => UserSignup(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstName,
        "lastname": lastName,
        "email": email,
        "password": password,
      };
}
