import 'package:sqflite/sqflite.dart';

import 'database_service.dart';

class AuthService {
  Future<bool> login(String username, String password) async {
    Database database = await DatabaseService().database;
    List<Map<String, dynamic>> result = await database.query(
      'user',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
      limit: 1,
    );

    return result.isNotEmpty;
  }
}