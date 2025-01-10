import 'dart:convert';
import 'dart:io';

import 'package:apicallflutter/constants/app_urls.dart';
import 'package:apicallflutter/services/intercept.dart';
import 'package:apicallflutter/services/response.dart';
import 'package:apicallflutter/services/retry_policy.dart';
import 'package:http/http.dart' as https;
import 'package:http_interceptor/http/intercepted_client.dart';

class ApiHelper {
  ApiHelper._();

  static https.Client http() => InterceptedClient.build(
      interceptors: [MyInterceptor()], retryPolicy: ExpiredTokenRetryPolicy());

  static Future<dynamic> getCall(String endPoint,
      {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await http().get(Uri.parse(AppUrls.baseUrl + endPoint)
          .replace(queryParameters: queryParams));
      return ApiResponse.getResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> postCall(String endPoint,
      {Map<String, dynamic>? body}) async {
    try {
      final response =
          await http().post(Uri.parse(AppUrls.baseUrl + endPoint), body: body);
      return ApiResponse.getResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> putCall(String endPoint,
      {Map<String, dynamic>? body}) async {
    try {
      final response =
          await http().put(Uri.parse(AppUrls.baseUrl + endPoint), body: body);
      return ApiResponse.getResponse(response);
    } on SocketException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> deleteCall(String endPoint) async {
    try {
      final response =
          await http().delete(Uri.parse(AppUrls.baseUrl + endPoint));
      return ApiResponse.getResponse(response);
    } catch (e) {
      rethrow;
    }
  }
}
