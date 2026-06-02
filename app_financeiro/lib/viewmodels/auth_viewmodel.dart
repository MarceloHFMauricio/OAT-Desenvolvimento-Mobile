import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../services/database_service.dart';

class AuthViewModel extends ChangeNotifier {
  final FirestoreService _firestore = FirestoreService();
  final DatabaseService _local = DatabaseService();

  bool isLoginMode = true;
  bool isLoading = false;
  String? errorMessage;
  UserModel? currentUser;

  void toggleMode() {
    isLoginMode = !isLoginMode;
    errorMessage = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final data = await _firestore.loginUser(email.trim(), password);
      currentUser = UserModel(
        id: 1,
        firebaseUid: data['uid'],
        name: data['name'],
        email: data['email'],
      );
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      // Fallback local
      try {
        final localUser = await _local.getUserByEmail(email.trim());
        if (localUser != null && localUser.password == password) {
          currentUser = localUser;
          isLoading = false;
          notifyListeners();
          return true;
        }
      } catch (_) {}
      errorMessage = e.toString().replaceAll('Exception: ', '');
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
      final data = await _firestore.registerUser(name.trim(), email.trim(), password);
      currentUser = UserModel(
        id: 1,
        firebaseUid: data['uid'],
        name: data['name'],
        email: data['email'],
      );
      // Salva localmente como cache
      await _local.insertUser(UserModel(
        firebaseUid: data['uid'],
        name: data['name'],
        email: data['email'],
        password: password,
      ));
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      // Fallback local
      try {
        final exists = await _local.emailExists(email.trim());
        if (exists) {
          errorMessage = 'Este e-mail já está cadastrado.';
          isLoading = false;
          notifyListeners();
          return false;
        }
        final id = await _local.insertUser(UserModel(
          name: name.trim(),
          email: email.trim(),
          password: password,
        ));
        currentUser = UserModel(
          id: id,
          name: name.trim(),
          email: email.trim(),
          password: password,
        );
        isLoading = false;
        notifyListeners();
        return true;
      } catch (_) {
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isLoading = false;
        notifyListeners();
        return false;
      }
    }
  }

  void logout() {
    _firestore.logout();
    currentUser = null;
    isLoginMode = true;
    errorMessage = null;
    notifyListeners();
  }
}
