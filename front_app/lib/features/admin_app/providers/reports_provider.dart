import 'package:barassage_app/config/api_endpoints.dart';
import 'package:barassage_app/config/app_cache.dart';
import 'package:barassage_app/config/app_http.dart';
import 'package:barassage_app/core/classes/app_context.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:barassage_app/features/admin_app/models/report.dart';

AppCache appCache = serviceLocator<AppCache>();
AppContext appContext = serviceLocator<AppContext>();

class ReportsProvider extends ChangeNotifier {
  List<Report> _reports = [];
  bool isLoading = false;
  final AppHttp _http = AppHttp();

  List<Report> get reports => _reports;

  // Handle fetching all reports
  Future<List<Report>> getAllReports() async {
    isLoading = true;
    notifyListeners();
    try {
      Response res = await _http.get(ApiEndpoint.reports);
      if (res.statusCode == 200 && res.data is List) {
        _reports = List<Report>.from(res.data.map((item) => Report.fromJson(item)));
      } else {
        print("Unexpected response format");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return _reports;
  }

  Future<void> updateReportStatus(Report report) async {
    try {
      Response res = await _http.put(
          '${ApiEndpoint.reportsDetails.replaceAll(':id', report.id)}',
          data: {'status': !report.status});
      if (res.statusCode == 200) {
        final index = _reports.indexWhere((r) => r.id == report.id);
        if (index != -1) {
          _reports[index].status = !report.status;
          print("Report status updated successfully");
          notifyListeners();
        }
      } else {
        print("Unexpected response format");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
