part of 'authentication_bloc.dart';

abstract class AuthenticationEvent {
  const AuthenticationEvent();

  List<Object> get props => [];
}

class SignUpUser extends AuthenticationEvent {
  final UserSignup user;

  const SignUpUser(this.user);

  @override
  List<Object> get props => [user];
}

class SignInUser extends AuthenticationEvent {
  final String email;
  final String password;

  const SignInUser(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class InitiateAuth extends AuthenticationEvent {}

class UpdateUserEvent extends AuthenticationEvent {
  final UserUpdate user;

  const UpdateUserEvent(this.user);

  @override
  List<Object> get props => [user];
}


class SignOut extends AuthenticationEvent {}
