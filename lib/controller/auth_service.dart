import 'dart:convert';
import 'package:bloom/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  Future<bool> login(String username, String password) async {
    try {
      var url = Uri.parse("http://$API_IP_ADDRESS/api_bloom/login.php");
      var response = await http.post(url, body: {
        "username": username,
        "password": password,
      });

      var data = json.decode(response.body);
      if (data != null && data['status'] == "success") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        dynamic userIdString = data['user']['user_id'];
        int userId = userIdString != null ? int.tryParse(userIdString) ?? 0 : 0;
        await prefs.setInt('user_id', userId);
        await prefs.setString('username', data['user']['username']);
        await prefs.setString('email', data['user']['email']);
        await prefs.setString('phone', data['user']['phone']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future<void> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      await prefs.remove('user_id');
      await prefs.remove('username');
      await prefs.remove('email');
      await prefs.remove('phone');
    } catch (e) {
      print("Error occurred during logout: $e");
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool('isLoggedIn') ?? false;
    } catch (e) {
      print("Error occurred while checking login status: $e");
      return false;
    }
  }

  Future<int?> getUserId() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getInt('user_id');
    } catch (e) {
      print("Error occurred while getting user ID: $e");
      return null;
    }
  }

  Future<String?> getUsername() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('username');
    } catch (e) {
      print("Error occurred while getting username: $e");
      return null;
    }
  }

  Future<String?> getEmail() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('email');
    } catch (e) {
      print("Error occurred while getting email: $e");
      return null;
    }
  }

  Future<String?> getPhone() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('phone');
    } catch (e) {
      print("Error occurred while getting phone: $e");
      return null;
    }
  }
}
