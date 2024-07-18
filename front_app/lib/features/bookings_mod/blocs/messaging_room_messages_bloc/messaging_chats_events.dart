part of 'messaging_chats_messages_bloc.dart';

abstract class MessagingChatsEvents {
  const MessagingChatsEvents();

  List<Object> get props => [];
}

class GetAllMessagingChats extends MessagingChatsEvents {
  String roomId;
  GetAllMessagingChats({required this.roomId});

  @override
  List<Object> get props => [roomId];
}

class SendMessage extends MessagingChatsEvents {
  ChatRoomMessage message;
  SendMessage({required this.message});

  @override
  List<Object> get props => [message];
}
