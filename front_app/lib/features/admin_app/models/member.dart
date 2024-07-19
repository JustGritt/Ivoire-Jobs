import 'dart:convert';

import 'package:barassage_app/features/admin_app/models/user.dart';

List<Member> membersFromJson(String str) =>
    List<Member>.from(json.decode(str).map((x) => Member.fromJson(x)));

class Member {
  final String id;
  final String reason;
  final String status;
  final User? user;
  final DateTime createdAt;

  Member({
    required this.id,
    required this.reason,
    required this.status,
    this.user,
    required this.createdAt,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      reason: json['reason'],
      status: json['status'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reason': reason,
      'status': status,
      'user': user?.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Member copyWith({
    String? id,
    String? reason,
    String? status,
    User? user,
    DateTime? createdAt,
  }) {
    return Member(
      id: id ?? this.id,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      user: user ?? this.user,
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
        other.user == user &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ reason.hashCode ^ status.hashCode ^ user.hashCode ^ createdAt.hashCode;
  }
}
