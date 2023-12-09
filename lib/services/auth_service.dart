import 'package:klinik_alya_iman_mobile_app/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

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