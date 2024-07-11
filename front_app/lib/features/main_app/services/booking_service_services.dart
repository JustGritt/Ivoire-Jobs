import 'package:barassage_app/features/main_app/models/api_base_model.dart';
import 'package:barassage_app/features/main_app/models/service_models/booking_service_model/booking_service_created_model.dart';
import 'package:dio/dio.dart';

import '../../../config/api_endpoints.dart';
import '../../../config/app_http.dart';
import '../models/service_models/booking_service_model/booking_service_create_model.dart';

class BookingServiceServices {
  AppHttp http = AppHttp();
  Future<BookingServiceCreatedModel> create(BookingServiceCreateModel booking) async {
    Response res = await http.post(
      ApiEndpoint.bookingServices,
      data: await booking.toJson(),
    );
    if (res.statusCode == 201) {
      ApiBaseModel apiResponse = ApiBaseModel.fromJson(res.data);
      return BookingServiceCreatedModel.fromJson(apiResponse.body);
    }
    throw res.data['message'];
  }
}
