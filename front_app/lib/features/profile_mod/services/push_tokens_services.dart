import 'package:barassage_app/core/services/device_info_manager/device_info_manager.dart';
import 'package:barassage_app/config/api_endpoints.dart';
import 'package:barassage_app/config/app_http.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class PushTokensService {
  PushTokensService();
  final AppHttp _http = AppHttp();

  Future<void> storeToken(String token) async {
    try {
      DeviceInfoManager deviceInfo = DeviceInfoManager();
      String deviceModel = await deviceInfo.getDeviceModel();
      Response res = await _http.patch(ApiEndpoint.pushTokens,
          data: {"token": token, "device": deviceModel});

      if (res.statusCode == 200) {
        return;
      }
      throw res.data['message'];
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
