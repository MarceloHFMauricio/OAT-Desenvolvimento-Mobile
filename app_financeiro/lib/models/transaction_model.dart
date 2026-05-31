class TransactionModel {
  final int? id;
  final int userId;
  final String title;
  final double amount;
  final bool isIncome;
  final DateTime date;
  final String category;

  TransactionModel({
    this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.date,
    this.category = 'Outros',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'title': title,
        'amount': amount,
        'is_income': isIncome ? 1 : 0,
        'date': date.toIso8601String(),
        'category': category,
      };

  factory TransactionModel.fromMap(Map<String, dynamic> map) => TransactionModel(
        id: map['id'],
        userId: map['user_id'],
        title: map['title'],
        amount: map['amount'],
        isIncome: map['is_income'] == 1,
        date: DateTime.parse(map['date']),
        category: map['category'] ?? 'Outros',
      );

  static const List<String> incomeCategories = [
    'Salário',
    'Freelance',
    'Investimento',
    'Presente',
    'Outros',
  ];

  static const List<String> expenseCategories = [
    'Alimentação',
    'Moradia',
    'Transporte',
    'Saúde',
    'Educação',
    'Lazer',
    'Vestuário',
    'Contas',
    'Outros',
  ];
}
