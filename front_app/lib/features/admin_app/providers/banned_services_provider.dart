import 'package:barassage_app/features/admin_app/models/service.dart';
import 'package:barassage_app/config/api_endpoints.dart';
import 'package:barassage_app/config/app_http.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class BannedServicesProvider extends ChangeNotifier {
  List<Service> _services = [];
  bool isLoading = false;
  String errorMessage = '';
  final AppHttp _http = AppHttp();

  List<Service> get services => _services;

  Future<List<Service>> getAllBannedServices() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();
    try {
      Response res = await _http.get('${ApiEndpoint.services}/bans');
      if (res.statusCode == 200 && res.data is List) {
        _services = List<Service>.from(res.data.map((item) => Service.fromJson(item)));
      } else {
        errorMessage = "No banned services found";
      }
    } catch (e) {
      errorMessage = "Error fetching banned services: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return _services;
  }

  // Unban a service by id
  Future<void> unbanService(String id) async {
    try {
      Response res = await _http.put('${ApiEndpoint.services}/$id', data: {
        'name': _services.firstWhere((service) => service.id == id).name,
        'description': _services.firstWhere((service) => service.id == id).description,
        'price': _services.firstWhere((service) => service.id == id).price,
        'duration': _services.firstWhere((service) => service.id == id).duration,
        'is_banned': false
      });
      _services.removeWhere((service) => service.id == id);
      notifyListeners();
    } catch (e) {
      errorMessage = "Error unbanning service: $e";
      notifyListeners();
    }
  }
}
