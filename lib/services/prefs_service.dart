import 'package:shared_preferences/shared_preferences.dart';

class CommsSharedPreferenceService {
  static Future<bool> setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> clear(String? key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (key != null) {
      prefs.remove(key);
    } else {
      prefs.clear();
    }
  }
}
