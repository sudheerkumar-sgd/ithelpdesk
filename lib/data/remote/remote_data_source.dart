import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ithelpdesk/core/common/log.dart';
import 'package:ithelpdesk/core/error/exceptions.dart';
import 'package:ithelpdesk/data/remote/dio_logging_interceptor.dart';

abstract class RemoteDataSource {
  Future<dynamic> get(
      {required String apiUrl, required Map<String, dynamic> requestParams});
  Future<dynamic> post(
      {required String apiUrl, required Map<String, dynamic> requestParams});
  Future<dynamic> getWithCustomBaseUrl(
      {required String baseUrl,
      required String apiUrl,
      required Map<String, dynamic> requestParams});
  Future<dynamic> postWithCustomBaseUrl({
    required String baseUrl,
    required String apiUrl,
    required Map<String, dynamic> requestParams,
    bool postAsArray = false,
  });
  Future<dynamic> postWithMultipartData({
    required String? baseUrl,
    required String apiUrl,
    required Map<String, dynamic> requestParams,
    bool postAsArray = false,
  });
  Future<dynamic> postWithStringContent(
      {required String baseUrl,
      required String apiUrl,
      required String content,
      String? contentTypeHeader});
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio dio;

  RemoteDataSourceImpl({required this.dio});

  ServerException _getExceptionType(Response<dynamic> response) {
    switch (response.statusCode) {
      case 400:
        return throw ServerException(message: response.data);
      case 401:
        return throw const ServerException(message: 'Unauthorized');
      case 500:
        return throw const ServerException(message: 'Internal Server Error');
      default:
        throw ServerException(
            message: response.data.isNull ? 'Unknown Error' : response.data);
    }
  }

  @override
  Future get(
      {required String apiUrl,
      required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.get(
        apiUrl,
        queryParameters: requestParams,
      );
      return response.data;
    } on DioException catch (e) {
      printLog(e.toString());
      rethrow;
    }
  }

  @override
  Future post(
      {required String apiUrl,
      required Map<String, dynamic> requestParams}) async {
    try {
      var response = await dio.post(apiUrl, data: jsonEncode(requestParams));
      return response.data;
    } on DioException catch (e) {
      printLog(e.toString());
      rethrow;
    }
  }

  @override
  Future getWithCustomBaseUrl(
      {required String baseUrl,
      required String apiUrl,
      required Map<String, dynamic> requestParams}) async {
    final dio2 = dio;
    dio2.options.baseUrl = baseUrl;
    dio2.interceptors.add(DioLoggingInterceptor());
    try {
      var response = await dio2.get(
        apiUrl,
        queryParameters: requestParams,
      );
      return response.data;
    } on DioException catch (e) {
      printLog(e.toString());
      rethrow;
    }
  }

  @override
  Future postWithCustomBaseUrl({
    required String baseUrl,
    required String apiUrl,
    required Map<String, dynamic> requestParams,
    bool postAsArray = false,
  }) async {
    final dio2 = dio;
    dio2.options.baseUrl = baseUrl;
    dio2.interceptors.add(DioLoggingInterceptor());
    try {
      var response = await dio2.post(apiUrl,
          data: postAsArray
              ? jsonEncode(<Map<String, dynamic>>[requestParams])
              : jsonEncode(requestParams));
      return response.data;
    } on DioException catch (e) {
      printLog(e.toString());
      rethrow;
    }
  }

  @override
  Future postWithMultipartData({
    required String? baseUrl,
    required String apiUrl,
    required Map<String, dynamic> requestParams,
    bool postAsArray = false,
  }) async {
    final dio2 = dio;
    if (baseUrl?.isNotEmpty == true) {
      dio2.options.baseUrl = baseUrl ?? '';
      dio2.interceptors.add(DioLoggingInterceptor());
    }
    try {
      FormData formData = FormData.fromMap(requestParams);
      var response = await dio2.post(apiUrl, data: formData);
      return response.data;
    } on DioException catch (e) {
      printLog(e.toString());
      rethrow;
    }
  }

  @override
  Future postWithStringContent(
      {required String baseUrl,
      required String apiUrl,
      required String content,
      String? contentTypeHeader}) async {
    final dio2 = Dio();
    dio2.options.baseUrl = baseUrl;
    dio2.interceptors.add(DioLoggingInterceptor());
    try {
      var response = await dio2.post(
        apiUrl,
        data: content,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader:
              contentTypeHeader ?? 'application/json',
        }),
      );
      return response.data;
    } on DioException catch (e) {
      printLog(e.toString());
      rethrow;
    }
  }
}
