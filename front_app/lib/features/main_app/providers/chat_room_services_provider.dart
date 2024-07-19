import 'package:barassage_app/core/helpers/utils_helper.dart';
import 'package:barassage_app/features/bookings_mod/models/chats_room_model.dart';
import 'package:barassage_app/features/main_app/services/booking_service_services.dart';
import 'package:barassage_app/features/main_app/models/request_info_base_model.dart';
import 'package:barassage_app/core/exceptions/dio_exceptions.dart';
import 'package:barassage_app/core/widgets/toast_message.dart';
import 'package:barassage_app/core/classes/app_context.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/config/app_cache.dart';
import 'package:barassage_app/config/app_http.dart';
import 'package:barassage_app/features/main_app/services/chat_room_service_services.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

AppCache appCache = serviceLocator<AppCache>();
AppContext appContext = serviceLocator<AppContext>();
BookingServiceServices bookingServiceServices =
    serviceLocator<BookingServiceServices>();

class ChatRoomServicesProvider extends ChangeNotifier {
  RequestInfoBaseModel<ChatRoom> bookingServiceRequest =
      RequestInfoBaseModel<ChatRoom>();
  final AppHttp _http = AppHttp();

  Future<ChatRoom?> createRoom(String serviceId) async {
    bookingServiceRequest.isLoading = true;
    notifyListeners();
    try {
      ChatRoomServiceServices chatRoomServices = ChatRoomServiceServices();
      final booking = await chatRoomServices.createOrGet(serviceId);
      bookingServiceRequest.isLoading = false;
      notifyListeners();
      return booking;
    } catch (error) {
      bookingServiceRequest.isLoading = false;
      print(error);
      if (error is DioException) {
        showError(
            appContext.navigatorContext, DioExceptionHandler(error).title);
      } else if (error is Exception) {
        showError(appContext.navigatorContext, error.toString());
      }
      showMyDialog(appContext.navigatorContext,
          content: error.toString(), title: 'Error');
      notifyListeners();
      return null;
    }
  }
}
