import 'package:bloc/bloc.dart';
import 'package:clean_architecture/core/classes/app_context.dart';
import 'package:clean_architecture/core/helpers/auth_helper.dart';
import 'package:clean_architecture/core/init_dependencies.dart';
import 'package:clean_architecture/features/auth_mod/models/user.dart';
import 'package:flutter/material.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitialState()) {
    on<AuthenticationEvent>((event, emit) {});

    on<SignUpUser>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try {
        BuildContext context = serviceLocator<AppContext>().navigatorContext;
        User? user = await doAuth(context, event.email, event.password);
        if (user != null) {
          emit(AuthenticationSuccessState(user));
        } else {
          emit(const AuthenticationFailureState('create user failed'));
        }
      } catch (e) {
        print(e.toString());
      }
      emit(AuthenticationLoadingState(isLoading: false));
    });

    on<InitiateAuth>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try {

        if (user != null) {
          emit(AuthenticationSuccessState(user));
        } else {
          emit(const AuthenticationFailureState('create user failed'));
        }
      } catch (e) {
        print(e.toString());
      }
      emit(AuthenticationLoadingState(isLoading: false));
    });

    on<SignOut>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      // try {
      //   authService.signOutUser();
      // } catch (e) {
      //   print('error');
      //   print(e.toString());
      // }
      emit(AuthenticationLoadingState(isLoading: false));
    });
  }
}
