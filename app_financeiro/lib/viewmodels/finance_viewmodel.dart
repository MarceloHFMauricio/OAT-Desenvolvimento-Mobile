import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/database_service.dart';

class FinanceViewModel extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  List<TransactionModel> _transactions = [];
  bool isLoading = false;
  int _userId = 0;

  List<TransactionModel> get transactions => _transactions;

  double get totalIncome =>
      _transactions.where((t) => t.isIncome).fold(0, (s, t) => s + t.amount);

  double get totalExpense =>
      _transactions.where((t) => !t.isIncome).fold(0, (s, t) => s + t.amount);

  double get balance => totalIncome - totalExpense;

  Future<void> loadTransactions(int userId) async {
    _userId = userId;
    isLoading = true;
    notifyListeners();
    _transactions = await _db.getTransactionsByUser(userId);
    isLoading = false;
    notifyListeners();
  }

  Future<void> addTransaction({
    required String title,
    required double amount,
    required bool isIncome,
    required DateTime date,
    required String category,
  }) async {
    final t = TransactionModel(
      userId: _userId,
      title: title,
      amount: amount,
      isIncome: isIncome,
      date: date,
      category: category,
    );
    final id = await _db.insertTransaction(t);
    final saved = TransactionModel(
      id: id,
      userId: _userId,
      title: title,
      amount: amount,
      isIncome: isIncome,
      date: date,
      category: category,
    );
    _transactions.insert(0, saved);
    notifyListeners();
  }

  Future<void> deleteTransaction(int id) async {
    await _db.deleteTransaction(id);
    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  Future<void> updateTransaction(TransactionModel updated) async {
    await _db.updateTransaction(updated);
    final idx = _transactions.indexWhere((t) => t.id == updated.id);
    if (idx != -1) {
      _transactions[idx] = updated;
      notifyListeners();
    }
  }

  Map<String, double> get expenseByCategory {
    final Map<String, double> result = {};
    for (final t in _transactions.where((t) => !t.isIncome)) {
      result[t.category] = (result[t.category] ?? 0) + t.amount;
    }
    return result;
  }
}
