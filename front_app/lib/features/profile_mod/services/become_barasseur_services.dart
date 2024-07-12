import 'package:barassage_app/core/helpers/utils_helper.dart';
import 'package:barassage_app/core/classes/app_context.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/config/api_endpoints.dart';
import 'package:barassage_app/config/app_http.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

BuildContext context = serviceLocator<AppContext>().navigatorContext;

class BecomeBarasseurService {
  BecomeBarasseurService();
  final AppHttp _http = AppHttp();

  Future<void> sendRequest(String reason) async {
    try {
      Response res = await _http.post(ApiEndpoint.becomeBarasseur, data: {"reason": reason});
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
