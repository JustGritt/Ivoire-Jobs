import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../config/api_endpoints.dart';
import '../../../config/app_http.dart';
import '../models/notification_preferences.dart';

class NotificationPreferencesService {
  NotificationPreferencesService();
  final AppHttp _http = AppHttp();

  Future<void> storePreferences(NotificationPreferences preferences) async {
    try {
      Response res = await _http.patch(
        ApiEndpoint.notificationPreferences,
        data: preferences.toJson(),
      );

      if (res.statusCode == 200) {
        debugPrint("Preferences stored successfully.");
        return;
      }
      throw Exception(res.data['message']);
    } catch (e) {
      debugPrint("Error storing preferences: $e");
    }
  }
}
