import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/transaction_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  // Armazenamento em memória para web
  final List<UserModel> _users = [];
  final List<TransactionModel> _transactions = [];
  int _userIdCounter = 1;
  int _transactionIdCounter = 1;

  Future<int> insertUser(UserModel user) async {
    if (kIsWeb) {
      final id = _userIdCounter++;
      _users.add(UserModel(
        id: id,
        name: user.name,
        email: user.email,
        password: user.password,
      ));
      return id;
    }
    return 0;
  }

  Future<UserModel?> getUserByEmail(String email) async {
    if (kIsWeb) {
      try {
        return _users.firstWhere((u) => u.email == email);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Future<bool> emailExists(String email) async {
    if (kIsWeb) {
      return _users.any((u) => u.email == email);
    }
    return false;
  }

  Future<int> insertTransaction(TransactionModel t) async {
    if (kIsWeb) {
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
      return id;
    }
    return 0;
  }

  Future<List<TransactionModel>> getTransactionsByUser(int userId) async {
    if (kIsWeb) {
      return _transactions
          .where((t) => t.userId == userId)
          .toList()
          .reversed
          .toList();
    }
    return [];
  }

  Future<int> deleteTransaction(int id) async {
    if (kIsWeb) {
      _transactions.removeWhere((t) => t.id == id);
      return 1;
    }
    return 0;
  }

  Future<int> updateTransaction(TransactionModel t) async {
    if (kIsWeb) {
      final idx = _transactions.indexWhere((tr) => tr.id == t.id);
      if (idx != -1) {
        _transactions[idx] = t;
        return 1;
      }
    }
    return 0;
  }
}
