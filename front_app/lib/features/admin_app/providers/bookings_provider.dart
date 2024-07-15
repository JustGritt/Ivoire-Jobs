import 'package:barassage_app/features/admin_app/models/booking.dart';
import 'package:flutter/material.dart';
import 'package:barassage_app/features/admin_app/services/admin_service.dart';

class BookingsProvider with ChangeNotifier {
  final AdminService _adminService = AdminService();

  List<Booking> _bookings = [];
  bool _isLoading = false;

  List<Booking> get bookings => _bookings;
  bool get isLoading => _isLoading;

  Future<void> getBookings() async {
    _isLoading = true;
    notifyListeners();
    try {
      _bookings = await _adminService.getBookings();
      print('BookingsProvider - bookings: $_bookings');
    } catch (e) {
      print('Error in BookingsProvider: $e');
      _bookings = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
