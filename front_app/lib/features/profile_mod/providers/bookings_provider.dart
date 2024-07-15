import 'package:barassage_app/features/profile_mod/models/booking.dart';
import 'package:barassage_app/config/api_endpoints.dart';
import 'package:barassage_app/config/app_http.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class BookingsProvider extends ChangeNotifier {
  List<Booking> _bookings = [];
  bool isLoading = false;
  final AppHttp _http = AppHttp();

  List<Booking> get bookings => _bookings;

  Future<void> fetchBookingsForCurrentUser() async {
    isLoading = true;
    notifyListeners();
    try {
      Response res = await _http.get(ApiEndpoint.bookings); // Adjust this endpoint as necessary
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
  }

  Future<void> submitComment(String bookingId, String comment, int rating) async {
    try {
      Response res = await _http.post(
        '${ApiEndpoint.bookings}/$bookingId/comments',
        data: {'comment': comment, 'rating': rating},
      );
      if (res.statusCode == 200) {
        print("Comment and rating submitted successfully");
      } else {
        print("Failed to submit comment and rating: ${res.statusCode}");
      }
    } catch (e) {
      print("Error submitting comment and rating: $e");
    }
  }
}
