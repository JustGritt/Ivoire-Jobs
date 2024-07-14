import 'dart:convert';

List<Member> membersFromJson(String str) =>
    List<Member>.from(json.decode(str).map((x) => Member.fromJson(x)));

class Member {
  final String id;
  final String reason;
  final String status;
  final DateTime createdAt;

  Member({
    required this.id,
    required this.reason,
    required this.status,
    required this.createdAt,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      reason: json['reason'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reason': reason,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Member copyWith({
    String? id,
    String? reason,
    String? status,
    DateTime? createdAt,
  }) {
    return Member(
      id: id ?? this.id,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Member &&
      other.id == id &&
      other.reason == reason &&
      other.status == status &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      reason.hashCode ^
      status.hashCode ^
      createdAt.hashCode;
  }
}