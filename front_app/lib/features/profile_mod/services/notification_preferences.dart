import 'package:barassage_app/features/profile_mod/models/notification_preferences.dart';
import 'package:barassage_app/config/api_endpoints.dart';
import 'package:barassage_app/config/app_http.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class NotificationPreferencesService {
  NotificationPreferencesService();
  final AppHttp _http = AppHttp();

  Future<NotificationPreferences> storePreferences(
      NotificationPreferences preferences) async {
    try {
      print("Storing preferences: ${preferences.toJson()}");
      Response res = await _http.put(
        ApiEndpoint.notificationPreferences,
        data: preferences.toJson(),
      );
      debugPrint("Response: ${res.data}");
      if (res.statusCode == 200) {
        debugPrint("Preferences stored successfully. Response: ${res.data}");
        return NotificationPreferences.fromJson(res.data);
      } else {
        throw Exception(
            "Failed to store preferences. Status code: ${res.statusCode}, Message: ${res.data['message']}");
      }
    } catch (e) {
      debugPrint("Error storing preferences: $e");
      rethrow;
    }
  }

  Future<NotificationPreferences?> fetchPreferences(String userId) async {
    try {
      print("Fetching preferences for user: $userId");
      Response res = await _http.get(ApiEndpoint.notificationPreferences);
      debugPrint("Response: ${res.data}");
      if (res.statusCode == 200) {
        debugPrint("Preferences fetched successfully. Response: ${res.data}");
        return NotificationPreferences.fromJson(res.data);
      } else if (res.statusCode == 404) {
        debugPrint("Preferences not found for user: $userId");
        return null; // Return null if not found
      } else {
        throw Exception(
            "Failed to fetch preferences. Status code: ${res.statusCode}, Message: ${res.data['message']}");
      }
    } catch (e) {
      debugPrint("Error fetching preferences: $e");
      rethrow;
    }
  }
}
