import 'package:barassage_app/features/lead_mod/models/enquery_get_models.dart';
import 'package:barassage_app/config/api_endpoints.dart';
import 'package:barassage_app/config/app_config.dart';
import 'package:barassage_app/config/app_http.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../config/api_endpoints.dart';
import '../../../config/app_config.dart';
import '../../../config/app_http.dart';
import '../models/enquery_get_models.dart';

class EnqueryService {
  final AppHttp _http = AppHttp(
    baseUrl: ApiEndpoint.baseUrl
  );

  Future<Enquery?> getAll() async {
    Response res = await _http.get(ApiEndpoint.enqueries);
    if (res.statusCode == 200) {
      Enquery enquery = Enquery.fromJson(jsonEncode(res.data));
      return enquery;
    }
    return null;
  }

  Future<EnquerySingle?> getOne(int id) async {
    Response res = await _http.get(
      '${ApiEndpoint.enquery}/$id?populate=*',
    );
    if (res.statusCode == 200) {
      EnquerySingle enquery = EnquerySingle.fromJson(jsonEncode(res.data));
      return enquery;
    }
    return null;
  }

  Future<EnquerySingle?> create(Lead lead) async {
    Map<String, dynamic> _data = {
      'data': {
        'purpose': lead.purpose!.toString(),
        'customer_name': lead.customer_name!.toString(),
        'customer_email': lead.customer_email!.toString(),
        'customer_mobile': lead.customer_mobile!.toString(),
        'source': lead.source!.toString(),
        'status': lead.status!.toString(),
      }
    };
    Response res = await _http.post(
      ApiEndpoint.enquery,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
      data: jsonEncode(_data),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      EnquerySingle enquery = EnquerySingle.fromJson(jsonEncode(res.data));
      return enquery;
    }
    return null;
  }

  Future<EnquerySingle?> update(int id, Lead lead) async {
    Map<String, dynamic> _data = {
      'data': {
        'purpose': lead.purpose!.toString(),
        'customer_name': lead.customer_name!.toString(),
        'customer_email': lead.customer_email!.toString(),
        'customer_mobile': lead.customer_mobile!.toString(),
        'source': lead.source!.toString(),
        'status': lead.status!.toString(),
      }
    };
    Response res = await _http.put(
      '${ApiEndpoint.enquery}/$id',
      data: jsonEncode(_data),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      EnquerySingle enquery = EnquerySingle.fromJson(jsonEncode(res.data));
      return enquery;
    }
    return null;
  }

  Future<EnquerySingle?> addFollowup(
    int id,
    Lead lead,
    List<Map<String, dynamic>> followups,
  ) async {
    Map<String, dynamic> _data = {
      'data': {
        'purpose': lead.purpose!.toString(),
        'customer_name': lead.customer_name!.toString(),
        'customer_email': lead.customer_email!.toString(),
        'customer_mobile': lead.customer_mobile!.toString(),
        'source': lead.source!.toString(),
        'status': followups.last['status'],
        'followup': followups,
      }
    };
    Response res = await _http.put(
      '${ApiEndpoint.enquery}/$id',
      data: jsonEncode(_data),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      EnquerySingle enquery = EnquerySingle.fromJson(jsonEncode(res.data));
      return enquery;
    }
    return null;
  }

  Future<EnquerySingle?> delete(int id) async {
    Response res = await _http.delete(
      '${ApiEndpoint.enquery}/$id',
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      EnquerySingle enquery = EnquerySingle.fromJson(jsonEncode(res.data));
      return enquery;
    }
    return null;
  }
}
