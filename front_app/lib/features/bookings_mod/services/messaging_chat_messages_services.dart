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

class MessagingChatMessagesServices {
  final AppHttp _http = AppHttp();

  Future<List<ChatRoomMessage>> getAllMessages(String roomId) async {
    try {
      Response res = await _http
          .get(ApiEndpoint.roomChatMessages.replaceAll(':id', roomId));
      if (res.statusCode == 200) {
        ApiBaseModel baseModel = ApiBaseModel.fromJson(res.data);
        List<ChatRoomMessage> chatRoomMessages =
            ChatRoomMessage.chatRoomsFromJson(baseModel.body);
        return chatRoomMessages;
      }
      throw res.data['message'];
    } catch (e) {
      print(e);
      showMyDialog(context, content: e.toString(), title: 'Error');
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<ChatRoomMessage> sendMessage(
      String roomId, String message, String senderId) async {
    try {
      Response res = await _http.post(
          ApiEndpoint.roomChatMessages.replaceAll(':id', roomId),
          data: {'content': message, 'senderId': senderId});
      if (res.statusCode == 200) {
        ApiBaseModel baseModel = ApiBaseModel.fromJson(res.data);
        ChatRoomMessage chatRoomMessage =
            ChatRoomMessage.fromJson(baseModel.body);
        return chatRoomMessage;
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
