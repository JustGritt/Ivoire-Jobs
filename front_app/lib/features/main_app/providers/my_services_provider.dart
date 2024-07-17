import 'package:barassage_app/features/main_app/models/service_models/service_model.dart';
import 'package:barassage_app/features/main_app/models/service_models/service_category_model.dart';
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
  List<ServiceCategory> _categories = [];
  bool isLoading = false;
  bool hasNoServices = false;
  final AppHttp _http = AppHttp();

  List<ServiceModel> get services => _serviceModel;
  List<ServiceCategory> get categories => _categories;

  void getAll() async {
    isLoading = true;
    hasNoServices = false;
    try {
      final user = await appCache.getUser();
      inspect(user);
      if (user == null) {
        isLoading = false;
        notifyListeners();
        return;
      }
      Response res = await _http.get(ApiEndpoint.myServices.replaceAll(':id', user.id.toString()));
      if (res.statusCode == 200) {
        _serviceModel = serviceFromJson(res.data);
        hasNoServices = _serviceModel.isEmpty;
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

  Future<void> filterServices(String filter) async {
    if (filter == 'All') {
      getAll();
      return;
    }
    isLoading = true;
    hasNoServices = false;
    try {
      final user = await appCache.getUser();
      Response res = await _http.get('${ApiEndpoint.services}/search?categories=$filter');
      if (res.statusCode == 200) {
        _serviceModel = serviceFromJson(res.data);
        hasNoServices = _serviceModel.isEmpty;
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print(e);
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchService(String query) async {
    if (query == '') {
      getAll();
      return;
    }
    isLoading = true;
    hasNoServices = false;
    try {
      final user = await appCache.getUser();
      Response res = await _http.get('${ApiEndpoint.services}/search?name=$query');
      if (res.statusCode == 200) {
        _serviceModel = serviceFromJson(res.data);
        hasNoServices = _serviceModel.isEmpty;
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print(e);
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCategories() async {
    isLoading = true;
    try {
      Response res = await _http.get(ApiEndpoint.serviceCategories);
      if (res.statusCode == 200) {
        _categories = serviceCategoryFromJson(res.data);
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print(e);
      isLoading = false;
      notifyListeners();
    }
  }
}