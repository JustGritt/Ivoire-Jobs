import 'dart:convert';

import 'package:barassage_app/config/app_ws.dart';
import 'package:barassage_app/core/blocs/authentication/authentication_bloc.dart';
import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:barassage_app/features/bookings_mod/blocs/messaging_room_messages_bloc/messaging_chats_messages_bloc.dart';
import 'package:barassage_app/features/bookings_mod/models/chats_room_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ConversationChatScreen extends StatefulWidget {
  final ChatRoom chatRoom;
  ConversationChatScreen({super.key, required this.chatRoom});

  @override
  State<ConversationChatScreen> createState() => _ConversationChatScreenState();
}

class _ConversationChatScreenState extends State<ConversationChatScreen> {
  late types.User user;
  WebSocketChannel? _newMessageChannel;

  @override
  void initState() {
    super.initState();
    this.user = types.User(
        id: ((context.read<AuthenticationBloc>().state.props as List)[0]
                as User)
            .id);
    AppWs ws = AppWs();
    ws.connectRoomMessages(widget.chatRoom.id).then((value) => {
          value
            ..stream.listen(
              (message) {
                final messageParsed = JsonDecoder().convert(message);
                context.read<MessagingChatsMessagesBloc>().add(SendMessage(
                    message: ChatRoomMessage.fromJson(messageParsed)));
              },
              onError: (error) {
                print('Error: $error');
              },
              onDone: () {
                print('Connection closed');
              },
            ),
          _newMessageChannel = value
        });

    context
        .read<MessagingChatsMessagesBloc>()
        .add(GetAllMessagingChats(roomId: widget.chatRoom.id));
  }

  @override
  void dispose() async {
    _newMessageChannel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    void _handleSendPressed(types.PartialText message) {
      _newMessageChannel?.sink.add(message.text);
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: Container(
          height: 120,
          child: CupertinoNavigationBar(
            padding: EdgeInsetsDirectional.zero,
            backgroundColor: Colors.white,
            middle: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: widget.chatRoom.clientProfile != 'string'
                      ? Container()
                      : Image.network(
                          'https://images.unsplash.com/photo-1720728659925-9ca9a38afb2c?q=80&w=2075&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chatRoom.clientName ?? 'No Name',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body:
          BlocBuilder<MessagingChatsMessagesBloc, MessagingChatsMessagesState>(
        builder: (context, state) {
          if (state is MessagingRoomMessagesLoading ||
              state is MessagingRoomMessagesInitial) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is MessagingRoomMessagesError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is MessagingRoomMessagesLoaded) {
            return Chat(
              messages: ((state as MessagingRoomMessagesLoaded).messages)
                  .reversed
                  .toList(),
              onSendPressed: _handleSendPressed,
              showUserNames: true,
              theme: DefaultChatTheme(
                backgroundColor: theme.scaffoldBackgroundColor,
                inputBackgroundColor: theme.primaryColor,
                primaryColor: theme.primaryColor,
                secondaryColor: theme.secondaryHeaderColor,
              ),
              textMessageBuilder: (
                textMessage, {
                messageWidth = 0,
                showName = false,
              }) {
                return DefaultTextMessageWidget(
                  textMessage,
                  messageWidth: messageWidth,
                  showName: showName,
                  context: context,
                );
              },
              user: user,
            );
          }
          return Container();
        },
      ),
    );
  }
}

Widget DefaultTextMessageWidget(
  types.TextMessage textMessage, {
  required int messageWidth,
  required bool showName,
  required BuildContext context,
}) {
  ThemeData theme = Theme.of(context);
  final user = types.User(
      id: ((context.read<AuthenticationBloc>().state.props as List)[0] as User)
          .id);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        constraints: BoxConstraints(maxWidth: messageWidth.toDouble()),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(10),
        child: Text(
          textMessage.text,
          style: TextStyle(
            color: textMessage.author.id == user.id
                ? Colors.white
                : theme.primaryColor,
            fontSize: 14,
          ),
        ),
      ),
    ],
  );
}
