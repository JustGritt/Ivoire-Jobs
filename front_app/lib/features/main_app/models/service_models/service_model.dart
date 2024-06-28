import 'package:barassage_app/core/helpers/services_helper.dart';
import 'package:flutter/foundation.dart';

List<ServiceModel> serviceFromJson(List<dynamic> data) {
  return List<ServiceModel>.from(data.map((x) => ServiceModel.fromJson(x)));
}

class ServiceModel {
  String address;
  List<String> category;
  String city;
  String country;
  String createdAt;
  String description;
  int duration;
  String id;
  List<String> images;
  bool isBanned;
  double latitude;
  double longitude;
  String name;
  String postalCode;
  double price;
  bool status;
  String userId;

  ServiceModel({
    required this.address,
    required this.category,
    required this.city,
    required this.country,
    required this.createdAt,
    required this.description,
    required this.duration,
    required this.id,
    required this.images,
    required this.isBanned,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.postalCode,
    required this.price,
    required this.status,
    required this.userId,
  });

  ServiceModel.fromJson(Map<String, dynamic> json)
      : address = json['address'],
        category = List<String>.from(json['category']),
        city = json['city'],
        country = json['country'],
        createdAt = json['createdAt'],
        description = json['description'],
        duration = json['duration'],
        id = json['id'],
        images = List<String>.from(json['images']),
        isBanned = json['isBanned'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        name = json['name'],
        postalCode = json['postalCode'],
        price = ServicesHelper.getFormattedPrice(json['price']),
        status = json['status'],
        userId = json['userId'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['category'] = category;
    data['city'] = city;
    data['country'] = country;
    data['createdAt'] = createdAt;
    data['description'] = description;
    data['duration'] = duration;
    data['id'] = id;
    data['images'] = images;
    data['isBanned'] = isBanned;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['name'] = name;
    data['postalCode'] = postalCode;
    data['price'] = price;
    data['status'] = status;
    data['userId'] = userId;

    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ServiceModel &&
        other.address == address &&
        listEquals(other.category, category) &&
        other.city == city &&
        other.country == country &&
        other.createdAt == createdAt &&
        other.description == description &&
        other.duration == duration &&
        other.id == id &&
        listEquals(other.images, images) &&
        other.isBanned == isBanned &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.name == name &&
        other.postalCode == postalCode &&
        other.price == price &&
        other.status == status &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return address.hashCode ^
        category.hashCode ^
        city.hashCode ^
        country.hashCode ^
        createdAt.hashCode ^
        description.hashCode ^
        duration.hashCode ^
        id.hashCode ^
        images.hashCode ^
        isBanned.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        name.hashCode ^
        postalCode.hashCode ^
        price.hashCode ^
        status.hashCode ^
        userId.hashCode;
  }
}
