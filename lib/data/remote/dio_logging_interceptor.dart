// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ithelpdesk/core/config/flavor_config.dart';

class DioLoggingInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // if (options.baseUrl == baseUrlPoliceDomain) {
    //   final encryptionUtils = EncryptionUtils();
    //   String basicAuth =
    //       'Basic ${base64.encode(utf8.encode('${encryptionUtils.decryptAES(dotenv.env['policeBaseAuthUsername'] ?? '')}:${encryptionUtils.decryptAES(dotenv.env['policeBaseAuthUsername'] ?? '')}'))}';
    //   options.headers.addAll({
    //     HttpHeaders.authorizationHeader: basicAuth,
    //   });
    // } else if (userToken.isNotEmpty) {
    options.headers.addAll({
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: "*/*",
    });
    // }

    if (FlavorConfig.instance.flavor == Flavor.DEVELOPMENT) {
      print(
          "--> ${options.method.toUpperCase()} ${options.baseUrl}${options.path}");
      print('Headers:');
      options.headers.forEach((k, v) => print('$k: $v'));
      print('queryParameters:');
      options.queryParameters.forEach((k, v) => print('$k: $v'));
      if (options.data != null) {
        print('Body: ${options.data}');
      }
      print("--> END ${options.method.toUpperCase()}");
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (FlavorConfig.instance.flavor == Flavor.DEVELOPMENT) {
      print(
          "<-- ${response.statusCode} ${(response.requestOptions.baseUrl + response.requestOptions.path)}");
      print('Headers:');
      response.headers.forEach((k, v) => print('$k: $v'));
      print('Response: ${jsonEncode(response.data)}');
      //debugPrint('Response: ${jsonEncode(response.data)}', wrapWidth: 1024);
      print('<-- END HTTP');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (FlavorConfig.instance.flavor == Flavor.DEVELOPMENT) {
      print(
          "<-- ${err.message} ${err.response?.requestOptions.baseUrl}${err.response?.requestOptions.path}");
      print("${err.response?.data}");
      print('<-- End error');
    }
    if (err.response?.statusCode == 401) {}
    super.onError(err, handler);
  }
}
