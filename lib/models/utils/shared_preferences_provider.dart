import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider with ChangeNotifier {
  SharedPreferences? _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    notifyListeners();
  }

  String get username => _prefs?.getString('username') ?? '';
  set username(String value) {
    _prefs?.setString('username', value);
    notifyListeners();
  }

  String get email => _prefs?.getString('email') ?? '';
  set email(String value) {
    _prefs?.setString('email', value);
    notifyListeners();
  }

  String get phone => _prefs?.getString('phone') ?? '';
  set phone(String value) {
    _prefs?.setString('phone', value);
    notifyListeners();
  }

  Future<void> clearPreferences() async {
    await _prefs?.clear();
    notifyListeners();
  }
}
