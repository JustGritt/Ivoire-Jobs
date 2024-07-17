import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/features/bookings_mod/models/chats_room_model.dart';
import 'package:barassage_app/features/bookings_mod/services/messaging_services.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';

part 'messaging_chats_events.dart';
part 'messaging_chats_state.dart';

MessagingServices messagingService = serviceLocator<MessagingServices>();

class MessagingChatsBloc
    extends Bloc<MessagingChatsEvents, MessagingChatsState> {
  MessagingChatsBloc() : super(MessagingChatsInitialState()) {
    on<MessagingChatsEvents>((event, emit) {});

    on<GetAllChats>((event, emit) async {
      emit(MessagingChatsLoadingState());
      try {
        final chatRooms = await messagingService.getAll();
        emit(MessagingChatsLoadedState(chats: chatRooms));
      } catch (e) {
        emit(MessagingChatsErrorState('create user failed'));
        debugPrint(e.toString());
      }
    });
  }
}
