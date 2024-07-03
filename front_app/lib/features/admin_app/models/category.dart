class Category {
  String name;
  String description;
  int duration;
  bool isActive = false;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  Category({
    required this.name,
    required this.description,
    required this.duration,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json['name'],
        description: json['description'],
        duration: json['duration'],
        isActive: json['isActive'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['duration'] = duration;
    data['isActive'] = isActive;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
