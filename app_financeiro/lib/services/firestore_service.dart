import 'dart:convert';
import 'package:http/http.dart' as http;

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  static const _projectId = 'oat-2-desenvolvimento-mobile';
  static const _apiKey = 'AIzaSyCG7tNfBXHAHQV1vaBs72VupbH_PD2rRMs';
  static const _baseUrl = 'https://firestore.googleapis.com/v1/projects/$_projectId/databases/(default)/documents';
  static const _authUrl = 'https://identitytoolkit.googleapis.com/v1/accounts';

  String? _idToken;
  String? _firebaseUid;

  String? get currentUid => _firebaseUid;

  // --- Auth ---

  Future<Map<String, dynamic>> registerUser(String name, String email, String password) async {
    final res = await http.post(
      Uri.parse('$_authUrl:signUp?key=$_apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password, 'returnSecureToken': true}),
    );
    final data = jsonDecode(res.body);
    if (data['error'] != null) {
      final msg = data['error']['message'];
      if (msg == 'EMAIL_EXISTS') throw Exception('Este e-mail já está cadastrado.');
      throw Exception('Erro ao cadastrar.');
    }
    _idToken = data['idToken'];
    _firebaseUid = data['localId'];

    // Salva nome no Firestore
    await _setDocument('users/${_firebaseUid}', {'name': name, 'email': email});

    return {'uid': _firebaseUid, 'name': name, 'email': email};
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final res = await http.post(
      Uri.parse('$_authUrl:signInWithPassword?key=$_apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password, 'returnSecureToken': true}),
    );
    final data = jsonDecode(res.body);
    if (data['error'] != null) {
      throw Exception('E-mail ou senha inválidos.');
    }
    _idToken = data['idToken'];
    _firebaseUid = data['localId'];

    // Busca nome
    String name = 'Usuário';
    try {
      final doc = await _getDocument('users/$_firebaseUid');
      name = doc['fields']?['name']?['stringValue'] ?? 'Usuário';
    } catch (_) {}

    return {'uid': _firebaseUid, 'name': name, 'email': email};
  }

  void logout() {
    _idToken = null;
    _firebaseUid = null;
  }

  // --- Transactions ---

  Future<String> addTransaction(String userId, Map<String, dynamic> data) async {
    final fields = _toFirestoreFields(data);
    final res = await http.post(
      Uri.parse('$_baseUrl/users/$userId/transactions?key=$_apiKey'),
      headers: {
        'Content-Type': 'application/json',
        if (_idToken != null) 'Authorization': 'Bearer $_idToken',
      },
      body: jsonEncode({'fields': fields}),
    );
    final body = jsonDecode(res.body);
    final name = body['name'] as String;
    return name.split('/').last;
  }

  Future<List<Map<String, dynamic>>> getTransactions(String userId) async {
    final res = await http.get(
      Uri.parse('$_baseUrl/users/$userId/transactions?key=$_apiKey'),
      headers: {
        if (_idToken != null) 'Authorization': 'Bearer $_idToken',
      },
    );
    final body = jsonDecode(res.body);
    final docs = body['documents'] as List? ?? [];
    return docs.map((d) {
      final fields = d['fields'] as Map<String, dynamic>;
      final id = (d['name'] as String).split('/').last;
      return {
        'firestoreId': id,
        'title': fields['title']?['stringValue'] ?? '',
        'amount': double.tryParse(fields['amount']?['doubleValue']?.toString() ?? fields['amount']?['integerValue']?.toString() ?? '0') ?? 0.0,
        'isIncome': fields['isIncome']?['booleanValue'] ?? false,
        'date': fields['date']?['stringValue'] ?? DateTime.now().toIso8601String(),
        'category': fields['category']?['stringValue'] ?? 'Outros',
      };
    }).toList();
  }

  Future<void> deleteTransaction(String userId, String docId) async {
    await http.delete(
      Uri.parse('$_baseUrl/users/$userId/transactions/$docId?key=$_apiKey'),
      headers: {
        if (_idToken != null) 'Authorization': 'Bearer $_idToken',
      },
    );
  }

  Future<void> updateTransaction(String userId, String docId, Map<String, dynamic> data) async {
    final fields = _toFirestoreFields(data);
    await http.patch(
      Uri.parse('$_baseUrl/users/$userId/transactions/$docId?key=$_apiKey'),
      headers: {
        'Content-Type': 'application/json',
        if (_idToken != null) 'Authorization': 'Bearer $_idToken',
      },
      body: jsonEncode({'fields': fields}),
    );
  }

  // --- Helpers ---

  Future<void> _setDocument(String path, Map<String, dynamic> data) async {
    final fields = _toFirestoreFields(data);
    await http.patch(
      Uri.parse('$_baseUrl/$path?key=$_apiKey'),
      headers: {
        'Content-Type': 'application/json',
        if (_idToken != null) 'Authorization': 'Bearer $_idToken',
      },
      body: jsonEncode({'fields': fields}),
    );
  }

  Future<Map<String, dynamic>> _getDocument(String path) async {
    final res = await http.get(
      Uri.parse('$_baseUrl/$path?key=$_apiKey'),
      headers: {
        if (_idToken != null) 'Authorization': 'Bearer $_idToken',
      },
    );
    return jsonDecode(res.body);
  }

  Map<String, dynamic> _toFirestoreFields(Map<String, dynamic> data) {
    return data.map((key, value) {
      if (value is String) return MapEntry(key, {'stringValue': value});
      if (value is bool) return MapEntry(key, {'booleanValue': value});
      if (value is int) return MapEntry(key, {'integerValue': value.toString()});
      if (value is double) return MapEntry(key, {'doubleValue': value});
      return MapEntry(key, {'stringValue': value.toString()});
    });
  }
}
