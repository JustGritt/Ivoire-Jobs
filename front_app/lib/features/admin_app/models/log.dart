class Log {
  final String id;
  final String level;
  final String type;
  final String message;
  final String requestURI;
  final String createdAt;
  final String? updatedAt;
  // final String? deletedAt;

  Log({
    required this.id,
    required this.level,
    required this.type,
    required this.message,
    required this.requestURI,
    required this.createdAt,
    this.updatedAt,
    // this.deletedAt,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      id: json['ID'] ?? '',
      level: json['Level'] ?? '',
      type: json['Type'] ?? '',
      message: json['Message'] ?? '',
      requestURI: json['RequestURI'] ?? '',
      createdAt: json['CreatedAt'] ?? '',
      updatedAt: json['UpdatedAt'] ?? '',
      // deletedAt: json['deletedAt'],
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
      'updatedAt': updatedAt,
      // 'deletedAt': deletedAt,
    };
  }

  Log copyWith({
    String? id,
    String? level,
    String? type,
    String? message,
    String? requestURI,
    String? createdAt,
    String? updatedAt,
    // String? deletedAt,
  }) {
    return Log(
      id: id ?? this.id,
      level: level ?? this.level,
      type: type ?? this.type,
      message: message ?? this.message,
      requestURI: requestURI ?? this.requestURI,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      // deletedAt: deletedAt ?? this.deletedAt,
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
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
    // other.deletedAt == deletedAt;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      level.hashCode ^
      type.hashCode ^
      message.hashCode ^
      requestURI.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
  // deletedAt.hashCode;
}
