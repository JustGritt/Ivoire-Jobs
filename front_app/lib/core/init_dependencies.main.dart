part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBloc();
  
  await serviceLocator.allReady();
}

Future<void> _initAuth() async {
  // Datasource
  serviceLocator
    ..registerFactory(
      () => AppCache(),
    )
    ..registerLazySingletonAsync<AppCacheToken>(() async {
      AppCache appCache = serviceLocator<AppCache>();
      final token = await appCache.getToken();
      return AppCacheToken(token: token);
    })
    ..registerLazySingleton(
      () => AppContext(),
    )
    ..registerLazySingleton(
      () => UserService(),
    )
    ..registerLazySingleton(
      () => ServiceCategoryService(),
    )
    ..registerLazySingleton(
      () => ServiceServices(),
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

void _initBloc() {
  serviceLocator
    ..registerFactory(
      () => AuthenticationBloc(),
    )
    ..registerFactory(
      () => ServiceBloc(),
    );
}
