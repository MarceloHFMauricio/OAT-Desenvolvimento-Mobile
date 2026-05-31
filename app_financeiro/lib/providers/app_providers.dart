import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/finance_viewmodel.dart';

final authViewModelProvider = ChangeNotifierProvider<AuthViewModel>((ref) {
  return AuthViewModel();
});

final financeViewModelProvider = ChangeNotifierProvider<FinanceViewModel>((ref) {
  return FinanceViewModel();
});
