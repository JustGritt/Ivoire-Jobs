import 'package:barassage_app/features/admin_app/models/category.dart';
import 'package:barassage_app/features/auth_mod/models/user.dart';

class Service {
  String title;
  String description;
  String image;
  String price;
  String duration;
  String status;
  bool isBanned = false;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
  Category category;
  User user;
  String id;

  Service(
      {required this.title,
      required this.description,
      required this.image,
      required this.price,
      required this.duration,
      required this.status,
      required this.isBanned,
      required this.createdAt,
      required this.updatedAt,
      required this.category,
      required this.user,
      required this.id});

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        title: json['name'],
        description: json['description'],
        image: json['image'],
        price: json['price'],
        duration: json['duration'],
        status: json['status'],
        isBanned: json['isBanned'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        category: Category.fromJson(json['category']),
        user: User.fromJson(json['user']),
        id: json['id'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = title;
    data['description'] = description;
    data['image'] = image;
    data['price'] = price;
    data['duration'] = duration;
    data['status'] = status;
    data['isBanned'] = isBanned;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['category'] = category.toJson();
    data['user'] = user.toJson();
    data['id'] = id;
    return data;
  }
}
