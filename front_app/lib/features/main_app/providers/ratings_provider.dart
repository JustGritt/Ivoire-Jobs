import 'package:barassage_app/features/main_app/models/main/rating_model.dart';
import 'package:barassage_app/core/classes/app_context.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/config/api_endpoints.dart';
import 'package:barassage_app/config/app_cache.dart';
import 'package:barassage_app/config/app_http.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

AppCache appCache = serviceLocator<AppCache>();
AppContext appContext = serviceLocator<AppContext>();

class RatingsProvider extends ChangeNotifier {
  List<Rating> _ratings = [];
  bool isLoading = false;
  final AppHttp _http = AppHttp();

  List<Rating> get ratings => _ratings;

  Future<List<Rating>> getAllRatings() async {
    isLoading = true;
    notifyListeners();
    try {
      Response res = await _http.get('${ApiEndpoint.ratings}/collection');
      if (res.statusCode == 200 && res.data is List) {
        _ratings = List<Rating>.from(res.data.map((item) => Rating.fromJson(item)));
      } else {
        print("Unexpected response format");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return _ratings;
  }

  Future<List<Rating>> getServiceRatings(String serviceId) async {
    print('Fetching ratings for service ID: $serviceId');
    isLoading = true;
    notifyListeners();
    List<Rating> ratings = [];
    try {
      Response res = await _http.get(ApiEndpoint.serviceRatings.replaceAll(':id', serviceId));
      print('URL: ${ApiEndpoint.serviceRatings.replaceAll(':id', serviceId)}');
      print('Response status: ${res.data}');
      if (res.statusCode == 200 && res.data is List) {
        ratings = List<Rating>.from(res.data.map((item) => Rating.fromJson(item)));
        _ratings = ratings;
        print(_ratings);
        print('Fetched ${_ratings.length} ratings');
        _ratings.forEach((rating) {
          print('Rating: ${rating.firstname}');
        });
      } else {
        print("Unexpected response format: ${res.data}");
      }
    } catch (e) {
      print("Error fetching ratings: $e");
    } finally {
      isLoading = false;
      notifyListeners();
      print('Ratings loading complete');
      print('Current ratings: $ratings');
    }
    return ratings;
  }

  Future<void> submitComment(String bookingId, String comment, int rating, String serviceId, String userId) async {
    try {
      Response res = await _http.post('${ApiEndpoint.ratings}',
        data: {
          'comment': comment,
          'rating': rating,
          'serviceId': serviceId,
          'userId': userId,
        },
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
