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
}
