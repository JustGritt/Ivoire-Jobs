import 'package:barassage_app/features/main_app/models/main/report_model.dart';
import 'package:barassage_app/core/classes/app_context.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/config/api_endpoints.dart';
import 'package:barassage_app/config/app_cache.dart';
import 'package:barassage_app/config/app_http.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

AppCache appCache = serviceLocator<AppCache>();
AppContext appContext = serviceLocator<AppContext>();

class ReportsServiceProvider extends ChangeNotifier {
  List<Report> _reports = [];
  bool isLoading = false;
  final AppHttp _http = AppHttp();

  List<Report> get reports => _reports;

  Future<void> submitReport(String serviceId, String reason) async {
    isLoading = true;
    notifyListeners();
    try {
      final user = await appCache.getUser();
      if (user == null) {
        throw Exception("User not found in cache");
      }
      final token = await appCache.getToken();
      if (token == null) {
        throw Exception("Bearer token not found in cache");
      }
      print("Current user: ${user.id}");
      print("Submitting report for service ID: $serviceId");

      Response res = await _http.post(
        ApiEndpoint.report,
        data: {
          'reason': reason,
          'serviceId': serviceId,
        },
      );

      print("Res content: ${res}");

      if (res.statusCode == 201) {
        _reports.add(Report.fromJson(res.data['body']));
        print("Report submitted successfully");
      } else {
        print("Unexpected response format: ${res.data}");
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print("Error submitting report: ${e.response?.data}");
      } else {
        print("Error submitting report: $e");
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
