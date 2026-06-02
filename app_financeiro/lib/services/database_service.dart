import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/transaction_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  // Memória para sessão atual
  final List<UserModel> _users = [];
  final List<TransactionModel> _transactions = [];
  int _userIdCounter = 1;
  int _transactionIdCounter = 1;
  bool _loaded = false;

  Future<void> _ensureLoaded() async {
    if (_loaded) return;
    _loaded = true;
    if (!kIsWeb) return;
    try {
      final prefs = await SharedPreferences.getInstance();

      // Carregar usuários
      final usersJson = prefs.getString('users');
      if (usersJson != null) {
        final list = jsonDecode(usersJson) as List;
        _users.addAll(list.map((e) => UserModel.fromMap(e)));
        if (_users.isNotEmpty) {
          _userIdCounter =
              _users.map((u) => u.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
        }
      }

      // Carregar transações
      final txJson = prefs.getString('transactions');
      if (txJson != null) {
        final list = jsonDecode(txJson) as List;
        _transactions.addAll(list.map((e) => TransactionModel.fromMap(e)));
        if (_transactions.isNotEmpty) {
          _transactionIdCounter =
              _transactions.map((t) => t.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
        }
      }
    } catch (_) {}
  }

  Future<void> _saveUsers() async {
    if (!kIsWeb) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('users', jsonEncode(_users.map((u) => u.toMap()).toList()));
  }

  Future<void> _saveTransactions() async {
    if (!kIsWeb) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('transactions', jsonEncode(_transactions.map((t) => t.toMap()).toList()));
  }

  Future<int> insertUser(UserModel user) async {
    await _ensureLoaded();
    final id = _userIdCounter++;
    _users.add(UserModel(id: id, name: user.name, email: user.email, password: user.password));
    await _saveUsers();
    return id;
  }

  Future<UserModel?> getUserByEmail(String email) async {
    await _ensureLoaded();
    try {
      return _users.firstWhere((u) => u.email == email);
    } catch (_) {
      return null;
    }
  }

  Future<bool> emailExists(String email) async {
    await _ensureLoaded();
    return _users.any((u) => u.email == email);
  }

  Future<int> insertTransaction(TransactionModel t) async {
    await _ensureLoaded();
    final id = _transactionIdCounter++;
    _transactions.add(TransactionModel(
      id: id,
      userId: t.userId,
      title: t.title,
      amount: t.amount,
      isIncome: t.isIncome,
      date: t.date,
      category: t.category,
    ));
    await _saveTransactions();
    return id;
  }

  Future<List<TransactionModel>> getTransactionsByUser(int userId) async {
    await _ensureLoaded();
    return _transactions
        .where((t) => t.userId == userId)
        .toList()
        .reversed
        .toList();
  }

  Future<int> deleteTransaction(int id) async {
    await _ensureLoaded();
    _transactions.removeWhere((t) => t.id == id);
    await _saveTransactions();
    return 1;
  }

  Future<int> updateTransaction(TransactionModel t) async {
    await _ensureLoaded();
    final idx = _transactions.indexWhere((tr) => tr.id == t.id);
    if (idx != -1) {
      _transactions[idx] = t;
      await _saveTransactions();
      return 1;
    }
    return 0;
  }
}
