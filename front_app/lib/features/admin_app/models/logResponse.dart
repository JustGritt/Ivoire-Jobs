import 'package:barassage_app/features/admin_app/models/log.dart';

class LogResponse {
  final bool first;
  final bool last;
  final int max_page;
  final int page;
  final int size;
  final int total;
  final int visible;
  final List<Log> items;
  final int currentPage;
  final int totalPages;

  LogResponse({
    required this.first,
    required this.last,
    required this.max_page,
    required this.page,
    required this.size,
    required this.total,
    required this.visible,
    required this.items,
    required this.currentPage,
    required this.totalPages,
  });

  factory LogResponse.fromJson(Map<String, dynamic> json) {
    return LogResponse(
      first: json['first'],
      last: json['last'],
      max_page: json['max_page'] ?? 0,
      page: json['page'] ?? 0,
      size: json['size'] ?? 0,
      total: json['total'] ?? 0,
      visible: json['visible'] ?? 0,
      items: List<Log>.from(json['items'].map((e) => Log.fromJson(e))),
      currentPage: json['page'] ?? 0,
      totalPages: json['total_pages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first': first,
      'last': last,
      'max_page': max_page,
      'page': page,
      'size': size,
      'total': total,
      'visible': visible,
      'items': items.map((e) => e.toJson()).toList(),
      'currentPage': currentPage,
      'totalPages': totalPages,
    };
  }

  LogResponse copyWith({
    bool? first,
    bool? last,
    int? max_page,
    int? page,
    int? size,
    int? total,
    int? total_pages,
    int? visible,
    List<Log>? items,
    int? currentPage,
    int? totalPages,
  }) {
    return LogResponse(
      first: first ?? this.first,
      last: last ?? this.last,
      max_page: max_page ?? this.max_page,
      page: page ?? this.page,
      size: size ?? this.size,
      total: total ?? this.total,
      visible: visible ?? this.visible,
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LogResponse &&
        other.first == first &&
        other.last == last &&
        other.max_page == max_page &&
        other.page == page &&
        other.size == size &&
        other.total == total &&
        other.visible == visible &&
        other.items == items &&
        other.currentPage == currentPage &&
        other.totalPages == totalPages;
  }

  @override
  int get hashCode {
    return first.hashCode ^
        last.hashCode ^
        max_page.hashCode ^
        page.hashCode ^
        size.hashCode ^
        total.hashCode ^
        visible.hashCode ^
        items.hashCode ^
        currentPage.hashCode ^
        totalPages.hashCode;
  }
}
