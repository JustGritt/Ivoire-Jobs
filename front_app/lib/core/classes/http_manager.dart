import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/config/api_endpoints.dart';
import 'package:barassage_app/config/app_cache.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'dart:developer';
import 'dart:io';

// import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class Http extends HttpManager {
  Http({String? baseUrl, Map<String, dynamic>? headers})
      : super(baseUrl!, headers!);
}

class HttpManager {
  final Dio _dio = Dio();

  HttpManager(
      [String? baseUrl = ApiEndpoint.api, Map<String, dynamic>? headers]) {
    _dio.options.baseUrl = baseUrl ?? ApiEndpoint.api;
    _dio.options.headers = headers;

    // _dio.interceptors.add(PrettyDioLogger(
    //   requestHeader: true,
    //   requestBody: true,
    //   responseBody: true,
    //   responseHeader: false,
    //   compact: false,
    // ));

    // how to solve flutter CERTIFICATE_VERIFY_FAILED error
    // while performing a POST request?
    if (kIsWeb) {
      _dio.options.headers['content-Type'] = 'application/json';
      _dio.options.headers['Access-Control-Allow-Origin'] = '*';
      _dio.options.headers['Access-Control-Allow-Methods'] = '*';
    }

    if (!kIsWeb) {
      // ignore: deprecated_member_use
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }
  }

  Future<void> setToken() async {
    String? userToken = await serviceLocator<AppCache>().getToken();
    if (userToken != null) {
      _dio.options.headers['Authorization'] = 'Bearer $userToken';
    }
  }

  Future<Response> get(
    String url, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? token,
    Function(int progress, int total)? progress,
  }) async {
    await setToken();
    Response? response;
    try {
      response = await _dio.get(
        url,
        queryParameters: params,
        options: options,
        cancelToken: token,
        onReceiveProgress: progress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? token,
    Function(int progress, int total)? sendProgress,
    Function(int progress, int total)? receiveProgress,
  }) async {
    await setToken();
    Response? response;
    try {
      response = await _dio.post(
        url,
        data: data,
        queryParameters: params,
        options: options,
        cancelToken: token,
        onReceiveProgress: receiveProgress,
        onSendProgress: sendProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? token,
    Function(int progress, int total)? sendProgress,
    Function(int progress, int total)? receiveProgress,
  }) async {
    await setToken();
    Response? response;
    response = await _dio.put(
      url,
      data: data,
      queryParameters: params,
      options: options,
      cancelToken: token,
      onReceiveProgress: receiveProgress,
      onSendProgress: sendProgress,
    );
    return response;
  }

  Future<Response> patch(
    String url, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? token,
    Function(int progress, int total)? sendProgress,
    Function(int progress, int total)? receiveProgress,
  }) async {
    await setToken();
    Response? response;
    try {
      response = await _dio.patch(
        url,
        data: data,
        queryParameters: params,
        options: options,
        cancelToken: token,
        onReceiveProgress: receiveProgress,
        onSendProgress: sendProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? token,
  }) async {
    await setToken();
    Response? response;
    try {
      await setToken();
      response = await _dio.delete(
        url,
        data: data,
        queryParameters: params,
        options: options,
        cancelToken: token,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> download(
    String url,
    dynamic savePath, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? token,
    Function(int progress, int total)? receiveProgress,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
  }) async {
    await setToken();
    Response? response;
    try {
      response = await _dio.download(
        url,
        savePath,
        data: data,
        queryParameters: params,
        options: options,
        cancelToken: token,
        onReceiveProgress: receiveProgress,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> head(
    String url, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? token,
  }) async {
    await setToken();
    Response? response;
    try {
      response = await _dio.head(
        url,
        data: data,
        queryParameters: params,
        options: options,
        cancelToken: token,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> fetch(RequestOptions requestOptions) async {
    Response? response;
    try {
      response = await _dio.fetch(requestOptions);
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> getUri(
    Uri uri, {
    Options? options,
    CancelToken? cancelToken,
    Function(int progress, int total)? receiveProgress,
  }) async {
    Response? response;
    try {
      response = await _dio.getUri(
        uri,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: receiveProgress,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> headUri(
    Uri uri, {
    Options? options,
    CancelToken? cancelToken,
    void Function(int progress, int total)? receiveProgress,
  }) async {
    Response? response;
    try {
      response = await _dio.headUri(
        uri,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> postUri(
    Uri uri, {
    Options? options,
    CancelToken? cancelToken,
    void Function(int progress, int total)? sendProgress,
    void Function(int progress, int total)? receiveProgress,
  }) async {
    Response? response;
    try {
      response = await _dio.postUri(
        uri,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: sendProgress,
        onReceiveProgress: receiveProgress,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> putUri(
    Uri uri, {
    Options? options,
    CancelToken? cancelToken,
    void Function(int progress, int total)? sendProgress,
    void Function(int progress, int total)? receiveProgress,
  }) async {
    Response? response;
    try {
      response = await _dio.putUri(
        uri,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: sendProgress,
        onReceiveProgress: receiveProgress,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> patchUri(
    Uri uri, {
    Options? options,
    CancelToken? cancelToken,
    void Function(int progress, int total)? sendProgress,
    void Function(int progress, int total)? receiveProgress,
  }) async {
    Response? response;
    try {
      response = await _dio.patchUri(
        uri,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: sendProgress,
        onReceiveProgress: receiveProgress,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> deleteUri(
    Uri uri, {
    Options? options,
    CancelToken? cancelToken,
    void Function(int progress, int total)? sendProgress,
    void Function(int progress, int total)? receiveProgress,
  }) async {
    Response? response;
    try {
      response = await _dio.deleteUri(
        uri,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> downloadUri(Uri uri, dynamic savePath,
      {dynamic data,
      Options? options,
      CancelToken? cancelToken,
      void Function(int progress, int total)? receiveProgress,
      bool deleteOnError = true,
      String lengthHeader = Headers.contentLengthHeader}) async {
    Response? response;
    try {
      response = await _dio.downloadUri(
        uri,
        savePath,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: receiveProgress,
        data: data,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> request(
    String path, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    void Function(int progress, int total)? receiveProgress,
    void Function(int progress, int total)? sendProgress,
  }) async {
    Response? response;
    try {
      response = await _dio.request(
        path,
        data: data,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: receiveProgress,
        onSendProgress: sendProgress,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }

  Future<Response> requestUri(
    Uri uri, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    void Function(int progress, int total)? receiveProgress,
    void Function(int progress, int total)? sendProgress,
  }) async {
    Response? response;
    try {
      response = await _dio.requestUri(
        uri,
        data: data,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: receiveProgress,
        onSendProgress: sendProgress,
      );
      return response;
    } catch (e) {
      log(e.toString());
    }
    return response!;
  }
}
