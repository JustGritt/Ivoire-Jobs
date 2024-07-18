import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/features/bookings_mod/models/chats_room_model.dart';
import 'package:barassage_app/features/bookings_mod/services/messaging_chat_messages_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:bloc/bloc.dart';
import 'package:place_picker/uuid.dart';

part 'messaging_chats_events.dart';
part 'messaging_chats_messages_state.dart';

MessagingChatMessagesServices messagingService =
    serviceLocator<MessagingChatMessagesServices>();

class MessagingChatsMessagesBloc
    extends Bloc<MessagingChatsEvents, MessagingChatsMessagesState> {
  MessagingChatsMessagesBloc() : super(MessagingRoomMessagesInitial()) {
    on<MessagingChatsEvents>((event, emit) {});

    on<GetAllMessagingChats>((event, emit) async {
      emit(MessagingRoomMessagesLoading());
      try {
        final messages = await messagingService.getAllMessages(event.roomId);

        final messagesFormatted = messages.map((e) {
          return types.TextMessage(
            author: types.User(
                id: e.senderId,
                firstName: e.senderFirstname,
                imageUrl: e.receiverProfile),
            createdAt: e.createdAt.millisecondsSinceEpoch,
            text: e.content,
            id: Uuid().generateV4(),
          );
        }).toList();

        emit(MessagingRoomMessagesLoaded(messages: messagesFormatted));
      } catch (e) {
        emit(MessagingRoomMessagesError('create user failed'));
        debugPrint(e.toString());
      }
    });

    on<SendMessage>((event, emit) async {
      try {
        final messages = this.state.props[0] as List<types.TextMessage>;

        final newMessage = types.TextMessage(
            author: types.User(
                id: event.message.senderId,
                firstName: event.message.senderFirstname,
                imageUrl: event.message.senderProfile),
            createdAt: event.message.createdAt.millisecondsSinceEpoch,
            text: event.message.content,
            id: Uuid().generateV4());

        messages.add(newMessage);

        emit(MessagingRoomMessagesLoaded(messages: messages));
      } catch (e) {
        emit(MessagingRoomMessagesError('create user failed'));
        debugPrint(e.toString());
      }
    });
  }
}
