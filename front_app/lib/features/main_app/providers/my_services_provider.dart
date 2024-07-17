import 'package:barassage_app/features/main_app/models/service_models/service_category_model.dart';
import 'package:barassage_app/features/main_app/models/service_models/service_created_model.dart';
import 'package:barassage_app/core/helpers/utils_helper.dart';
import 'package:barassage_app/core/classes/app_context.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/config/api_endpoints.dart';
import 'package:barassage_app/config/app_cache.dart';
import 'package:barassage_app/config/app_http.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'dart:developer';

AppCache appCache = serviceLocator<AppCache>();
AppContext appContext = serviceLocator<AppContext>();

class MyServicesProvider extends ChangeNotifier {
  List<ServiceCreatedModel> _serviceModel = [];
  List<ServiceCategory> _categories = [];
  bool isLoading = false;
  bool hasNoServices = false;
  final AppHttp _http = AppHttp();

  List<ServiceCreatedModel> get services => _serviceModel;
  List<ServiceCategory> get categories => _categories;

  void getAll() async {
    isLoading = true;
    hasNoServices = false;
    notifyListeners();
    try {
      final user = await appCache.getUser();
      inspect(user);
      if (user == null) {
        isLoading = false;
        notifyListeners();
        return;
      }
      Response res = await _http.get(ApiEndpoint.servicesCollection);
      if (res.statusCode == 200) {
        _serviceModel = servicesFromJson(res.data);
        hasNoServices = _serviceModel.isEmpty;
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteService(String id) async {
    isLoading = true;
    notifyListeners();
    try {
      Response res = await _http.delete(
          ApiEndpoint.serviceDetails.replaceAll(':id', id),
          params: {"serviceId": id});
      if (res.statusCode == 200) {
        _serviceModel.removeWhere((element) => element.id == id);
        return true;
      }
      throw res.data['message'];
    } catch (e) {
      print(e);
      showMyDialog(appContext.navigatorContext,
          title: 'Service',
          content: 'An error occurred while deleting service');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> filterServices(String filter) async {
    isLoading = true;
    hasNoServices = false;
    notifyListeners();
    if (filter == 'All') {
      getAll();
      return;
    }
    try {
      final user = await appCache.getUser();
      Response res =
          await _http.get('${ApiEndpoint.services}/search?categories=$filter');
      if (res.statusCode == 200) {
        _serviceModel = servicesFromJson(res.data);
        hasNoServices = _serviceModel.isEmpty;
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        _serviceModel = [];
        hasNoServices = true;
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchService(String query) async {
    isLoading = true;
    hasNoServices = false;
    notifyListeners();
    if (query.isEmpty) {
      getAll();
      return;
    }
    try {
      final user = await appCache.getUser();
      Response res =
          await _http.get('${ApiEndpoint.services}/search?name=$query');
      if (res.statusCode == 200) {
        _serviceModel = servicesFromJson(res.data);
        hasNoServices = _serviceModel.isEmpty;
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCategories() async {
    isLoading = true;
    notifyListeners();
    try {
      Response res = await _http.get(ApiEndpoint.serviceCategories);
      if (res.statusCode == 200) {
        _categories = serviceCategoryFromJson(res.data as List<dynamic>);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getNearbyServices() async {
    isLoading = true;
    notifyListeners();
    try {
      final user = await appCache.getUser();
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print(position.latitude);
      print(position.longitude);
      Response res = await _http.get('${ApiEndpoint.services}/search', params: {
        "latitude": position.latitude,
        "longitude": position.longitude,
        // "latitude": 48.8488336,
        // "longitude": 32.3891768
      });
      print(res.data);
      if (res.statusCode == 200) {
        _serviceModel = servicesFromJson(res.data);
        hasNoServices = _serviceModel.isEmpty;
      }
    } catch (e) {
      print(e);
      _serviceModel = [];
      hasNoServices = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
