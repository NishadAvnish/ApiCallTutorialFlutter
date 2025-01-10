import 'package:apicallflutter/constants/app_urls.dart';
import 'package:apicallflutter/services/api_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RefreshToken {
  Future<bool> getToken() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refreshToken');
      final email = prefs.getString('email');
      final response = await ApiHelper.postCall(AppUrls.refreshToken,
          body: {"email": email, "refreshToken": refreshToken});

      await prefs.setString('accessToken', response["accessToken"]);
      await prefs.setString('refreshToken', response["refreshToken"]);
      await prefs.setString('email', response["email"]);

      return true;
    } catch (e) {
      return false;
    }
  }
}
