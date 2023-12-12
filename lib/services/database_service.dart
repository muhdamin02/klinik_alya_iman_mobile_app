import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/appointment.dart';
import '../models/profile.dart';
import '../models/user.dart';

class DatabaseService {
  Future<void> initialize() async {
    _database = await _initDatabase();
  }

  // Singleton pattern
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    final path = join(databasePath, 'klinikalyaiman.db');
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  // When the database is first created, create a table to store user
  // and a table to store appointment.
  Future<void> _onCreate(Database db, int version) async {
    // user table
    await db.execute(
      'CREATE TABLE user(user_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, f_name TEXT NOT NULL, l_name TEXT NOT NULL, username TEXT NOT NULL, password TEXT NOT NULL, email TEXT NOT NULL, role TEXT NOT NULL)',
    );

    // profile table
    await db.execute(
      'CREATE TABLE profile(profile_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, f_name TEXT NOT NULL, l_name TEXT NOT NULL, dob TEXT NOT NULL, gender TEXT NOT NULL, user_id INTEGER, FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE SET NULL)',
    );

    // appointment table
    await db.execute('''
  CREATE TABLE appointment (
    appointment_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    appointment_date TEXT NOT NULL,
    user_id INTEGER NOT NULL,
    profile_id INTEGER NOT NULL,
    status TEXT NOT NULL,
    system_remarks TEXT NOT NULL,
    patient_remarks TEXT DEFAULT 'No remarks by patient.',
    practitioner_remarks TEXT DEFAULT 'No remarks by practitioner.',
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE SET NULL,
    FOREIGN KEY (profile_id) REFERENCES profile(profile_id) ON DELETE SET NULL
  );
''');

    await db.execute(
      'INSERT INTO user (f_name, l_name, username, password, email, role) VALUES (?, ?, ?, ?, ?, ?)',
      [
        'Muhammad Shahid',
        'Shamsul Anuar',
        'abualyain',
        'abualyain',
        'abualyain@example.com',
        'practitioner'
      ],
    );
  }

//////////////////////////////////////////////////////////////////////////
//// ---------------------------------------------------------------- ////
//// USER DATABASE ///////////////////////////////////////////////////////
//// ---------------------------------------------------------------- ////
//////////////////////////////////////////////////////////////////////////

  // Insert
  Future<void> insertUser(User user) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    await db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // check if username exists
  Future<bool> checkUsernameExists(String username) async {
    final db = await _databaseService.database;
    final count = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM user WHERE username = ?',
      [username],
    ));
    return count != null && count > 0;
  }

  // Check if email exists
  Future<bool> checkEmailExists(String email) async {
    final db = await _databaseService.database;
    final count = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM user WHERE email = ?',
      [email],
    ));
    return count != null && count > 0;
  }

//////////////////////////////////////////////////////////////////////////
//// ---------------------------------------------------------------- ////
//// PROFILE DATABASE ////////////////////////////////////////////////////
//// ---------------------------------------------------------------- ////
//////////////////////////////////////////////////////////////////////////

  // Insert
  Future<void> insertProfile(Profile profile) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    await db.insert(
      'profile',
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve
  Future<List<Profile>> profile(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'profile',
      where: 'user_id = ?',
      whereArgs: [id],
    );
    return List.generate(maps.length, (index) => Profile.fromMap(maps[index]));
  }

  // Update
  Future<void> updateProfile(Profile profile) async {
    final db = await _databaseService.database;
    await db.update('profile', profile.toMap(),
        where: 'profile_id = ?', whereArgs: [profile.profile_id]);
  }

  // Delete
  Future<void> deleteProfile(int id) async {
    final db = await _databaseService.database;
    await db.delete('profile', where: 'profile_id = ?', whereArgs: [id]);
  }

  // Retrieve Profile Count
  Future<int> getProfileCount(int userId) async {
    final db = await _databaseService.database;
    final profileCount = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM profile WHERE user_id = ?',
      [userId],
    ));

    return profileCount ?? 0;
  }

  // Check if Profile has Appointments
  Future<bool> hasAppointments(int profileId) async {
    final db = await _databaseService.database;
    final appointmentCount = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM appointment WHERE profile_id = ?',
      [profileId],
    ));

    return appointmentCount != 0;
  }

  // Delete Appointments by Profile
  Future<void> deleteAppointmentsByProfile(int profileId) async {
    final db = await _databaseService.database;
    await db
        .delete('appointment', where: 'profile_id = ?', whereArgs: [profileId]);
  }

//////////////////////////////////////////////////////////////////////////
//// ---------------------------------------------------------------- ////
//// APPOINTMENT DATABASE ////////////////////////////////////////////////
//// ---------------------------------------------------------------- ////
//////////////////////////////////////////////////////////////////////////

  // Insert
  Future<void> insertAppointment(Appointment appointment) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    await db.insert(
      'appointment',
      appointment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve based on User and Profile
  Future<List<Appointment>> appointment(int userId, int? profileId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'appointment',
      where: 'user_id = ? AND profile_id = ?',
      whereArgs: [userId, profileId],
    );
    return List.generate(
        maps.length, (index) => Appointment.fromMap(maps[index]));
  }

  // Retrieve One Appointment Info
  Future<List<Appointment>> appointmentInfo(int? appointmentId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'appointment',
      where: 'appointment_id = ?',
      whereArgs: [appointmentId],
    );
    return List.generate(
        maps.length, (index) => Appointment.fromMap(maps[index]));
  }

  // Retrieve All
  Future<List<Appointment>> appointmentAll() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'appointment',
    );
    return List.generate(
        maps.length, (index) => Appointment.fromMap(maps[index]));
  }

  // Reschedule Appointment
  Future<void> rescheduleAppointment(Appointment appointment) async {
    final db = await _databaseService.database;
    await db.update('appointment', appointment.toMap(),
        where: 'appointment_id = ?', whereArgs: [appointment.appointment_id]);
  }

  // Update Appointment Status
  Future<void> updateAppointmentStatus(
      int id, String status, String systemRemarks) async {
    final db = await _databaseService.database;

    Map<String, dynamic> valuesToUpdate = {
      'status': status,
      'system_remarks': systemRemarks,
    };

    await db.update('appointment', valuesToUpdate,
        where: 'appointment_id = ?', whereArgs: [id]);
  }

  // Delete
  Future<void> deleteAppointment(int id) async {
    final db = await _databaseService.database;
    await db
        .delete('appointment', where: 'appointment_id = ?', whereArgs: [id]);
  }

  // Leave Remarks as Patient
  Future<void> leaveRemarksAsPatient(int id, String patientRemarks) async {
    final db = await _databaseService.database;

    Map<String, dynamic> valuesToUpdate = {
      'patient_remarks': patientRemarks,
    };

    await db.update('appointment', valuesToUpdate,
        where: 'appointment_id = ?', whereArgs: [id]);
  }

  // Leave Remarks as Practitioner
  Future<void> leaveRemarksAsPractitioner(int id, String practitionerRemarks) async {
    final db = await _databaseService.database;

    Map<String, dynamic> valuesToUpdate = {
      'practitioner_remarks': practitionerRemarks,
    };

    await db.update('appointment', valuesToUpdate,
        where: 'appointment_id = ?', whereArgs: [id]);
  }
}
