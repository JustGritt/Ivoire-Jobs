import 'dart:async';

import 'package:barassage_app/config/api_endpoints.dart';
import 'package:barassage_app/config/app_cache.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AppWs {
  final String wsUrl = ApiEndpoint.roomChatMessagesWs;

  Future<WebSocketChannel> connectRoomMessages(String roomId) async {
    AppCache ac = AppCache();
    String token = await ac.getToken() ?? "";
    final channel = WebSocketChannel.connect(
        Uri.parse('${wsUrl.replaceAll(':id', roomId)}?token=$token'));

    await channel.ready;
    return channel;
  }

  Future<WebSocketChannel> connectToServiceMaintenance() async {
    AppCache ac = AppCache();
    String token = await ac.getToken() ?? "";
    final channel =
        WebSocketChannel.connect(Uri.parse(ApiEndpoint.appMaintenanceWs));

    await channel.ready;
    return channel;
  }
}
