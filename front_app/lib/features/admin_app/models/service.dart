class Service {
  final String id;
  final String userId;
  final String title;
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

  Service({
    required this.id,
    required this.userId,
    required this.title,
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

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
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
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      category: json['category'] != null ? List<String>.from(json['category']) : [],
    );
  }
}