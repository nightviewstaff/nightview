import 'package:shared_preferences/shared_preferences.dart';

class ToggleService {
  static Future<Map<String, bool>> loadToggleStates() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getKeys().where((k) => k.startsWith('toggle_'))
        .fold<Map<String, bool>>({}, (map, key) => map..[key] = prefs.getBool(key) ?? false);
  }

  static Future<void> saveToggleState(String type, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('toggle_$type', value);
  }
}