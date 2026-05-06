import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  bool isLoginMode = true;

  void toggleMode() {
    isLoginMode = !isLoginMode;
    notifyListeners();
  }

  bool authenticate(String email, String password) {
    return email.trim().isNotEmpty && password.trim().isNotEmpty;
  }
}