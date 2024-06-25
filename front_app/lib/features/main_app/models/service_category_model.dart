import 'dart:convert';

enum ServiceCategoryStatus { active, inactive }


List<ServiceCategory> serviceCategoryFromJson(String str) =>
    List<ServiceCategory>.from(json.decode(str).map((x) => ServiceCategory.fromJson(x)));

class ServiceCategory {
  String id;
  String name;
  ServiceCategoryStatus status;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.status,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) =>
      ServiceCategory(
        id: json["id"],
        name: json["name"],
        status: json["status"] == "active"
            ? ServiceCategoryStatus.active
            : ServiceCategoryStatus.inactive,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
      };

  ServiceCategory copyWith({
    String? id,
    String? name,
    ServiceCategoryStatus? status,
  }) {
    return ServiceCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
    );
  }
}
