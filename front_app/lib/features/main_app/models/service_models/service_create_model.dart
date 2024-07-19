import 'package:barassage_app/features/main_app/models/service_models/service_category_model.dart';
import 'package:barassage_app/features/main_app/models/location_service.dart';
import 'package:dio/dio.dart';
import 'dart:io';

List<String> serviceCategoryToJson(List<ServiceCategory> data) {
  return data.map((e) => e.id).toList();
}

class ServiceCreateModel extends LocationService {
  final List<ServiceCategory> categories;
  final String title;
  final String description;
  final double price;
  final int duration;
  final List<File> illustrations;

  ServiceCreateModel(
      {required super.latitude,
      required super.longitude,
      required super.city,
      required super.address,
      required this.categories,
      required this.title,
      required this.description,
      required this.price,
      required this.illustrations,
      required this.duration,
      super.postCode,
      super.country});

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      "latitude": latitude,
      "longitude": longitude,
      "postalCode": postCode,
      "country": country,
      "city": city,
      "address": address,
      "categoryIds": serviceCategoryToJson(categories),
      "name": title,
      "description": description,
      "duration": duration,
      "price": price,
      "images":
          illustrations.map((e) => MultipartFile.fromFileSync(e.path)).toList(),
    });
  }
}
