class Log {
  final String id;
  final String level;
  final String type;
  final String message;
  final String requestURI;
  final String createdAt;

  Log({
    required this.id,
    required this.level,
    required this.type,
    required this.message,
    required this.requestURI,
    required this.createdAt,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      id: json['id'],
      level: json['level'],
      type: json['type'],
      message: json['message'],
      requestURI: json['requestURI'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level,
      'type': type,
      'message': message,
      'requestURI': requestURI,
      'createdAt': createdAt,
    };
  }

  Log copyWith({
    String? id,
    String? level,
    String? type,
    String? message,
    String? requestURI,
    String? createdAt,
  }) {
    return Log(
      id: id ?? this.id,
      level: level ?? this.level,
      type: type ?? this.type,
      message: message ?? this.message,
      requestURI: requestURI ?? this.requestURI,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Log &&
        other.id == id &&
        other.level == level &&
        other.type == type &&
        other.message == message &&
        other.requestURI == requestURI &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      level.hashCode ^
      type.hashCode ^
      message.hashCode ^
      requestURI.hashCode ^
      createdAt.hashCode;
}
