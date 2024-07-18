import 'package:barassage_app/config/app_colors.dart';
import 'package:barassage_app/core/blocs/authentication/authentication_bloc.dart';
import 'package:barassage_app/features/bookings_mod/models/chats_room_model.dart';
import 'package:barassage_app/features/main_app/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barassage_app/core/helpers/extentions/string_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jiffy/jiffy.dart';

class MessagingConversationCard extends StatefulWidget {
  final ChatRoom chatRoom;
  final bool isSeen;

  const MessagingConversationCard(
      {super.key, this.isSeen = true, required this.chatRoom});

  @override
  State<MessagingConversationCard> createState() =>
      _MessagingConversationCardState();
}

class _MessagingConversationCardState extends State<MessagingConversationCard> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    int messageSize = widget.isSeen ? 25 : 30;

    return CupertinoButton(
      onPressed: () {
        context.pushNamed(App.messagingChat, extra: widget.chatRoom);
      },
      minSize: 0,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                  width: 65,
                  height: 65,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Image.network(
                    'https://via.placeholder.com/150/0000FF/808080?Text=Digital.com',
                    alignment: Alignment.bottomCenter,
                  )),
              SizedBox(width: 10),
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                if (state is AuthenticationSuccessState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        widget.chatRoom.clientName ?? 'No Name',
                        style: TextStyle(
                            color: theme.primaryColorDark,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          widget.isSeen
                              ? Container(
                                  margin: EdgeInsets.only(right: 5),
                                  child: Icon(
                                    Ionicons.checkmark_done_outline,
                                    color: theme.primaryColor,
                                    size: 20,
                                  ),
                                )
                              : Container(),
                          Text(
                            widget.chatRoom.messages.lastOrNull?.content ??
                                'No Messages'.truncateTo(messageSize),
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
                return Container();
              }),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 2),
              Text(
                Jiffy.parse(widget.chatRoom.messages.isEmpty
                        ? widget.chatRoom.createdAt.toString()
                        : (widget.chatRoom.messages.lastOrNull?.createdAt
                                .toString() ??
                            DateTime.now().toString()))
                    .Hm,
                style: TextStyle(
                    color: theme.colorScheme.surface,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 2),
              Container(
                height: 25,
                child: !widget.isSeen
                    ? Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '3',
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    : Container(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
