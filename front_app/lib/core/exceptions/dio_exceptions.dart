import 'package:barassage_app/features/auth_mod/services/api_exceptions.dart';
import 'package:dio/dio.dart';

class DioExceptionHandler implements Exception {
  final DioException error;

  DioExceptionHandler(this.error);

  String get title {
    if (error.type == DioExceptionType.connectionTimeout) {
      return 'Connection Timeout';
    } else if (error.type == DioExceptionType.sendTimeout) {
      return 'Send Timeout';
    } else if (error.type == DioExceptionType.receiveTimeout) {
      return 'Receive Timeout';
    } else if (error.type == DioExceptionType.badResponse) {
      return error.response?.data is Map
          ? (APIException.fromJson(error.response?.data).errors[0].message)
          : 'Bad Response';
    } else if (error.type == DioExceptionType.cancel) {
      return 'Request Cancelled';
    } else {
      return 'Server Error';
    }
  }

  @override
  String toString() {
    return '$title: ${error.message}';
  }
}
