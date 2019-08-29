import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs{
  static SharedPreferences _prefs;

  static loadPrefs() async{
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences getPrefs() {
    return _prefs;
  }
}