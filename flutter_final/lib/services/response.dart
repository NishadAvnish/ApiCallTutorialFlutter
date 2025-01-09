import 'dart:convert';
import 'package:apicallflutter/services/app_exception.dart';
import 'package:http/http.dart';

class ApiResponse {
  static void getResponse(Response response) {
    final responseJson = json.decode(response.body);

    switch (response.statusCode) {
      case 200:
      case 201:
        return responseJson["data"];

      case 404:
        throw NotFoundException(
            message: responseJson["message"],
            responseData: responseJson["data"]);

      default:
    }
  }
}
