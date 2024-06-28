class ServiceCreatedModel {
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
  final String createdAt;
  final List<String> category;

  ServiceCreatedModel({
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
  });

  factory ServiceCreatedModel.fromJson(Map<String, dynamic> json) {
    return ServiceCreatedModel(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as int).toDouble(),
      status: json['status'],
      duration: json['duration'],
      isBanned: json['isBanned'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      city: json['city'],
      postalCode: json['postalCode'],
      country: json['country'],
      images: (json['images'] as List<dynamic>).map((e) => e.toString()).toList(),
      createdAt: json['createdAt'],
      category: (json['category'] as List<dynamic>).map((e) => e.toString()).toList(),
    );
  }
}
