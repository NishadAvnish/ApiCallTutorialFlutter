import 'dart:convert';

import 'package:apicallflutter/constants/app_urls.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  ApiHelper._();

  static Future<dynamic> getCall(String endPoint,
      {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await http.get(Uri.parse(AppUrls.baseUrl + endPoint)
          .replace(queryParameters: queryParams));
      final responseJson = json.decode(response.body);
      return responseJson["data"];
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> postCall(String endPoint,
      {Map<String, dynamic>? body}) async {
    try {
      final response =
          await http.post(Uri.parse(AppUrls.baseUrl + endPoint), body: body);
      final responseJson = json.decode(response.body);
      return responseJson["data"];
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> putCall(String endPoint,
      {Map<String, dynamic>? body}) async {
    try {
      final response =
          await http.put(Uri.parse(AppUrls.baseUrl + endPoint), body: body);
      final responseJson = json.decode(response.body);
      return responseJson["data"];
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> deleteCall(String endPoint) async {
    try {
      final response =
          await http.delete(Uri.parse(AppUrls.baseUrl + endPoint));
      final responseJson = json.decode(response.body);
      return responseJson["data"];
    } catch (e) {
      rethrow;
    }
  }
}
