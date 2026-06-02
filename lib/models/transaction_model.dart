class TransactionModel {
  final int? id;
  final String? firestoreId;
  final int userId;
  final String firebaseUserId;
  final String title;
  final double amount;
  final bool isIncome;
  final DateTime date;
  final String category;

  TransactionModel({
    this.id,
    this.firestoreId,
    required this.userId,
    this.firebaseUserId = '',
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.date,
    this.category = 'Outros',
  });

  // SQLite / SharedPreferences
  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'firebase_user_id': firebaseUserId,
        'firestore_id': firestoreId,
        'title': title,
        'amount': amount,
        'is_income': isIncome ? 1 : 0,
        'date': date.toIso8601String(),
        'category': category,
      };

  factory TransactionModel.fromMap(Map<String, dynamic> map) => TransactionModel(
        id: map['id'],
        firestoreId: map['firestore_id'],
        userId: map['user_id'],
        firebaseUserId: map['firebase_user_id'] ?? '',
        title: map['title'],
        amount: map['amount'],
        isIncome: map['is_income'] == 1,
        date: DateTime.parse(map['date']),
        category: map['category'] ?? 'Outros',
      );

  // Firestore
  Map<String, dynamic> toFirestore() => {
        'title': title,
        'amount': amount,
        'isIncome': isIncome,
        'date': date.toIso8601String(),
        'category': category,
      };

  factory TransactionModel.fromFirestore(String docId, Map<String, dynamic> map) =>
      TransactionModel(
        firestoreId: docId,
        userId: 0,
        firebaseUserId: '',
        title: map['title'] ?? '',
        amount: (map['amount'] ?? 0).toDouble(),
        isIncome: map['isIncome'] ?? false,
        date: DateTime.parse(map['date']),
        category: map['category'] ?? 'Outros',
      );

  TransactionModel copyWith({String? firestoreId}) => TransactionModel(
        id: id,
        firestoreId: firestoreId ?? this.firestoreId,
        userId: userId,
        firebaseUserId: firebaseUserId,
        title: title,
        amount: amount,
        isIncome: isIncome,
        date: date,
        category: category,
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
