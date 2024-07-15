import 'package:flutter/material.dart';
import 'package:barassage_app/features/admin_app/models/category.dart';
import 'package:barassage_app/features/admin_app/services/admin_service.dart';

class CategoriesProvider with ChangeNotifier {
  final AdminService _adminService = AdminService();

  List<Category> _categories = [];
  bool _isLoading = false;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<List<Category>> getAllCategories() async {
    _isLoading = true;
    notifyListeners();
    try {
      _categories = (await _adminService.getCategories());
      debugPrint('categories: $_categories');
      return _categories;
    } catch (e) {
      _categories = [];
      return _categories;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCategory(String name) async {
    try {
      await _adminService.addCategory(name);
      await getAllCategories(); // Fetch the updated list of categories
    } catch (e) {
      // Handle any errors that might occur
      debugPrint('Error adding category: $e');
    }
  }
}
