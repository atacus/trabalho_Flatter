// lib/services/login_controller.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class LoginController {
  final ApiService api;

  LoginController(this.api);

  Future<bool> login(String username, String password) async {
    final ok = await api.login(username, password);
    if (ok) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('logged', true);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> isLogged() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('logged') ?? false;
  }
}

