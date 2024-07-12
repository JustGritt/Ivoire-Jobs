part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState();

  List<Object> get props => [];
}

class AuthenticationInitialState extends AuthenticationState {}

class AuthenticationLoadingState extends AuthenticationState {
  AuthenticationLoadingState();
}

class AuthenticationSuccessState extends AuthenticationState {
  final User user;

  const AuthenticationSuccessState(this.user);
  @override
  List<Object> get props => [user];
}

class AuthenticationFailureState extends AuthenticationState {
  final String errorMessage;

  const AuthenticationFailureState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

/// events update profile
class UpdateProfileLoadingState extends AuthenticationState {
  UpdateProfileLoadingState();
}
