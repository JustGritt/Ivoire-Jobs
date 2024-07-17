part of 'messaging_chats_bloc.dart';

class MessagingChatsState extends Equatable {
  const MessagingChatsState();

  List<Object> get props => [];
}

class MessagingChatsInitialState extends MessagingChatsState {}

class MessagingChatsLoadingState extends MessagingChatsState {}

class MessagingChatsLoadedState extends MessagingChatsState {
  final List<ChatRoom> chats;

  MessagingChatsLoadedState({required this.chats});

  List<Object> get props => [chats];
}

class MessagingChatsErrorState extends MessagingChatsState {
  final String message;

  MessagingChatsErrorState(this.message);

  List<Object> get props => [message];
}
