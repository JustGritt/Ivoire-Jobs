import 'package:barassage_app/core/helpers/utils_helper.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/features/auth_mod/auth_app.dart';
import 'package:barassage_app/features/auth_mod/models/user_signup.dart';
import 'package:barassage_app/features/auth_mod/models/user_update.dart';
import 'package:barassage_app/features/auth_mod/services/user_service.dart';
import 'package:bloc/bloc.dart';
import 'package:barassage_app/core/helpers/auth_helper.dart';
import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

UserService userService = serviceLocator<UserService>();


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
        emit(const AuthenticationFailureState('create user failed'));
        debugPrint(e.toString());
      }
    });

    on<UpdateUserEvent>((event, emit) async {
      emit(UpdateProfileLoadingState());
      try {
        User? user = await userService.update(event.user);
        if (user != null) {
          emit(AuthenticationSuccessState(user));
          showMyDialog(
            context,
            title: 'Profile',
            content: 'Profile updated successfully',
          );
        
        } else {
          emit(const AuthenticationFailureState('create user failed'));
        }
      } catch (e) {
        emit(const AuthenticationFailureState('create user failed'));
        debugPrint(e.toString());
      }
    });

    on<SignUpUser>((event, emit) async {
      if (state is AuthenticationLoadingState &&
          state is AuthenticationSuccessState) {
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
        emit(const AuthenticationFailureState('get user failed'));
      }
    });

    on<SignOut>((event, emit) async {
      try {
        GoRouter.of(context).go(AuthApp.login);
        doLogout();
      } catch (e) {
        print('error');
        print(e.toString());
      }
    });
  }
}
