import 'package:barassage_app/features/main_app/models/service_models/service_model.dart';
import 'package:barassage_app/core/helpers/utils_helper.dart';
import 'package:barassage_app/core/classes/app_context.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/config/api_endpoints.dart';
import 'package:barassage_app/config/app_cache.dart';
import 'package:barassage_app/config/app_http.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'dart:developer';

AppCache appCache = serviceLocator<AppCache>();
AppContext appContext = serviceLocator<AppContext>();

class MyServicesProvider extends ChangeNotifier {
  List<ServiceModel> _serviceModel = [];
  bool isLoading = false;
  final AppHttp _http = AppHttp();

  List<ServiceModel> get services => _serviceModel;

  void getAll() async {
    isLoading = true;
    try {
      final user = await appCache.getUser();
      inspect(user);
      if (user == null) {
        isLoading = false;
        notifyListeners();
        return;
      }
      Response res = await _http
          .get(ApiEndpoint.myServices.replaceAll(':id', user.id.toString()));
      if (res.statusCode == 200) {
        _serviceModel = serviceFromJson(res.data);
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print(e);
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteService(String id) async {
    isLoading = true;
    try {
      Response res = await _http.delete(
          ApiEndpoint.serviceDetails.replaceAll(':id', id),
          params: {"serviceId": id});
      if (res.statusCode == 200) {
        _serviceModel.removeWhere((element) => element.id == id);
        isLoading = false;
        return true;
      }
      throw res.data['message'];
    } catch (e) {
      isLoading = false;
      showMyDialog(appContext.navigatorContext,
          title: 'Service', content: 'An error occured while deleting service');
      return false;
    }
  }
}
