import 'package:flutter/material.dart';
import '../models/log.dart';
import '../services/admin_service.dart';

class LogsProvider with ChangeNotifier {
  final AdminService _adminService = AdminService();
  List<Log> _logs = [];
  bool _isLoading = false;
  int _currentPage = 1;
  int _totalPages = 1;

  List<Log> get logs => _logs;
  bool get isLoading => _isLoading;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  Future<List<Log>> getAllLogs({int page = 1}) async {
    _isLoading = true;
    notifyListeners();
    try {
      // var response = await _adminService.getLogs(page: page);
      /*_logs = response.logs;
      _currentPage = response.currentPage;
      _totalPages = response.totalPages;*/
      _logs = await _adminService.getLogs(page: page);
      return _logs;
    } catch (e) {
      _logs = [];
      return _logs;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void nextPage() {
    if (_currentPage < _totalPages) {
      _currentPage++;
      getAllLogs(page: _currentPage);
    }
  }

  void previousPage() {
    if (_currentPage > 1) {
      _currentPage--;
      getAllLogs(page: _currentPage);
    }
  }
}
