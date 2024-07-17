import 'package:chatview/chatview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConversationChatScreen extends StatefulWidget {
  const ConversationChatScreen({super.key});

  @override
  State<ConversationChatScreen> createState() => _ConversationChatScreenState();
}

class _ConversationChatScreenState extends State<ConversationChatScreen> {
  late final ChatController chatController;

  final List<Message> messageList = [
    Message(
      id: '1',
      message: "Hi",
      createdAt: DateTime.now(),
      sentBy: "1",
    ),
    Message(
      id: '2',
      message: "Hello",
      createdAt: DateTime.now()..add(const Duration(minutes: 5)),
      sentBy: "2",
    ),
  ];

  void onSendTap(
      String message, ReplyMessage replyMessage, MessageType messageType) {
    final message = Message(
      id: '3',
      message: "How are you",
      createdAt: DateTime.now(),
      replyMessage: replyMessage,
      sentBy: "1",
      messageType: messageType,
    );
    chatController.addMessage(message);
  }

  @override
  void initState() {
    chatController = ChatController(
      initialMessageList: messageList,
      scrollController: ScrollController(),
      currentUser: ChatUser(id: '1', name: 'Flutter'),
      otherUsers: [ChatUser(id: '2', name: 'Simform')],
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return SafeArea(
      top: false,
      minimum: EdgeInsets.only(bottom: 20),
      child: ChatView(
        chatController: chatController,
        onSendTap: onSendTap,
        chatViewState: ChatViewState.hasMessages,
        featureActiveConfig: const FeatureActiveConfig(
          lastSeenAgoBuilderVisibility: true,
          receiptsBuilderVisibility: true,
        ),
        chatViewStateConfig: ChatViewStateConfiguration(
          // loadingWidgetConfig: ChatViewStateWidgetConfiguration(
          //   loadingIndicatorColor: theme.outgoingChatBubbleColor,
          // ),
          onReloadButtonTap: () {},
        ),
        typeIndicatorConfig: TypeIndicatorConfiguration(
            // flashingCircleBrightColor: theme.flashingCircleBrightColor,
            // flashingCircleDarkColor: theme.flashingCircleDarkColor,
            ),
        chatBackgroundConfig: ChatBackgroundConfiguration(
          defaultGroupSeparatorConfig: DefaultGroupSeparatorConfiguration(
            textStyle: TextStyle(
              fontSize: 17,
            ),
          ),
        ),
        sendMessageConfig: SendMessageConfiguration(
          enableGalleryImagePicker: false,
          enableCameraImagePicker: false,
          allowRecordingVoice: false,

          imagePickerIconsConfig: ImagePickerIconsConfiguration(
              // cameraIconColor: theme.cameraIconColor,
              // galleryIconColor: theme.galleryIconColor,
              ),
          // replyMessageColor: theme.replyMessageColor,
          // defaultSendButtonColor: theme.sendButtonColor,
          // replyDialogColor: theme.replyDialogColor,
          // replyTitleColor: theme.replyTitleColor,
          // textFieldBackgroundColor: theme.textFieldBackgroundColor,
          defaultSendButtonColor: theme.primaryColor,
          textFieldBackgroundColor: Colors.grey.shade100,
          textFieldConfig: TextFieldConfiguration(
            textStyle: theme.textTheme.bodyMedium,
            contentPadding: const EdgeInsets.all(10),
            onMessageTyping: (status) {
              /// Do with status
              debugPrint(status.toString());
            },
            compositionThresholdTime: const Duration(seconds: 1),
          ),
        ),
        chatBubbleConfig: ChatBubbleConfiguration(
          outgoingChatBubbleConfig: ChatBubble(
            receiptsWidgetConfig:
                const ReceiptsWidgetConfig(showReceiptsIn: ShowReceiptsIn.all),
          ),
          inComingChatBubbleConfig: ChatBubble(
            linkPreviewConfig: LinkPreviewConfiguration(
              linkStyle: TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
            onMessageRead: (message) {
              /// send your message reciepts to the other client
              debugPrint('Message Read');
            },
          ),
        ),

        replyPopupConfig: ReplyPopupConfiguration(),
        reactionPopupConfig: ReactionPopupConfiguration(
          shadow: BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 20,
          ),
        ),

        messageConfig: MessageConfiguration(
          messageReactionConfig: MessageReactionConfiguration(
            reactionsBottomSheetConfig: ReactionsBottomSheetConfiguration(
              backgroundColor: Colors.white,
              reactionWidgetDecoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    offset: const Offset(0, 20),
                    blurRadius: 40,
                  )
                ],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          imageMessageConfig: ImageMessageConfiguration(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            shareIconConfig: ShareIconConfiguration(),
          ),
        ),
        repliedMessageConfig: RepliedMessageConfiguration(
          repliedMsgAutoScrollConfig: RepliedMsgAutoScrollConfig(
            enableHighlightRepliedMsg: true,
            highlightColor: Colors.pinkAccent.shade100,
            highlightScale: 1.1,
          ),
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.25,
          ),
        ),
        // swipeToReplyConfig: SwipeToReplyConfiguration(
        //   replyIconColor: theme.swipeToReplyIconColor,
        // ),
        replySuggestionsConfig: ReplySuggestionsConfig(
          itemConfig: SuggestionItemConfig(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.white,
              ),
            ),
          ),
        ),
        // Add this state once data is available.
      ),
    );
  }
}
