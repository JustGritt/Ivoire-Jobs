import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../config/api_endpoints.dart';
import '../../../config/app_http.dart';
import 'package:barassage_app/core/services/device_info_manager/device_info_manager.dart';

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
