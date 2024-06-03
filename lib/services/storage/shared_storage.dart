
import 'package:shared_preferences/shared_preferences.dart';

class SharedStorageService {
  static Future<void> setAccessToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("accessToken", accessToken);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString("accessToken");
    return accessToken;
  }

  static Future<void> delAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("accessToken");
  }
}