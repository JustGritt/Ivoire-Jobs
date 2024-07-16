import 'package:barassage_app/features/main_app/models/service_models/booking_service_model/booking_service_created_model.dart';
import 'package:barassage_app/features/main_app/models/service_models/booking_service_model/booking_service_create_model.dart';
import 'package:barassage_app/config/api_endpoints.dart';
import 'package:barassage_app/config/app_http.dart';
import 'package:dio/dio.dart';

class BookingServiceServices {
  AppHttp http = AppHttp();
  Future<BookingServiceCreatedModel> create(
      BookingServiceCreateModel booking) async {
    Response res = await http.post(
      ApiEndpoint.bookingServices,
      data: await booking.toJson(),
    );
    if (res.statusCode == 201) {
      return BookingServiceCreatedModel.fromJson(res.data);
    }
    throw res.data['message'];
  }
}
