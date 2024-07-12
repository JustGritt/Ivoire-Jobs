class Category {
  String id;
  String name;
  bool status;

  Category({
    required this.id,
    required this.name,
    required this.status,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'],
    name: json['name'],
    status: json['status'],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    return data;
  }
}

class CategoryRequest {
  String name;

  CategoryRequest({
    required this.name,
  });

  factory CategoryRequest.fromJson(Map<String, dynamic> json) => CategoryRequest(
    name: json['name'],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}