import 'package:barassage_app/features/profile_mod/models/booking.dart';
import 'package:barassage_app/core/classes/app_context.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/config/api_endpoints.dart';
import 'package:barassage_app/config/app_cache.dart';
import 'package:barassage_app/config/app_http.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

AppCache appCache = serviceLocator<AppCache>();
AppContext appContext = serviceLocator<AppContext>();

class BookingsProvider extends ChangeNotifier {
  List<Booking> _bookings = [];
  bool isLoading = false;
  final AppHttp _http = AppHttp();

  List<Booking> get bookings => _bookings;

  Future<List<Booking>> GetBookings() async {
    isLoading = true;
    notifyListeners();
    try {
      Response res = await _http.get(ApiEndpoint.bookings);
      print('Response status: ${res.data}');
      if (res.statusCode == 200 && res.data is List) {
        _bookings = List<Booking>.from(res.data.map((item) => Booking.fromJson(item)));
      } else {
        print("Unexpected response format");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return _bookings;
  }

  Future<List<Booking>> getUserBookings(String userId) async {
    print('Fetching bookings for service ID: $userId');
    isLoading = true;
    notifyListeners();
    List<Booking> bookings = [];
    try {
      Response res = await _http.get(ApiEndpoint.userBookings.replaceAll(':id', userId));
      print('URL: ${ApiEndpoint.userBookings.replaceAll(':id', userId)}');
      print('Response status: ${res.data}');
      if (res.statusCode == 200 && res.data is List) {
        bookings = List<Booking>.from(res.data.map((item) => Booking.fromJson(item)));
        _bookings = bookings;
        print(_bookings);
        print('Fetched ${_bookings.length} bookings');
      } else {
        print("Unexpected response format: ${res.data}");
      }
    } catch (e) {
      print("Error fetching bookings: $e");
    } finally {
      isLoading = false;
      notifyListeners();
      print('Bookings loading complete');
      print('Current bookings: $bookings');
    }
    return bookings;
  }
}
