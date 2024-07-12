import 'package:barassage_app/features/main_app/models/service_models/service_created_model.dart';
import 'package:barassage_app/features/main_app/models/service_models/service_create_model.dart';
import 'package:barassage_app/features/main_app/models/api_base_model.dart';
import 'package:barassage_app/config/api_endpoints.dart';
import 'package:barassage_app/config/app_http.dart';
import 'package:dio/dio.dart';


class ServiceServices {
  AppHttp http = AppHttp(headers: {
    'Content-Type': 'multipart/form-data',
  });
  Future<ServiceCreatedModel> create(ServiceCreateModel service) async {
    Response res = await http.post(
      ApiEndpoint.services,
      data: await service.toFormData(),
    );
    if (res.statusCode == 201) {
      ApiBaseModel apiResponse = ApiBaseModel.fromJson(res.data);
      return ServiceCreatedModel.fromJson(apiResponse.body);
    }
    throw res.data['message'];
  }

  static Future<List<ServiceCreatedModel>> getAll() async {
    Response res = await AppHttp().get(ApiEndpoint.servicesCollection);
    if (res.statusCode == 200) {
      List<ServiceCreatedModel> services = servicesFromJson(res.data);
      print(services);
      return services;
    }
    throw res.data['message'];
  }
}
