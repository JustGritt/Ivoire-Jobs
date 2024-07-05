import 'package:barassage_app/config/api_endpoints.dart';
import 'package:barassage_app/config/app_cache.dart';
import 'package:barassage_app/config/app_http.dart';
import 'package:barassage_app/core/classes/app_context.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:barassage_app/features/admin_app/models/service.dart';

AppCache appCache = serviceLocator<AppCache>();
AppContext appContext = serviceLocator<AppContext>();

class BannedServicesProvier extends ChangeNotifier {
  List<Service> _services = [];
  bool isLoading = false;
  final AppHttp _http = AppHttp();

  List<Service> get services => _services;

  // Handle fetching all banned services
  Future<List<Service>> getAllBannedServices() async {
    isLoading = true;
    notifyListeners();
    List<Service> bannedServices = [];
    try {
      Response res = await _http.get('${ApiEndpoint.services}/bans');
      if (res.statusCode == 200 && res.data is List) {
        print(res.data);
        _services = List<Service>.from(res.data.map((item) => Service.fromJson(item)));
        bannedServices = _services.where((service) => service.isBanned).toList();
      } else {
        print("Unexpected response format");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return bannedServices;
  }
}
