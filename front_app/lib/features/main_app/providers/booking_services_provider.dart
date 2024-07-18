import 'package:barassage_app/features/main_app/models/service_models/booking_service_model/booking_service_created_model.dart';
import 'package:barassage_app/features/main_app/models/service_models/booking_service_model/booking_service_create_model.dart';
import 'package:barassage_app/features/main_app/services/booking_service_services.dart';
import 'package:barassage_app/features/main_app/models/request_info_base_model.dart';
import 'package:barassage_app/core/exceptions/dio_exceptions.dart';
import 'package:barassage_app/core/widgets/toast_message.dart';
import 'package:barassage_app/core/classes/app_context.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/config/app_cache.dart';
import 'package:barassage_app/config/app_http.dart';
import 'package:barassage_app/features/payments/stripe/stripe_service.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

AppCache appCache = serviceLocator<AppCache>();
AppContext appContext = serviceLocator<AppContext>();
BookingServiceServices bookingServiceServices =
    serviceLocator<BookingServiceServices>();

class BookingServicesProvider extends ChangeNotifier {
  RequestInfoBaseModel<BookingServiceCreatedModel> bookingServiceRequest =
      RequestInfoBaseModel<BookingServiceCreatedModel>();
  final AppHttp _http = AppHttp();

  Future<BookingServiceCreatedModel> createBooking(
      BookingServiceCreateModel bookingServiceCreateModel) async {
    bookingServiceRequest.isLoading = true;
    notifyListeners();
    try {
      final booking =
          await bookingServiceServices.create(bookingServiceCreateModel);
      final result =
          await StripeService.presentPaymentSheet(booking.paymentIntent);
      bookingServiceRequest.isLoading = false;
      notifyListeners();
      return booking;
    } catch (error) {
      bookingServiceRequest.isLoading = false;
      print(error);
      if (error is DioException) {
        showError(
            appContext.navigatorContext, DioExceptionHandler(error).title);
      }
      notifyListeners();
      rethrow;
    }
  }
}
