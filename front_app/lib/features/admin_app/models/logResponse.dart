import 'package:barassage_app/features/admin_app/models/log.dart';

class LogResponse {
  final List<Log> logs;
  final int currentPage;
  final int totalPages;

  LogResponse({
    required this.logs,
    required this.currentPage,
    required this.totalPages,
  });

  factory LogResponse.fromJson(Map<String, dynamic> json) {
    return LogResponse(
      logs: (json['logs'] as List).map((e) => Log.fromJson(e)).toList(),
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logs': logs.map((e) => e.toJson()).toList(),
      'currentPage': currentPage,
      'totalPages': totalPages,
    };
  }

  LogResponse copyWith({
    List<Log>? logs,
    int? currentPage,
    int? totalPages,
  }) {
    return LogResponse(
      logs: logs ?? this.logs,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LogResponse &&
      other.logs == logs &&
      other.currentPage == currentPage &&
      other.totalPages == totalPages;
  }

  @override
  int get hashCode {
    return logs.hashCode ^
      currentPage.hashCode ^
      totalPages.hashCode;
  }
}