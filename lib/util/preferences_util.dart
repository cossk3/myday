import 'package:myday/data/globals.dart';
import 'package:myday/model/day.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String pToken = 'token';

class Preferences {
  Preferences._privateConstructor();
  static final Preferences _instance = Preferences._privateConstructor();

  factory Preferences() {
    return _instance;
  }

  SharedPreferences? _prefs;

  Future<SharedPreferences> get prefs async {
    if (_prefs != null) return _prefs!;

    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  setToken() async {
    SharedPreferences prefs = await _instance.prefs;
    await prefs.setString(pToken, token);
  }

  getToken() async {
    SharedPreferences prefs = await _instance.prefs;
    return prefs.getString(pToken);
  }
}