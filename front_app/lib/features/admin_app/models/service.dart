import 'package:barassage_app/features/admin_app/models/user.dart';

class Service {
  final String id;
  final String userId;
  final String name;
  final String description;
  final double price;
  final bool status;
  final int duration;
  final bool isBanned;
  final double latitude;
  final double longitude;
  final String address;
  final String city;
  final String postalCode;
  final String country;
  final List<String> images;
  final DateTime createdAt;
  final List<String> category;
  final User user;

  Service({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.price,
    required this.status,
    required this.duration,
    required this.isBanned,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.images,
    required this.createdAt,
    required this.category,
    required this.user,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      status: json['status'] ?? false,
      duration: json['duration'] ?? 0,
      isBanned: json['isBanned'] ?? false,
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      postalCode: json['postalCode'] ?? '',
      country: json['country'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      category: json['category'] != null ? List<String>.from(json['category']) : [],
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'price': price,
      'status': status,
      'duration': duration,
      'isBanned': isBanned,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'city': city,
      'postalCode': postalCode,
      'country': country,
      'images': images,
      'createdAt': createdAt.toIso8601String(),
      'category': category,
      'user': user.toJson(),
    };
  }
}
