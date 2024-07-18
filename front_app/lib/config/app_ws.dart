import 'dart:async';

import 'package:barassage_app/config/api_endpoints.dart';
import 'package:barassage_app/config/app_cache.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AppWs {
  late String roomId;
  late String token;

  final String wsUrl = ApiEndpoint.roomChatMessagesWs;

  AppWs(String roomId) {
    this.roomId = roomId;
  }

  Future<WebSocketChannel> connectRoomMessages() async {
    AppCache ac = AppCache();
    String token = await ac.getToken() ?? "";
    final channel = WebSocketChannel.connect(
        Uri.parse('${wsUrl.replaceAll(':id', roomId)}?token=$token'));

    await channel.ready;
    return channel;
  }
}
