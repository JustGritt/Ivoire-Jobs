import 'package:barassage_app/core/classes/app_context.dart';
import 'package:barassage_app/core/helpers/utils_helper.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/features/bookings_mod/models/booking_appointment.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../config/api_endpoints.dart';
import '../../../config/app_http.dart';

BuildContext context = serviceLocator<AppContext>().navigatorContext;

class BookingsServices {
  final AppHttp _http = AppHttp();

  Future<List<BookingAppointment>> getAll() async {
    try {
      Response res = await _http.get(ApiEndpoint.bookings);
      if (res.statusCode == 200) {
        return BookingAppointment.fromJsonList(res.data);
      }
      throw res.data['message'];
    } catch (e) {
      print(e);
      showMyDialog(context, content: e.toString(), title: 'Error');
      debugPrint(e.toString());
      rethrow;
    }
  }
}
