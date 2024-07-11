import 'package:barassage_app/features/admin_app/models/service.dart';
import 'package:barassage_app/config/api_endpoints.dart';
import 'package:barassage_app/config/app_http.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class BannedServicesProvider extends ChangeNotifier {
  List<Service> _services = [];
  bool isLoading = false;
  final AppHttp _http = AppHttp();

  List<Service> get services => _services;

  Future<List<Service>> getAllBannedServices() async {
    isLoading = true;
    notifyListeners();
    try {
      Response res = await _http.get('${ApiEndpoint.services}/bans');
      if (res.statusCode == 200 && res.data is List) {
        _services =
            List<Service>.from(res.data.map((item) => Service.fromJson(item)));
        _services = _services.where((service) => service.isBanned).toList();
      } else {
        print("Unexpected response format");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return _services;
  }
}
