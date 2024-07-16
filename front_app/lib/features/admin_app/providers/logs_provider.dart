import 'package:barassage_app/features/admin_app/models/logResponse.dart';
import 'package:flutter/material.dart';
import '../services/admin_service.dart';

class LogsProvider with ChangeNotifier {
  final AdminService _adminService = AdminService();
  LogResponse _logs = LogResponse(
    first: false,
    last: false,
    max_page: 0,
    page: 0,
    size: 0,
    total: 0,
    visible: 0,
    items: [],
    currentPage: 0,
    totalPages: 0,
  );
  bool _isLoading = false;
  int _currentPage = 1;
  int _totalPages = 1;

  LogResponse get logs => _logs;
  bool get isLoading => _isLoading;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  Future<void> getAllLogs({int page = 1}) async {
    _isLoading = true;
    notifyListeners();
    try {
      _logs = await _adminService.getLogs(page: page);
      debugPrint('logs: ${_logs.items.length}');
      _currentPage = _logs.currentPage;
      _totalPages = _logs.totalPages;
    } catch (e) {
      print('Error in LogsProvider: $e');
      _logs = LogResponse(
        first: false,
        last: false,
        max_page: 0,
        page: 0,
        size: 0,
        total: 0,
        visible: 0,
        items: [],
        currentPage: 0,
        totalPages: 0,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void nextPage() {
    if (_currentPage < _totalPages) {
      getAllLogs(page: ++_currentPage);
    }
  }

  void previousPage() {
    if (_currentPage > 1) {
      getAllLogs(page: --_currentPage);
    }
  }

  void jumpToPage(int page) {
    if (page > 0 && page <= _totalPages) {
      getAllLogs(page: page);
    }
  }
}