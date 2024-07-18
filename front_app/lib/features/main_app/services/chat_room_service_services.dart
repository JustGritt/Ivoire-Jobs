import 'package:barassage_app/features/bookings_mod/models/chats_room_model.dart';
import 'package:barassage_app/config/api_endpoints.dart';
import 'package:barassage_app/config/app_http.dart';
import 'package:barassage_app/features/main_app/models/api_base_model.dart';
import 'package:dio/dio.dart';

class ChatRoomServiceServices {
  AppHttp http = AppHttp();
  Future<ChatRoom> createOrGet(String serviceId) async {
    Response res = await http.get(
      ApiEndpoint.serviceRoom.replaceAll(':id', serviceId),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      ApiBaseModel apiResponse = ApiBaseModel.fromJson(res.data);
      return ChatRoom.fromJson(apiResponse.body);
    }
    throw res.data['message'];
  }
}
