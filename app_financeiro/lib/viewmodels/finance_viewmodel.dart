import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class FinanceViewModel extends ChangeNotifier {
  final List<TransactionModel> _transactions = [
    TransactionModel(title: "Salário", amount: 4500.0, isIncome: true, date: DateTime.now()),
    TransactionModel(title: "Supermercado", amount: 650.0, isIncome: false, date: DateTime.now()),
    TransactionModel(title: "Conta de Luz", amount: 120.0, isIncome: false, date: DateTime.now()),
  ];

  List<TransactionModel> get transactions => _transactions;

  double get totalIncome => _transactions.where((t) => t.isIncome).fold(0, (sum, item) => sum + item.amount);
  double get totalExpense => _transactions.where((t) => !t.isIncome).fold(0, (sum, item) => sum + item.amount);
  double get balance => totalIncome - totalExpense;

  void addTransaction(String title, double amount, bool isIncome) {
    _transactions.insert(0, TransactionModel(
      title: title, 
      amount: amount, 
      isIncome: isIncome, 
      date: DateTime.now()
    ));
    notifyListeners();
  }
}