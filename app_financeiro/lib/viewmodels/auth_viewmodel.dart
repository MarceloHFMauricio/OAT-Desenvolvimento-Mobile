import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';

class AuthViewModel extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  bool isLoginMode = true;
  bool isLoading = false;
  String? errorMessage;
  UserModel? currentUser;

  void toggleMode() {
    isLoginMode = !isLoginMode;
    errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = await _db.getUserByEmail(email.trim());
      if (user == null || user.password != password) {
        errorMessage = 'E-mail ou senha inválidos.';
        isLoading = false;
        notifyListeners();
        return false;
      }
      currentUser = user;
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = 'Erro ao fazer login.';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final exists = await _db.emailExists(email.trim());
      if (exists) {
        errorMessage = 'Este e-mail já está cadastrado.';
        isLoading = false;
        notifyListeners();
        return false;
      }
      final newUser = UserModel(
        name: name.trim(),
        email: email.trim(),
        password: password,
      );
      final id = await _db.insertUser(newUser);
      currentUser = UserModel(
        id: id,
        name: newUser.name,
        email: newUser.email,
        password: newUser.password,
      );
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = 'Erro ao cadastrar. Tente novamente.';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    currentUser = null;
    isLoginMode = true;
    errorMessage = null;
    notifyListeners();
  }
}
