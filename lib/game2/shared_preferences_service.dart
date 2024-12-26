import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const _keyTimeElapsed = 'timeElapsed';

  Future<void> saveTimeElapsed(int time) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_keyTimeElapsed, time);
  }

  Future<int> getTimeElapsed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyTimeElapsed) ?? 0;
  }

  Future<void> resetTimeElapsed() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_keyTimeElapsed);
  }
}
