class ChatRoom {
  String id;
  String clientId;
  String clientName;
  String creatorId;
  String creatorName;
  String clientProfile;
  String creatorProfile;
  DateTime createdAt;
  List<ChatRoomMessage> messages;
  int count;

  ChatRoom({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.creatorId,
    required this.creatorName,
    required this.clientProfile,
    required this.creatorProfile,
    required this.createdAt,
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
      clientId: json['client_id'],
      clientName: json['client_name'],
      creatorId: json['creator_id'],
      creatorName: json['creator_name'],
      clientProfile: json['client_profile'],
      creatorProfile: json['creator_profile'],
      createdAt: DateTime.parse(json['created_at']),
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
      'client_id': clientId,
      'client_name': clientName,
      'creator_id': creatorId,
      'creator_name': creatorName,
      'client_profile': clientProfile,
      'creator_profile': creatorProfile,
      'messages': messages.map((message) => message.toJson()).toList(),
      'count': count,
    };
  }
}

class ChatRoomMessage {
  String senderId;
  String id;
  String senderFirstname;
  String receiverId;
  String receiverFirstname;
  String senderProfile;
  String receiverProfile;
  String content;
  bool seen;
  DateTime createdAt;

  ChatRoomMessage({
    required this.id,
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
      id: json['message_id'],
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

  static List<ChatRoomMessage> chatRoomsFromJson(List<dynamic> json) {
    return json.map((chatRoom) => ChatRoomMessage.fromJson(chatRoom)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'message_id': id,
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
