import 'dart:developer';

import 'package:barassage_app/config/app_cache.dart';
import 'package:barassage_app/core/classes/app_context.dart';
import 'package:barassage_app/core/exceptions/dio_exceptions.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/core/widgets/toast_message.dart';
import 'package:barassage_app/features/bookings_mod/models/booking_appointment.dart';
import 'package:barassage_app/features/bookings_mod/services/bookings_services.dart';
import 'package:barassage_app/features/main_app/models/request_info_base_model.dart';
import 'package:barassage_app/features/main_app/models/service_models/booking_service_model/booking_service_created_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

AppCache appCache = serviceLocator<AppCache>();
AppContext appContext = serviceLocator<AppContext>();
BookingsServices bookingServices = serviceLocator<BookingsServices>();

class BookingServicesProvider extends ChangeNotifier {
  RequestInfoBaseModel<List<BookingAppointment>> bookingServiceRequest =
      RequestInfoBaseModel<List<BookingAppointment>>(data: []);

  Future<void> getAllBookings() async {
    bookingServiceRequest.isLoading = true;
    try {
      final bookings = await bookingServices.getAll();
      bookingServiceRequest.isLoading = false;
      bookingServiceRequest.data = bookings.where((element) {
        return element.status == BookingStatus.fulfilled;
      }).toList();
      notifyListeners();
    } catch (error) {
      bookingServiceRequest.isLoading = false;
      print(error);
      if (error is DioException) {
        showError(
            appContext.navigatorContext, DioExceptionHandler(error).title);
      } else if (error is Exception) {
        showError(appContext.navigatorContext, error.toString());
      }
      notifyListeners();
      rethrow;
    }
  }
}
