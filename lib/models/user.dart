// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

class User {
  final int? user_id;
  final String username;
  final String name;
  final String password;
  final String phone;
  final String role;
  User({
    this.user_id,
    required this.username,
    required this.name,
    required this.password,
    required this.phone,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'username': username,
      'name': name,
      'password': password,
      'phone': phone,
      'role': role,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      user_id: map['user_id']?.toInt() ?? 0,
      username: map['username'] ?? '',
      name: map['name'] ?? '',
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
    return 'User(user_id: $user_id, username: $username, name: $name, password: $password, phone: $phone, role: $role)';
  }
}