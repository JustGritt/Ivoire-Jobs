import 'package:barassage_app/config/app_colors.dart';
import 'package:barassage_app/features/bookings_mod/blocs/messaging_chats_bloc/messaging_chats_bloc.dart';
import 'package:barassage_app/features/bookings_mod/widgets/messaging/messaging_conversation_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ConversationsPageScreen extends StatefulWidget {
  const ConversationsPageScreen({super.key});

  @override
  State<ConversationsPageScreen> createState() =>
      _ConversationsPageScreenState();
}

class _ConversationsPageScreenState extends State<ConversationsPageScreen> {
  @override
  void initState() {
    context.read<MessagingChatsBloc>().add(GetAllChats());
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Conversations (18)'),
        previousPageTitle: 'Bookings',
        backgroundColor: AppColors.primaryBlueFair,
        border: Border(bottom: BorderSide(color: Colors.transparent)),
      ),
      child: BlocBuilder<MessagingChatsBloc, MessagingChatsState>(
          builder: (context, state) {
        if (state is MessagingChatsLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is MessagingChatsLoadedState) {
          if (state.chats.isEmpty) {
            return Center(child: Text('No Conversations Found !'));
          }

          return ListView.builder(
            itemCount: state.chats.length,
            itemBuilder: (context, index) {
              return MessagingConversationCard(chatRoom: state.chats[index]);
            },
          );
        }
        return Center(child: Text('No Conversations Found!'));
      }),
    );
  }
}
