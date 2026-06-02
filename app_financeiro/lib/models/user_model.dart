class UserModel {
  final int? id;
  final String? firebaseUid;
  final String name;
  final String email;
  final String password;

  UserModel({
    this.id,
    this.firebaseUid,
    required this.name,
    required this.email,
    this.password = '',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'firebase_uid': firebaseUid,
        'name': name,
        'email': email,
        'password': password,
      };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        id: map['id'],
        firebaseUid: map['firebase_uid'],
        name: map['name'],
        email: map['email'],
        password: map['password'] ?? '',
      );
}
