import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/finance_viewmodel.dart';
import '../services/news_service.dart';

final authViewModelProvider = ChangeNotifierProvider<AuthViewModel>((ref) {
  return AuthViewModel();
});

final financeViewModelProvider = ChangeNotifierProvider<FinanceViewModel>((ref) {
  return FinanceViewModel();
});

final newsProvider = FutureProvider<List<NewsArticle>>((ref) async {
  return NewsService().fetchFinanceNews();
});
