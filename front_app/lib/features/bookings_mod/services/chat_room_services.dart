
import 'package:barassage_app/config/api_endpoints.dart';
import 'package:barassage_app/config/app_http.dart';
import 'package:barassage_app/core/classes/app_context.dart';
import 'package:barassage_app/core/helpers/utils_helper.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/features/bookings_mod/models/chats_room_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

BuildContext context = serviceLocator<AppContext>().navigatorContext;

class ChatRoomServices {
  final AppHttp _http = AppHttp();

  Future<dynamic> getAll() async {
    try {
      Response res = await _http.get(ApiEndpoint.serviceRoom);
      if (res.statusCode == 200) {
        return ChatRoom.fromJson(res.data);
      }
      throw res.data['message'];
    } catch (e) {
      print(e);
      showMyDialog(context, content: e.toString(), title: 'Error');
      debugPrint(e.toString());
      rethrow;
    }
  }
}
