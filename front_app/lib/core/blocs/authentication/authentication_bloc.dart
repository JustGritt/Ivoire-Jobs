import 'package:barassage_app/features/auth_mod/models/user_signup.dart';
import 'package:bloc/bloc.dart';
import 'package:barassage_app/core/helpers/auth_helper.dart';
import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:flutter/material.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitialState()) {
    on<AuthenticationEvent>((event, emit) {});

    on<SignInUser>((event, emit) async {
      emit(AuthenticationLoadingState());
      try {
        User? user = await doAuth(event.email, event.password);
        if (user != null) {
          emit(AuthenticationSuccessState(user));
        } else {
          emit(const AuthenticationFailureState('create user failed'));
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    on<SignUpUser>((event, emit) async {
      if (state is AuthenticationLoadingState && state is AuthenticationSuccessState) {
        return;
      }
      emit(AuthenticationLoadingState());
      try {
        User? user = await doRegister(event.user);
        if (user != null) {
          emit(AuthenticationSuccessState(user));
        } else {
          emit(const AuthenticationFailureState('create user failed'));
        }
      } catch (e) {
        print(e.toString());
      }
    });

    on<InitiateAuth>((event, emit) async {
      emit(AuthenticationLoadingState());
      try {
        User? user = await getMyProfile();
        if (user != null) {
          emit(AuthenticationSuccessState(user));
        } else {
          emit(const AuthenticationFailureState('get user failed'));
        }
      } catch (e) {
        print(e);
      }
    });

    on<SignOut>((event, emit) async {
      emit(AuthenticationLoadingState());
      try {
        doLogout();
      } catch (e) {
        print('error');
        print(e.toString());
      }
    });
  }
}
