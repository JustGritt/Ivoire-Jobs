import 'package:barassage_app/features/main_app/models/service_category_model.dart';
import 'package:dio/dio.dart';

import '../../../config/api_endpoints.dart';
import '../../../config/app_http.dart';

class ServiceCategoryService {
  String? token;
  ServiceCategoryService({this.token});
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
  );

  Future<List<ServiceCategory>> getAll() async {
    Response res = await _http.get(ApiEndpoint.serviceCategories);
    if (res.statusCode == 200) {
      List<ServiceCategory> serviceCategory = serviceCategoryFromJson(res.data);
      return serviceCategory;
    }
    return [];
  }
}
