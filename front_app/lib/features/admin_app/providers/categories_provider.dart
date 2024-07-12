import 'package:barassage_app/features/admin_app/models/category.dart';
import 'package:flutter/material.dart';
import '../models/service.dart';
import '../services/admin_service.dart';

class CategoriesProvider with ChangeNotifier {
  final AdminService _adminService = AdminService();

  List<Category> _categories = [];
  bool _isLoading = false;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> getAllCategories() async {
    _isLoading = true;
    notifyListeners();
    try {
      _categories = (await _adminService.getCategories())!;
    } catch (e) {
      _categories = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCategory(String name) async {
    try {
      await _adminService.addCategory(name);
      notifyListeners();
    } catch (e) {
      print('Error: $e');
    }
  }
}