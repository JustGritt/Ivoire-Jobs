import 'package:barassage_app/config/api_endpoints.dart';
import 'package:barassage_app/config/app_http.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';

class DashboardSettingsService {
  String? token;

  DashboardSettingsService({this.token});

  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
  );

  Future<bool> getMaintenanceMode() async {
    try {
      Response res = await _http.get(ApiEndpoint.dashboardSettings + '/mode_maintenance');
      debugPrint('Maintenance mode status: ${res.data}');
      if (res.statusCode == 200 && res.data != null) {
        final value = res.data['body']['value'][0];
        // Cast the value to bool if it's a String
        if (value is String) {
          return value.toLowerCase() == 'true';
        }
        return value as bool;
      }
      throw Exception('Failed to load maintenance mode status');
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Failed to load maintenance mode status');
    }
  }

  Future<List<String>> getWhitelistIps() async {
    try {
      Response res = await _http.get(ApiEndpoint.dashboardSettings + '/whitelist');
      debugPrint('Ip list: ${res.data}');
      if (res.statusCode == 200 && res.data != null) {
        final value = res.data['body']['value'];
        if (value is List) {
          return List<String>.from(value);
        }
      }
      throw Exception('Failed to load whitelist IPs');
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Failed to load whitelist IPs');
    }
  }

  Future<void> setMaintenanceMode(bool isMaintenanceMode) async {
    try {
      await _http.put(
        ApiEndpoint.dashboardSettings + '/mode_maintenance',
        data: {
          'key': 'mode_maintenance',
          'value': [isMaintenanceMode.toString()]
        },
      );
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Failed to set maintenance mode status');
    }
  }

  Future<void> setWhitelistIps(List<String> ips) async {
    try {
      await _http.put(
        ApiEndpoint.dashboardSettings + '/whitelist',
        data: {
          'key': 'whitelist',
          'value': ips,
        },
      );
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('Failed to set whitelist IPs');
    }
  }
}
