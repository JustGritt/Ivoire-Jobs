import 'package:barassage_app/core/helpers/auth_helper.dart';
import 'package:barassage_app/features/profile_mod/services/push_tokens_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:flutter/material.dart';

class Firebaseapi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _pushTokensService = serviceLocator<PushTokensService>();

  Future<void> initNotifications() async {
    NotificationSettings notificationSettings =
        await _firebaseMessaging.requestPermission();
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      try {
        final token = await _firebaseMessaging.getToken();
        if (token == null) throw Exception("No token found");
        _pushTokensService.storeToken(token);
      } on Exception catch (e) {
        print(e);
      }
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Column(
            children: [
              Text(message.notification?.title ?? 'No title'),
              Text(message.notification?.body ?? 'No description'),
            ],
          ),
        ));
      });
    }
  }

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print('Handling a background message ${message}');
  }
}
