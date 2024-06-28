import 'package:barassage_app/features/main_app/models/api_base_model.dart';
import 'package:barassage_app/features/main_app/models/service_models/service_create_model.dart';
import 'package:barassage_app/features/main_app/models/service_models/service_created_model.dart';
import 'package:dio/dio.dart';

import '../../../config/api_endpoints.dart';
import '../../../config/app_http.dart';



class ServiceServices {
  Future<ServiceCreatedModel> create(ServiceCreateModel service) async {
    AppHttp http = AppHttp(
      headers: {
        'Content-Type': 'multipart/form-data',
      }
    );
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
}
