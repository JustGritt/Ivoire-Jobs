part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initInventory();
}

void _initAuth() {
  // Datasource
  serviceLocator
    ..registerFactory<AuthenticationBloc>(
      () => AuthenticationBloc(),
    )
    ..registerFactory(
      () => AppCache(),
    )
    ..registerLazySingleton(
      () => AppContext(),
    )
    ..registerLazySingleton(
      () => UserService(),
    )
    ..registerLazySingleton(
      () => ServiceCategoryService(),
    );

  // // Bloc
  // ..registerLazySingleton(
  //   () => AuthBloc(
  //     userSignUp: serviceLocator(),
  //     userLogin: serviceLocator(),
  //     currentUser: serviceLocator(),
  //     appUserCubit: serviceLocator(),
  //   ),
  // );
}

void _initInventory() {}
