import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:dio/dio.dart';

import '../../../config/api_endpoints.dart';
import '../../../config/app_http.dart';

class ServiceCategoryService {
  String? token;
  ServiceCategoryService({this.token});
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl,
  );

  Future<User?> getAll() async {
    Response res = await _http.get(ApiEndpoint.serviceCategories);
    if (res.statusCode == 200) {
      User user = User.fromJson(res.data);
      return user;
    }
    return null;
  }
}
