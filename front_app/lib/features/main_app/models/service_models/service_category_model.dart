List<ServiceCategory> serviceCategoryFromJson(List<dynamic> data) {
  return List<ServiceCategory>.from(data.map((x) => ServiceCategory.fromJson(x)));
}

class ServiceCategory {
  String id;
  String name;
  bool status;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.status,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) =>
      ServiceCategory(
        id: json["id"],
        name: json["name"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
      };

  ServiceCategory copyWith({
    String? id,
    String? name,
    bool? status,
  }) {
    return ServiceCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
    );
  }
}
