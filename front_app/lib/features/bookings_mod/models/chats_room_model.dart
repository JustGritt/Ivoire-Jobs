class ChatRoom {
  String id;
  List<ChatRoomMessage> messages;
  int count;

  ChatRoom({
    required this.id,
    required this.messages,
    required this.count,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    var messagesJson = json['messages'] as List;
    List<ChatRoomMessage> messagesList = messagesJson
        .map((message) => ChatRoomMessage.fromJson(message))
        .toList();

    return ChatRoom(
      id: json['id'],
      messages: messagesList,
      count: json['count'],
    );
  }

  static List<ChatRoom> chatRoomsFromJson(List<dynamic> json) {
    return json.map((chatRoom) => ChatRoom.fromJson(chatRoom)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'messages': messages.map((message) => message.toJson()).toList(),
      'count': count,
    };
  }
}

class ChatRoomMessage {
  String senderId;
  String senderFirstname;
  String receiverId;
  String receiverFirstname;
  String senderProfile;
  String receiverProfile;
  String content;
  bool seen;
  DateTime createdAt;

  ChatRoomMessage({
    required this.senderId,
    required this.senderFirstname,
    required this.receiverId,
    required this.receiverFirstname,
    required this.senderProfile,
    required this.receiverProfile,
    required this.content,
    required this.seen,
    required this.createdAt,
  });

  factory ChatRoomMessage.fromJson(Map<String, dynamic> json) {
    return ChatRoomMessage(
      senderId: json['sender_id'],
      senderFirstname: json['sender_firstname'],
      receiverId: json['receiver_id'],
      receiverFirstname: json['receiver_firstname'],
      senderProfile: json['sender_profile'],
      receiverProfile: json['receiver_profile'],
      content: json['content'],
      seen: json['seen'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender_id': senderId,
      'sender_firstname': senderFirstname,
      'receiver_id': receiverId,
      'receiver_firstname': receiverFirstname,
      'sender_profile': senderProfile,
      'receiver_profile': receiverProfile,
      'content': content,
      'seen': seen,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
