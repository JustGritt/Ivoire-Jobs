import 'package:barassage_app/core/classes/app_context.dart';
import 'package:barassage_app/core/helpers/utils_helper.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/features/bookings_mod/models/chats_room_model.dart';
import 'package:barassage_app/features/main_app/models/api_base_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../config/api_endpoints.dart';
import '../../../config/app_http.dart';

BuildContext context = serviceLocator<AppContext>().navigatorContext;

class MessagingServices {
  final AppHttp _http = AppHttp();

  Future<List<ChatRoom>> getAll() async {
    try {
      Response res = await _http.get(ApiEndpoint.roomsChats);
      if (res.statusCode == 200) {
        ApiBaseModel baseModel = ApiBaseModel.fromJson(res.data);
        List<ChatRoom> chatRooms =
            ChatRoom.chatRoomsFromJson(baseModel.body ?? []);
        print(chatRooms);
        return chatRooms;
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
