import 'package:barassage_app/core/blocs/authentication/authentication_bloc.dart';
import 'package:barassage_app/core/classes/app_context.dart';
import 'package:barassage_app/core/helpers/utils_helper.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/api_endpoints.dart';
import '../../../config/app_http.dart';

BuildContext context = serviceLocator<AppContext>().navigatorContext;

class BookingsService {
  final AppHttp _http = AppHttp();

  Future<void> getAll(String reason) async {
    try {
      Response res = await _http
          .get(ApiEndpoint.becomeBarasseur);
      if (res.statusCode == 201) {
        showMyDialog(context,
            title: 'Success',
            content: 'Your request has been sent successfully');
        context.pop();
        return;
      }
      throw res.data['message'];
    } catch (e) {
      print(e);
      showMyDialog(context, content: e.toString(), title: 'Error');
      debugPrint(e.toString());
    }
  }
}
