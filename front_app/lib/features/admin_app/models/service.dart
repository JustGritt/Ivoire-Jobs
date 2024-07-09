import 'package:barassage_app/features/admin_app/models/category.dart';
import 'package:barassage_app/features/auth_mod/models/user.dart';

class Service {
  String id;
  String title;
  String description;
  String image;
  String price;
  String duration;
  String status;
  bool isBanned;
  DateTime createdAt;
  DateTime updatedAt;
  Category? category;
  User? user;

  Service({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.duration,
    required this.status,
    required this.isBanned,
    required this.createdAt,
    required this.updatedAt,
    this.category,
    this.user,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? '',
      title: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      price: json['price'].toString(), // Ensuring price is a string
      duration: json['duration'].toString(), // Ensuring duration is a string
      status: json['status'].toString(), // Ensuring status is a string
      isBanned: json['isBanned'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
      category: json['category'] != null && json['category'].isNotEmpty ? Category.fromJson(json['category']) : null,
      user: json['user'] != null && json['user'].isNotEmpty ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': title,
      'description': description,
      'image': image,
      'price': price,
      'duration': duration,
      'status': status,
      'isBanned': isBanned,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'category': category?.toJson(),
      'user': user?.toJson(),
    };
  }
}
