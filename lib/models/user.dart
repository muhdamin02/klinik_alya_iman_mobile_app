// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

class User {
  final int? user_id;
  final String name;
  final String identification;
  final String password;
  final String phone;
  final String role;
  User({
    this.user_id,
    required this.name,
    required this.identification,
    required this.password,
    required this.phone,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'name': name,
      'identification': identification,
      'password': password,
      'email': phone,
      'role': role,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      user_id: map['user_id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      identification: map['identification'] ?? '',
      password: map['password'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? '',
    );
  }
  
  String toJson() => json.encode(toMap());
  factory User.fromJson(String source) => User.fromMap(json.decode(source));
  // Implement toString to make it easier to see information about each User when using the print statement.
  @override
  String toString() {
    return 'User(user_id: $user_id, name: $name, identification: $identification, password: $password, phone: $phone, role: $role)';
  }
}