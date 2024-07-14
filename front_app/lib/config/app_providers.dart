import 'package:barassage_app/core/classes/language_provider.dart';
import 'package:barassage_app/features/admin_app/providers/banned_services_provider.dart';
import 'package:barassage_app/features/main_app/providers/my_services_provider.dart';
import 'package:barassage_app/features/main_app/providers/booking_services_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../core/core.dart';
import '../features/features.dart';
import '../features/main_app/providers/news_provider.dart';
import 'package:barassage_app/features/admin_app/providers/reports_provider.dart';
import 'app_theme.dart';

List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider<ThemeProvider>(
    create: (context) => ThemeProvider(),
  ),
  ChangeNotifierProvider<LanguageProvider>(
    create: (context) => LanguageProvider(),
  ),
  ChangeNotifierProvider<GlobalStateManager>(
    create: (context) => GlobalStateManager(),
  ),
  ChangeNotifierProvider<NewsProvider>(
    create: (context) => NewsProvider(),
  ),
  ChangeNotifierProvider<MyServicesProvider>(
    create: (context) => MyServicesProvider(),
  ),
  ChangeNotifierProvider<BookingServicesProvider>(
    create: (context) => BookingServicesProvider(),
  ),
  ChangeNotifierProvider<EnqueryProvider>(
    create: (context) => EnqueryProvider(),
  ),
  ChangeNotifierProvider<ReportsProvider>(
    create: (context) => ReportsProvider(),
  ),
  ChangeNotifierProvider<BannedServicesProvier>(
    create: (context) => BannedServicesProvier(),
  ),
];
