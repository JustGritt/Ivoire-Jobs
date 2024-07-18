part of 'messaging_chats_messages_bloc.dart';

class MessagingChatsMessagesState {
  const MessagingChatsMessagesState();

  List<Object> get props => [];

}

class MessagingRoomMessagesInitial extends MessagingChatsMessagesState {}

class MessagingRoomMessagesLoading extends MessagingChatsMessagesState {}

class MessagingRoomMessagesLoaded extends MessagingChatsMessagesState {
  final List<types.TextMessage> messages;

  MessagingRoomMessagesLoaded({required this.messages});
  @override
  List<Object> get props => [messages];
}

class MessagingRoomMessagesError extends MessagingChatsMessagesState {
  final String message;

  MessagingRoomMessagesError(this.message);
  @override
  List<Object> get props => [message];
}
