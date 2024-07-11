import 'package:barassage_app/features/auth_mod/models/user.dart';

class UserLogin {
  String email;
  String password;

  UserLogin({
    required this.email,
    required this.password,
  });

  factory UserLogin.fromJson(Map<String, dynamic> json) => UserLogin(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}

class UserLoginResponse {
  final String accessToken;
  final User user;

  UserLoginResponse({
    required this.accessToken,
    required this.user,
  });

  UserLoginResponse copyWith({
    String? accessToken,
    String? refreshToken,
    User? user,
  }) =>
      UserLoginResponse(
        accessToken: accessToken ?? this.accessToken,
        user: user ?? this.user,
      );
  factory UserLoginResponse.fromJson(Map<String, dynamic> json) =>
      UserLoginResponse(
        accessToken: json["access_token"],
        user: User.fromJson(json["user"]),
      );
}
