import 'package:barassage_app/core/blocs/authentication/authentication_bloc.dart';
import 'package:barassage_app/features/bookings_mod/blocs/messaging_room_messages_bloc/messaging_chats_messages_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:barassage_app/core/blocs/service/service_bloc.dart';
import 'package:barassage_app/core/classes/language_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:barassage_app/core/classes/router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/features/bookings_mod/blocs/messaging_chats_bloc/messaging_chats_bloc.dart';
import 'package:barassage_app/firebase_options.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:barassage_app/config/config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:barassage_app/l10n/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterImageCompress.showNativeLog = true;
  Provider.debugCheckInvalidValueType = null;
  await initDependencies();
  await initializeDateFormatting('fr_FR');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  var envFile = ".env";
  try {
    if (io.File(".env").existsSync()) envFile = ".env";
  } catch (e) {}
  await dotenv.load(fileName: envFile);

  if (!kIsWeb) {
    Stripe.publishableKey = Config.stripePublicKey;
    await Stripe.instance.applySettings();
  }

  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthenticationBloc()..add(InitiateAuth()),
        ),
        BlocProvider(
          create: (_) => MessagingChatsBloc(),
        ),
        BlocProvider(
          create: (_) => MessagingChatsMessagesBloc(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<ServiceBloc>(),
        )
      ],
      child: MultiProvider(
        providers: appProviders,
        child: const BarassageApp(),
      )));
}

class BarassageApp extends StatelessWidget {
  const BarassageApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var tm = context.watch<ThemeProvider>();
    var lp = context.watch<LanguageProvider>();
    return MaterialApp.router(
        title: 'Barassage App',
        supportedLocales: L10n.all,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: lp.locale,
        debugShowCheckedModeBanner: false,
        theme: MyTheme().lightTheme,
        darkTheme: MyTheme().darkTheme,
        themeMode: tm.themeMode,
        routerConfig: router);
  }
}
