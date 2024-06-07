
import 'package:shared_preferences/shared_preferences.dart';

class StorageServices {
  static const _accessToken = "accessToken";

  static Future<void> setAccessToken({ required String accessToken}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessToken, accessToken);
  }

  static Future<String?> getAccessToken() async  {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString(_accessToken);
    return accessToken;
  }
}
