import 'package:barassage_app/features/bookings_mod/screens/mobile/messages_page_screen/conversation_chat_screen.dart';
import 'package:barassage_app/features/main_app/Screens/mobile/service_booking/service_booking_success.dart';
import 'package:barassage_app/features/main_app/Screens/mobile/service_booking/service_booking.dart';
import 'package:barassage_app/features/main_app/models/service_models/service_created_model.dart';
import 'package:barassage_app/features/profile_mod/screens/mobile/become_barasseur_screen.dart';
import 'package:barassage_app/features/bookings_mod/controllers/main/messages_controller.dart';
import 'package:barassage_app/features/bookings_mod/controllers/main/bookings_controller.dart';
import 'package:barassage_app/features/profile_mod/controllers/main/profile_controller.dart';
import 'package:barassage_app/features/profile_mod/screens/mobile/edit_profile_screen.dart';
import 'package:barassage_app/features/main_app/controllers/main/services_controller.dart';
import 'package:barassage_app/features/auth_mod/screens/mobile/splash_mobile_screen.dart';
import 'package:barassage_app/features/main_app/Screens/mobile/new_service_success.dart';
import 'package:barassage_app/features/main_app/Screens/mobile/services_details.dart';
import 'package:barassage_app/features/auth_mod/screens/mobile/main_wrapper.dart';
import 'package:barassage_app/features/main_app/Screens/mobile/new_service.dart';
import 'package:barassage_app/features/main_app/widgets/transition_page.dart';
import 'package:barassage_app/features/main_app/controllers/controller.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:barassage_app/core/blocs/service/service_bloc.dart';
import 'package:barassage_app/core/classes/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:barassage_app/core/classes/app_context.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/config/app_config.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../bookings_mod/models/chats_room_model.dart';

class App extends RouteManager {
  static const String name = '/app';
  static const String home = '${App.name}/home';
  static const String detailService = 'detailService';
  static const String services = '${App.name}/services';
  static const String placePicker = 'placesPicker';
  static const String serviceNew = 'newService';
  static const String serviceNewSuccess = 'newServiceSuccess';
  static const String bookingService = 'bookingService';
  static const String bookingServices = '/bookingServices';
  static const String messages = 'messages';
  static const String splash = '${App.name}/splash';
  static const String contact = '${App.name}/contact';
  static const String news = '${App.name}/news';
  static const String profile = '${App.name}/profile';
  static const String editProfile = 'editProfile';
  static const String becomeWorker = 'becomeWorker';
  static const String serviceBookingSuccess =
      '${App.name}/serviceBookingSuccess';
  static const String messagingChat = 'messagingChat';
  static const String maintenanceMode = 'maintenanceMode';

  final _rootKey = serviceLocator<AppContext>().navigatorKey;
  final _shellHomeKey = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  final _shellMapsKey = GlobalKey<NavigatorState>(debugLabel: 'Maps');
  final _shellBookingKey = GlobalKey<NavigatorState>(debugLabel: 'Booking');
  final _shellProfileKey = GlobalKey<NavigatorState>(debugLabel: 'Profile');

  App() {
    addRoute(StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootKey,
        builder: (context, state, navigationShell) {
          return MainWrapper(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: App.home,
                name: App.home,
                builder: (context, state) => const HomeController(),
                routes: [
                  GoRoute(
                    path: App.detailService,
                    builder: (context, state) {
                      final service = state.extra as ServiceCreatedModel;
                      return ServiceDetailPage(service: service);
                    },
                  ),
                  GoRoute(
                    name: App.bookingService,
                    path: App.bookingService,
                    builder: (context, state) {
                      final service = state.extra as ServiceCreatedModel;
                      return ServiceBookingScreen(service: service);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellMapsKey,
            initialLocation: App.services,
            routes: [
              GoRoute(
                path: App.services,
                name: App.services,
                parentNavigatorKey: _shellMapsKey,
                builder: (context, state) => const ServicesController(),
                routes: [
                  GoRoute(
                    path: App.serviceNew,
                    parentNavigatorKey: _shellMapsKey,
                    pageBuilder: (context, state) =>
                        const PlatformTransitionPage(
                      child: NewServicePage(),
                    ).show(context),
                  ),
                  GoRoute(
                    name: 'placesPicker',
                    path: App.placePicker,
                    builder: (context, state) => PlacePicker(
                      apiKey: Config.googleApiMaps,
                      region: 'CI',
                      onPlacePicked: (result) {
                        context.pop(result);
                      },
                      usePlaceDetailSearch: true,
                      initialPosition: LatLng(37.4219999, -122.0862462),
                      useCurrentLocation: true,
                      resizeToAvoidBottomInset:
                          false, // only works in page mode, less flickery, remove if wrong offsets
                    ),
                  ),
                  GoRoute(
                    name: App.serviceNewSuccess,
                    path: App.serviceNewSuccess,
                    builder: (context, state) {
                      final service = state.extra as CreateServiceSuccess;
                      return NewServiceSuccess(service: service);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellBookingKey,
            routes: [
              GoRoute(
                  path: App.bookingServices,
                  builder: (context, state) => BookingsController(),
                  routes: [
                    GoRoute(
                        name: App.messages,
                        path: App.messages,
                        builder: (context, state) => MessagesController(),
                        routes: [
                          GoRoute(
                            name: App.messagingChat,
                            path: App.messagingChat,
                            builder: (context, state) => ConversationChatScreen(
                              chatRoom: state.extra as ChatRoom,
                            ),
                          ),
                        ]),
                  ]),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellProfileKey,
            routes: [
              GoRoute(
                  path: App.profile,
                  builder: (context, state) => ProfileController(),
                  routes: [
                    GoRoute(
                        name: App.becomeWorker,
                        path: App.becomeWorker,
                        builder: (context, state) => BecomeBarasseurScreen()),
                    GoRoute(
                        name: App.editProfile,
                        path: App.editProfile,
                        builder: (context, state) => EditProfileScreen())
                  ]),
            ],
          ),
        ]));

    addRoute(GoRoute(
        path: App.splash,
        pageBuilder: (context, state) {
          return const MaterialPage(child: SplashMobileScreen());
        }));

    addRoute(GoRoute(
        path: App.serviceBookingSuccess,
        builder: (context, state) {
          final service = state.extra as ServiceBookingSuccessModel;
          return ServiceBookingSuccess(service: service);
        }));
  }
}
