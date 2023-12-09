// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

class User {
  final int? user_id;
  final String f_name;
  final String l_name;
  final String username;
  final String password;
  final String email;
  final String role;
  User({
    this.user_id,
    required this.f_name,
    required this.l_name,
    required this.username,
    required this.password,
    required this.email,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'f_name': f_name,
      'l_name': l_name,
      'username': username,
      'password': password,
      'email': email,
      'role': role,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      user_id: map['user_id']?.toInt() ?? 0,
      f_name: map['f_name'] ?? '',
      l_name: map['l_name'] ?? '',
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
    );
  }
  
  String toJson() => json.encode(toMap());
  factory User.fromJson(String source) => User.fromMap(json.decode(source));
  // Implement toString to make it easier to see information about each User when using the print statement.
  @override
  String toString() {
    return 'User(user_id: $user_id, f_name: $f_name, l_name: $l_name, username: $username, password: $password, email: $email, role: $role)';
  }
}