import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/firestore_service.dart';
import '../services/database_service.dart';

class FinanceViewModel extends ChangeNotifier {
  final FirestoreService _firestore = FirestoreService();
  final DatabaseService _local = DatabaseService();

  List<TransactionModel> _transactions = [];
  bool isLoading = false;
  int _userId = 0;
  String _firebaseUid = '';

  List<TransactionModel> get transactions => _transactions;

  double get totalIncome =>
      _transactions.where((t) => t.isIncome).fold(0, (s, t) => s + t.amount);

  double get totalExpense =>
      _transactions.where((t) => !t.isIncome).fold(0, (s, t) => s + t.amount);

  double get balance => totalIncome - totalExpense;

  Future<void> loadTransactions(int userId, {String firebaseUid = ''}) async {
    _userId = userId;
    _firebaseUid = firebaseUid;
    isLoading = true;
    notifyListeners();

    try {
      if (_firebaseUid.isNotEmpty) {
        final docs = await _firestore.getTransactions(_firebaseUid);
        _transactions = docs.map((d) => TransactionModel(
          firestoreId: d['firestoreId'],
          userId: userId,
          firebaseUserId: _firebaseUid,
          title: d['title'],
          amount: d['amount'],
          isIncome: d['isIncome'],
          date: DateTime.parse(d['date']),
          category: d['category'],
        )).toList();
      } else {
        _transactions = await _local.getTransactionsByUser(userId);
      }
    } catch (e) {
      _transactions = await _local.getTransactionsByUser(userId);
    }

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
    String? firestoreId;

    try {
      if (_firebaseUid.isNotEmpty) {
        firestoreId = await _firestore.addTransaction(_firebaseUid, {
          'title': title,
          'amount': amount,
          'isIncome': isIncome,
          'date': date.toIso8601String(),
          'category': category,
        });
      }
    } catch (_) {}

    final localId = await _local.insertTransaction(TransactionModel(
      firestoreId: firestoreId,
      userId: _userId,
      firebaseUserId: _firebaseUid,
      title: title,
      amount: amount,
      isIncome: isIncome,
      date: date,
      category: category,
    ));

    _transactions.insert(0, TransactionModel(
      id: localId,
      firestoreId: firestoreId,
      userId: _userId,
      firebaseUserId: _firebaseUid,
      title: title,
      amount: amount,
      isIncome: isIncome,
      date: date,
      category: category,
    ));
    notifyListeners();
  }

  Future<void> deleteTransaction(int id) async {
    final t = _transactions.firstWhere((t) => t.id == id);
    try {
      if (_firebaseUid.isNotEmpty && t.firestoreId != null) {
        await _firestore.deleteTransaction(_firebaseUid, t.firestoreId!);
      }
    } catch (_) {}
    await _local.deleteTransaction(id);
    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  Future<void> updateTransaction(TransactionModel updated) async {
    try {
      if (_firebaseUid.isNotEmpty && updated.firestoreId != null) {
        await _firestore.updateTransaction(_firebaseUid, updated.firestoreId!, {
          'title': updated.title,
          'amount': updated.amount,
          'isIncome': updated.isIncome,
          'date': updated.date.toIso8601String(),
          'category': updated.category,
        });
      }
    } catch (_) {}
    await _local.updateTransaction(updated);
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
