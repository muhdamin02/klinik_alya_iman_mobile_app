import 'package:klinik_alya_iman_mobile_app/models/newborn_care.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/appointment.dart';
import '../models/baby_kicks.dart';
import '../models/body_changes.dart';
import '../models/contractions.dart';
import '../models/health_profile.dart';
import '../models/homefeed.dart';
import '../models/medical_history.dart';
import '../models/medication.dart';
import '../models/postpartum.dart';
import '../models/profile.dart';
import '../models/symptoms.dart';
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
      'CREATE TABLE user(user_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, username TEXT NOT NULL, name TEXT NOT NULL, password TEXT NOT NULL, phone TEXT NOT NULL, email TEXT, role TEXT NOT NULL, branch TEXT)',
    );

    // profile table
    await db.execute('''
  CREATE TABLE profile(
    profile_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    name TEXT NOT NULL,
    identification TEXT NOT NULL,
    dob TEXT NOT NULL,
    gender TEXT NOT NULL,
    height REAL,
    weight REAL,
    body_fat_percentage REAL,
    activity_level TEXT,
    belly_size REAL,
    maternity TEXT NOT NULL,
    maternity_due TEXT,
    ethnicity TEXT NOT NULL,
    marital_status TEXT NOT NULL,
    occupation TEXT,
    medical_alert TEXT,
    profile_pic TEXT,
    creation_date TEXT,
    user_id INTEGER,
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE SET NULL
    );
      ''');

    // appointment table
    await db.execute('''
  CREATE TABLE appointment (
    appointment_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    appointment_date TEXT NOT NULL,
    appointment_time TEXT NOT NULL,
    user_id INTEGER NOT NULL,
    profile_id INTEGER NOT NULL,
    status TEXT NOT NULL,
    branch TEXT,
    system_remarks TEXT NOT NULL,
    patient_remarks TEXT DEFAULT 'No remarks by patient.',
    practitioner_remarks TEXT DEFAULT 'No remarks by practitioner.',
    random_id TEXT,
    practitioner_id INTEGER,
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE SET NULL,
    FOREIGN KEY (profile_id) REFERENCES profile(profile_id) ON DELETE SET NULL
  );
''');

    await db.execute('''
  CREATE TABLE medication (
    medication_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    medication_name TEXT NOT NULL,
    medication_type TEXT NOT NULL,
    frequency_type TEXT NOT NULL,
    frequency_interval INTEGER,
    daily_frequency INTEGER,
    medication_day TEXT,
    next_dose_day TEXT,
    dose_times TEXT,
    medication_quantity INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    profile_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE SET NULL,
    FOREIGN KEY (profile_id) REFERENCES profile(profile_id) ON DELETE SET NULL
  );
''');

    await db.execute('''
  CREATE TABLE homefeed (
    homefeed_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    category TEXT NOT NULL,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    datetime_posted TEXT NOT NULL
  );
''');

    await db.execute('''
  CREATE TABLE medicalhistory (
    medical_history_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    datetime_posted TEXT NOT NULL,
    user_id INTEGER NOT NULL,
    profile_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE SET NULL,
    FOREIGN KEY (profile_id) REFERENCES profile(profile_id) ON DELETE SET NULL
  );
''');

// temp
    await db.execute('''
  CREATE TABLE maternity (
    maternity_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    maternity_trimester TEXT,
    symptoms TEXT,
    educational_resources TEXT,
    baby_kicks INTEGER,
    body_changes TEXT,
    weight_gain TEXT,
    contractions INTEGER,
    postpartum_planning TEXT,
    newborn_care TEXT,
    user_id INTEGER NOT NULL,
    profile_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE SET NULL,
    FOREIGN KEY (profile_id) REFERENCES profile(profile_id) ON DELETE SET NULL
  );
''');

// temp
    await db.execute('''
  CREATE TABLE healthprofile (
    health_profile_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    allergies TEXT,
    blood_sugar_level REAL,
    current_condition TEXT,
    blood_pressure TEXT,
    user_id INTEGER NOT NULL,
    profile_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE SET NULL,
    FOREIGN KEY (profile_id) REFERENCES profile(profile_id) ON DELETE SET NULL
  );
''');

    await db.execute('''
  CREATE TABLE symptoms (
    symptom_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    symptom_category TEXT NOT NULL,
    symptom_name TEXT NOT NULL,
    symptom_description TEXT NOT NULL,
    symptom_entry_date TEXT NOT NULL,
    symptom_last_edit_date TEXT NOT NULL,
    user_id INTEGER NOT NULL,
    profile_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE SET NULL,
    FOREIGN KEY (profile_id) REFERENCES profile(profile_id) ON DELETE SET NULL
  );
''');

    await db.execute('''
  CREATE TABLE babykicks (
    kick_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    kick_count INTEGER,
    kick_duration INTEGER,
    kick_datetime TEXT,
    user_id INTEGER NOT NULL,
    profile_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE SET NULL,
    FOREIGN KEY (profile_id) REFERENCES profile(profile_id) ON DELETE SET NULL
  );
''');

    await db.execute('''
  CREATE TABLE bodychanges (
    body_changes_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    weightbelly INT,
    increased INT,
    body_changes TEXT,
    p_body_weight REAL,
    p_belly_size REAL,
    c_body_weight REAL,
    c_belly_size REAL,
    datetime TEXT,
    user_id INTEGER NOT NULL,
    profile_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE SET NULL,
    FOREIGN KEY (profile_id) REFERENCES profile(profile_id) ON DELETE SET NULL
  );
''');

    await db.execute('''
  CREATE TABLE newborncare (
    care_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    care_category INT NOT NULL,
    care_title TEXT NOT NULL,
    care_content TEXT NOT NULL,
    last_edited TEXT NOT NULL
  );
''');

    await db.execute('''
  CREATE TABLE postpartum (
    postpartum_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    postpartum_category INT NOT NULL,
    postpartum_title TEXT NOT NULL,
    postpartum_content TEXT NOT NULL,
    last_edited TEXT NOT NULL
  );
''');

    await db.execute('''
  CREATE TABLE contraction (
    contraction_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    contraction_duration INTEGER,
    contraction_rating INTEGER,
    contraction_datetime TEXT,
    user_id INTEGER NOT NULL,
    profile_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE SET NULL,
    FOREIGN KEY (profile_id) REFERENCES profile(profile_id) ON DELETE SET NULL
  );
''');

    await db.execute('''
  CREATE TABLE medicationadherence (
    adherence_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    adherence_status TEXT NOT NULL,
    medication_id INTEGER NOT NULL,
    profile_id INTEGER NOT NULL,
    FOREIGN KEY (medication_id) REFERENCES medication(medication_id) ON DELETE SET NULL,
    FOREIGN KEY (profile_id) REFERENCES profile(profile_id) ON DELETE SET NULL
  );
''');

    // system guest
    // DO NOT TOUCH
    await db.execute(
      'INSERT INTO user (username, name, password, phone, email, role, branch) VALUES (?, ?, ?, ?, ?, ?, ?)',
      ['-', 'Guest', '-', '-', '-', 'guest', '-'],
    );

    // practitioner 1
    await db.execute(
      'INSERT INTO user (username, name, password, phone, email, role, branch) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [
        'd',
        'Muhammad Shahid bin Shamsul Anuar',
        'd',
        '0136281168',
        'shahid@gmail.com',
        'practitioner',
        'Karang Darat'
      ],
    );

    // practitioner 2
    await db.execute(
      'INSERT INTO user (username, name, password, phone, email, role, branch) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [
        'd2',
        'Muhammad Syazwan Redza bin Muhammad Sadzalee',
        'd2',
        '0136026669',
        'syazwan@gmail.com',
        'practitioner',
        'Inderapura'
      ],
    );

    // practitioner 3
    await db.execute(
      'INSERT INTO user (username, name, password, phone, email, role, branch) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [
        'd3',
        'Yasmin Anisah binti Khalid',
        'd3',
        '01118870942',
        'yasmin@gmail.com',
        'practitioner',
        'Kemaman'
      ],
    );

    // system admin
    await db.execute(
      'INSERT INTO user (username, name, password, phone, email, role, branch) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [
        'sa',
        'Abdullah bin Abdul Samad',
        'sa',
        '0123456789',
        'abu@gmail.com',
        'systemadmin',
        '-'
      ],
    );

    // patient
    await db.execute(
      'INSERT INTO user (username, name, password, phone, email, role, branch) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [
        'p',
        'Muhammad Amin bin Shamsul Anuar',
        'p',
        '0104081975',
        'amin@gmail.com',
        'patient',
        '-'
      ],
    );

    // homefeed 1
    await db.execute(
      'INSERT INTO homefeed (category, title, body, datetime_posted) VALUES (?, ?, ?, ?)',
      [
        'News',
        'Holiday Schedule Announcement',
        'In celebration of the upcoming holidays, our clinic will have adjusted hours. Please take note of our special schedule to ensure we can continue to provide excellent care during this festive season. Wishing you all happy and healthy holidays!',
        '12-1-2024'
      ],
    );

    // homefeed 2
    await db.execute(
      'INSERT INTO homefeed (category, title, body, datetime_posted) VALUES (?, ?, ?, ?)',
      [
        'News',
        'Important COVID-19 Update',
        'In response to the latest COVID-19 developments, we want to assure you that we are closely monitoring the situation. Our clinic continues to follow all safety protocols to ensure a safe environment for both patients and staff. Stay informed and stay safe.',
        '13-1-2024'
      ],
    );
  }

//////////////////////////////////////////////////////////////////////////
//// ---------------------------------------------------------------- ////
//// HOMEFEED DATABASE ///////////////////////////////////////////////////
//// ---------------------------------------------------------------- ////
//////////////////////////////////////////////////////////////////////////

  // Home Feed All
  Future<List<HomeFeed>> homeFeedAll() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'homefeed',
    );
    return List.generate(maps.length, (index) => HomeFeed.fromMap(maps[index]));
  }

  // Insert
  Future<void> newAnnouncement(HomeFeed homeFeed) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    await db.insert(
      'homefeed',
      homeFeed.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

//////////////////////////////////////////////////////////////////////////
//// ---------------------------------------------------------------- ////
//// TRACK SYMPTOMS //////////////////////////////////////////////////////
//// ---------------------------------------------------------------- ////
//////////////////////////////////////////////////////////////////////////

// Retrieve based on User and Profile
  Future<List<Symptoms>> retrieveSymptoms(int userId, int? profileId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'symptoms',
      where: 'user_id = ? AND profile_id = ?',
      whereArgs: [userId, profileId],
    );
    return List.generate(maps.length, (index) => Symptoms.fromMap(maps[index]));
  }

  // Insert
  Future<void> newSymptomEntry(Symptoms symptoms) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    await db.insert(
      'symptoms',
      symptoms.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

//////////////////////////////////////////////////////////////////////////
//// ---------------------------------------------------------------- ////
//// BABY KICKS //////////////////////////////////////////////////////////
//// ---------------------------------------------------------------- ////
//////////////////////////////////////////////////////////////////////////

// Retrieve based on User and Profile
  Future<List<BabyKicks>> retrieveBabyKicks(int userId, int? profileId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'babykicks',
      where: 'user_id = ? AND profile_id = ?',
      whereArgs: [userId, profileId],
    );
    return List.generate(
        maps.length, (index) => BabyKicks.fromMap(maps[index]));
  }

  // Insert
  Future<void> newBabyKicks(BabyKicks babyKicks) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    await db.insert(
      'babykicks',
      babyKicks.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

//////////////////////////////////////////////////////////////////////////
//// ---------------------------------------------------------------- ////
//// BODY CHANGES //////////////////////////////////////////////////////////
//// ---------------------------------------------------------------- ////
//////////////////////////////////////////////////////////////////////////

// Retrieve based on User and Profile
  Future<List<BodyChanges>> retrieveBodyChanges(
      int userId, int? profileId, int weightbelly) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'bodychanges',
      where: 'user_id = ? AND profile_id = ? AND weightbelly = ?',
      whereArgs: [userId, profileId, weightbelly],
    );
    return List.generate(
        maps.length, (index) => BodyChanges.fromMap(maps[index]));
  }

  // Insert
  Future<void> newBodyChanges(BodyChanges bodyChanges) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    await db.insert(
      'bodyChanges',
      bodyChanges.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //////////////////////////////////////////////////////////////////////////
//// ---------------------------------------------------------------- ////
//// NEWBORN CARE ////////////////////////////////////////////
//// ---------------------------------------------------------------- ////
//////////////////////////////////////////////////////////////////////////

  // Retrieve based on User and Profile
  Future<List<NewbornCare>> retrieveNewbornCareContent(int category) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'newborncare',
      where: 'care_category = ?',
      whereArgs: [category],
    );
    return List.generate(
        maps.length, (index) => NewbornCare.fromMap(maps[index]));
  }

  //////////////////////////////////////////////////////////////////////////
//// ---------------------------------------------------------------- ////
//// POSTPARTUM ////////////////////////////////////////////
//// ---------------------------------------------------------------- ////
//////////////////////////////////////////////////////////////////////////

  // Retrieve based on User and Profile
  Future<List<Postpartum>> retrievePostpartumContent(int category) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'postpartum',
      where: 'postpartum_category = ?',
      whereArgs: [category],
    );
    return List.generate(
        maps.length, (index) => Postpartum.fromMap(maps[index]));
  }

//////////////////////////////////////////////////////////////////////////
//// ---------------------------------------------------------------- ////
//// CONTRACTION //////////////////////////////////////////////////////////
//// ---------------------------------------------------------------- ////
//////////////////////////////////////////////////////////////////////////

// Retrieve based on User and Profile
  Future<List<Contraction>> retrieveContraction(
      int userId, int? profileId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'contraction',
      where: 'user_id = ? AND profile_id = ?',
      whereArgs: [userId, profileId],
    );
    return List.generate(
        maps.length, (index) => Contraction.fromMap(maps[index]));
  }

  // Insert
  Future<void> newContraction(Contraction contraction) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    await db.insert(
      'contraction',
      contraction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

//////////////////////////////////////////////////////////////////////////
//// ---------------------------------------------------------------- ////
//// MEDICAL HISTORY DATABASE ////////////////////////////////////////////
//// ---------------------------------------------------------------- ////
//////////////////////////////////////////////////////////////////////////

// health profile
// Retrieve One Appointment Info
  Future<List<HealthProfile>> healthInfo(int? profileId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'healthprofile',
      where: 'profile_id = ?',
      whereArgs: [profileId],
    );
    return List.generate(
        maps.length, (index) => HealthProfile.fromMap(maps[index]));
  }

  // Retrieve based on User and Profile
  Future<List<MedicalHistory>> retrieveMedHistory(
      int userId, int? profileId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medicalhistory',
      where: 'user_id = ? AND profile_id = ?',
      whereArgs: [userId, profileId],
    );
    return List.generate(
        maps.length, (index) => MedicalHistory.fromMap(maps[index]));
  }

  // Insert
  Future<void> newMedHistoryEntry(MedicalHistory medicalHistory) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    await db.insert(
      'medicalhistory',
      medicalHistory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
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

  // check if user exists
  Future<bool> checkUserExists(String username) async {
    final db = await _databaseService.database;
    final count = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM user WHERE username = ?',
      [username],
    ));
    return count != null && count > 0;
  }

  // // Check if email exists
  // Future<bool> checkEmailExists(String email) async {
  //   final db = await _databaseService.database;
  //   final count = Sqflite.firstIntValue(await db.rawQuery(
  //     'SELECT COUNT(*) FROM user WHERE email = ?',
  //     [email],
  //   ));
  //   return count != null && count > 0;
  // }

  // Retrieve All
  Future<List<User>> userAll() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user',
      where: 'role != ?',
      whereArgs: ['guest'],
    );
    return List.generate(maps.length, (index) => User.fromMap(maps[index]));
  }

  // Retrieve All Patients
  Future<List<User>> userPatient() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user',
      where: 'role = ?',
      whereArgs: ['patient'],
    );
    return List.generate(maps.length, (index) => User.fromMap(maps[index]));
  }

  // Retrieve All Practitioner
  Future<List<User>> userPractitioner() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user',
      where: 'role = ?',
      whereArgs: ['practitioner'],
    );
    return List.generate(maps.length, (index) => User.fromMap(maps[index]));
  }

  // Retrieve One User Info
  Future<List<User>> userInfo(int? userId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (index) => User.fromMap(maps[index]));
  }

  // Retrieve User Name
  Future<String?> getUserName(int? userId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    // Assuming 'f_name' is a column in the 'user' table
    final String firstName = maps.first['name'];

    return firstName;
  }

  // Retrieve List of Practitioners
  Future<List<User>> getPractitionerDDL() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user',
      where: 'role = ?',
      whereArgs: ['practitioner'],
    ); // Specify the columns you want to retrieve
    return List.generate(maps.length, (index) => User.fromMap(maps[index]));
  }

  // Retrieve List of Practitioners with the same branch as the given appointment branch
  Future<List<User>> getPractitionersByBranch(String appointmentBranch) async {
    final db = await _databaseService.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'user',
      where: 'role = ? AND branch = ?',
      whereArgs: ['practitioner', appointmentBranch],
    );

    return List.generate(maps.length, (index) => User.fromMap(maps[index]));
  }

//////////////////////////////////////////////////////////////////////////
//// ---------------------------------------------------------------- ////
//// PROFILE DATABASE ////////////////////////////////////////////////////
//// ---------------------------------------------------------------- ////
//////////////////////////////////////////////////////////////////////////

  // Create profile
  Future<void> insertProfile(Profile profile) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Insert the profile and get the profile_id of the inserted row
    int profileId = await db.insert(
      'profile',
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Create the health profile with the retrieved profile_id
    createHealthProfile(profile, profileId);
  }

// Create health profile
  Future<void> createHealthProfile(Profile profile, int profileId) async {
    final db = await _databaseService.database;

    HealthProfile health = HealthProfile(
      allergies: 'Not specified',
      blood_sugar_level: 0,
      current_condition: 'Not specified',
      blood_pressure: 'Not set',
      user_id: profile.user_id,
      profile_id: profileId,
    );

    await db.insert(
      'healthprofile',
      health.toMap(),
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

  // Retrieve One Profile Info
  Future<List<Profile>> profileInfo(int? profileId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Profile',
      where: 'profile_id = ?',
      whereArgs: [profileId],
    );
    return List.generate(maps.length, (index) => Profile.fromMap(maps[index]));
  }

  // Retrieve profiles based on a list of profile_ids
  Future<List<Profile>> profilesByProfileIds(List<int?> profileIds) async {
    final db = await database;

    // Use the "IN" clause to fetch profiles with matching profile_ids
    final List<Map<String, dynamic>> maps = await db.query(
      'profile',
      where: 'profile_id IN (${profileIds.map((_) => '?').join(', ')})',
      whereArgs: profileIds,
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

  // Check if Profile has Medication
  Future<bool> hasMedication(int profileId) async {
    final db = await _databaseService.database;
    final medicationCount = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM medication WHERE profile_id = ?',
      [profileId],
    ));

    return medicationCount != 0;
  }

  // Delete Appointments by Profile
  Future<void> deleteAppointmentsByProfile(int profileId) async {
    final db = await _databaseService.database;
    await db
        .delete('appointment', where: 'profile_id = ?', whereArgs: [profileId]);
  }

  // Delete Medication by Profile
  Future<void> deleteMedicationByProfile(int profileId) async {
    final db = await _databaseService.database;
    await db
        .delete('medication', where: 'profile_id = ?', whereArgs: [profileId]);
  }

  Future<int> getLatestProfileId(int userId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT profile_id FROM profile
      WHERE user_id = ?
      ORDER BY profile_id DESC
      LIMIT 1
    ''', [userId]);

    if (result.isNotEmpty) {
      return result.first['profile_id'] as int;
    }

    return 0;
  }

  // Set Maternity
  Future<void> setMaternity(int id, String maternityValue) async {
    final db = await _databaseService.database;

    Map<String, dynamic> valuesToUpdate = {
      'maternity': maternityValue,
    };

    await db.update('profile', valuesToUpdate,
        where: 'profile_id = ?', whereArgs: [id]);
  }

  // Retrieve Profile Weight
  Future<double> retrieveProfileWeight(int? profileId) async {
    final db = await _databaseService.database;

    // Perform the query
    final List<Map<String, dynamic>> results = await db.query(
      'profile', // Table name
      columns: ['weight'], // Columns to retrieve
      where: 'profile_id = ?', // WHERE clause
      whereArgs: [profileId], // Arguments for the WHERE clause
    );

    // Check if any results were returned
    if (results.isNotEmpty) {
      // Extract the weight from the first result
      final double profileWeight = results.first['weight'];
      return profileWeight;
    } else {
      // Return a default value or handle the case where no results were found
      return 0.0; // Default value
    }
  }

  // Retrieve Profile Belly Size
  Future<double> retrieveProfileBellySize(int? profileId) async {
    final db = await _databaseService.database;

    // Perform the query
    final List<Map<String, dynamic>> results = await db.query(
      'profile', // Table name
      columns: ['belly_size'], // Columns to retrieve
      where: 'profile_id = ?', // WHERE clause
      whereArgs: [profileId], // Arguments for the WHERE clause
    );

    // Check if any results were returned
    if (results.isNotEmpty) {
      // Extract the weight from the first result
      final double profileBellySize = results.first['belly_size'];
      return profileBellySize;
    } else {
      // Return a default value or handle the case where no results were found
      return 0.0; // Default value
    }
  }

  // Set Belly Size
  Future<void> setWeight(int? profileId, double weight) async {
    final db = await _databaseService.database;

    // Perform the query
    await db.update(
      'profile', // Table name
      {'weight': weight}, // Updated values
      where: 'profile_id = ?', // WHERE clause
      whereArgs: [profileId], // WHERE clause arguments
    );
  }

  // Set Belly Size
  Future<void> setBellySize(int? profileId, double bellySize) async {
    final db = await _databaseService.database;

    // Perform the query
    await db.update(
      'profile', // Table name
      {'belly_size': bellySize}, // Updated values
      where: 'profile_id = ?', // WHERE clause
      whereArgs: [profileId], // WHERE clause arguments
    );
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

  // Check if an appointment already exists for a given date and time
  Future<bool> isAppointmentDateConfirmed(
      String appointmentDate, String appointmentTime) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'appointment',
      where: 'appointment_date = ? AND appointment_time = ? AND status = ?',
      whereArgs: [appointmentDate, appointmentTime, 'Confirmed'],
    );

    return maps.isNotEmpty;
  }

  // Check if an appointment already exists for a given date, time, and branch
  // Check if an appointment already exists for a given date, time, and branch with specific statuses
  Future<bool> isAppointmentDateConfirmedBranch(
      String appointmentDate, String appointmentTime, String branch) async {
    final db = await _databaseService.database;

    // Construct the where clause
    const String whereClause = '''
    appointment_date = ? AND
    appointment_time = ? AND
    branch = ? AND
    status IN (?, ?, ?)
  ''';

    // Execute the query
    final List<Map<String, dynamic>> maps = await db.query(
      'appointment',
      where: whereClause,
      whereArgs: [
        appointmentDate,
        appointmentTime,
        branch,
        'Confirmed',
        'Assigned',
        'Updated'
      ],
    );

    return maps.isNotEmpty;
  }

  // Retrieve All (upcoming)
  Future<List<Appointment>> appointmentAllUpcoming() async {
    final db = await _databaseService.database;

    // Get today's date in the format yyyy-MM-dd
    final todayDate = DateTime.now().toLocal().toString().split(' ')[0];

    final List<Map<String, dynamic>> maps = await db.query(
      'appointment',
      where: 'appointment_date > ?',
      whereArgs: [todayDate],
    );

    return List.generate(
        maps.length, (index) => Appointment.fromMap(maps[index]));
  }

  // Retrieve All (today)
  Future<List<Appointment>> appointmentAllToday() async {
    final db = await _databaseService.database;

    // Get today's date in the format yyyy-MM-dd
    final todayDate = DateTime.now().toLocal().toString().split(' ')[0];

    final List<Map<String, dynamic>> maps = await db.query(
      'appointment',
      where: 'appointment_date = ?',
      whereArgs: [todayDate],
    );

    return List.generate(
        maps.length, (index) => Appointment.fromMap(maps[index]));
  }

  // Retrieve All (past)
  Future<List<Appointment>> appointmentAllPast() async {
    final db = await _databaseService.database;

    // Get today's date in the format yyyy-MM-dd
    final todayDate = DateTime.now().toLocal().toString().split(' ')[0];

    final List<Map<String, dynamic>> maps = await db.query(
      'appointment',
      where: 'appointment_date < ?',
      whereArgs: [todayDate],
    );

    return List.generate(
        maps.length, (index) => Appointment.fromMap(maps[index]));
  }

  // Retrieve based on User and Profile (upcoming)
  Future<List<Appointment>> appointmentUpcoming(
      int userId, int? profileId) async {
    final db = await _databaseService.database;

    // Get today's date in the format yyyy-MM-dd
    final todayDate = DateTime.now().toLocal().toString().split(' ')[0];

    final List<Map<String, dynamic>> maps = await db.query(
      'appointment',
      where: 'user_id = ? AND profile_id = ? AND appointment_date > ?',
      whereArgs: [userId, profileId, todayDate],
    );

    return List.generate(
        maps.length, (index) => Appointment.fromMap(maps[index]));
  }

  // Retrieve based on User and Profile (today)
  Future<List<Appointment>> appointmentToday(int userId, int? profileId) async {
    final db = await _databaseService.database;

    // Get today's date in the format yyyy-MM-dd
    final todayDate = DateTime.now().toLocal().toString().split(' ')[0];

    final List<Map<String, dynamic>> maps = await db.query(
      'appointment',
      where: 'user_id = ? AND profile_id = ? AND appointment_date = ?',
      whereArgs: [userId, profileId, todayDate],
    );

    return List.generate(
        maps.length, (index) => Appointment.fromMap(maps[index]));
  }

  // Retrieve based on User and Profile (past)
  Future<List<Appointment>> pastAppointments(int userId, int? profileId) async {
    final db = await _databaseService.database;

    // Get today's date in the format yyyy-MM-dd
    final todayDate = DateTime.now().toLocal().toString().split(' ')[0];

    final List<Map<String, dynamic>> maps = await db.query(
      'appointment',
      where: 'user_id = ? AND profile_id = ? AND appointment_date < ?',
      whereArgs: [userId, profileId, todayDate],
    );

    return List.generate(
      maps.length,
      (index) => Appointment.fromMap(maps[index]),
    );
  }

  // Retrieve based on User and Profile (upcoming) for practitioners
  Future<List<Appointment>> appointmentUpcomingPractitioner(
      int? practitionerId) async {
    final db = await _databaseService.database;

    // Get today's date in the format yyyy-MM-dd
    final todayDate = DateTime.now().toLocal().toString().split(' ')[0];

    final List<Map<String, dynamic>> maps = await db.query(
      'appointment',
      where: 'practitioner_id = ? AND appointment_date > ?',
      whereArgs: [practitionerId, todayDate],
    );

    return List.generate(
        maps.length, (index) => Appointment.fromMap(maps[index]));
  }

  // Retrieve based on User and Profile (today) for practitioners
  Future<List<Appointment>> appointmentTodayPractitioner(
      int? practitionerId) async {
    final db = await _databaseService.database;

    // Get today's date in the format yyyy-MM-dd
    final todayDate = DateTime.now().toLocal().toString().split(' ')[0];

    final List<Map<String, dynamic>> maps = await db.query(
      'appointment',
      where: 'practitioner_id = ? AND appointment_date = ?',
      whereArgs: [practitionerId, todayDate],
    );

    return List.generate(
        maps.length, (index) => Appointment.fromMap(maps[index]));
  }

  // Retrieve based on User and Profile (past) for practitioners
  Future<List<Appointment>> pastAppointmentsPractitioner(
      int? practitionerId) async {
    final db = await _databaseService.database;

    // Get today's date in the format yyyy-MM-dd
    final todayDate = DateTime.now().toLocal().toString().split(' ')[0];

    final List<Map<String, dynamic>> maps = await db.query(
      'appointment',
      where: 'practitioner_id = ? AND appointment_date < ?',
      whereArgs: [practitionerId, todayDate],
    );

    return List.generate(
      maps.length,
      (index) => Appointment.fromMap(maps[index]),
    );
  }

  Future<int> countPatientsUnderCare(int practitionerId) async {
    final db = await _databaseService.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'appointment',
      where: 'practitioner_id = ?',
      whereArgs: [practitionerId],
    );

    final Set<int> uniqueProfileIds = <int>{};

    for (final map in maps) {
      final Appointment appointment = Appointment.fromMap(map);
      final int profileId = appointment.profile_id!;

      uniqueProfileIds.add(profileId);
    }

    return uniqueProfileIds.length;
  }

  Future<int> countMaternityPatientsUnderCare(int practitionerId) async {
    final db = await _databaseService.database;

    // Perform a raw query to join the appointment and profile tables
    final List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT DISTINCT a.profile_id 
      FROM appointment a
      JOIN profile p ON a.profile_id = p.profile_id
      WHERE a.practitioner_id = ? AND p.maternity <> ?
    ''', [practitionerId, 'No']);

    // Use a set to ensure unique profile IDs
    final Set<int> uniqueProfileIds = <int>{};

    for (final map in results) {
      uniqueProfileIds.add(map['profile_id'] as int);
    }

    return uniqueProfileIds.length;
  }

  // Retrieve based on User and Profile (all) for practitioners
  Future<List<Appointment>> patientsUnderCare(
    int? practitionerId,
  ) async {
    final db = await _databaseService.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'appointment',
      where: 'practitioner_id = ?',
      whereArgs: [practitionerId],
    );

    final Set<int> uniqueProfileIds = <int>{};
    final List<Appointment> uniqueAppointments = [];

    for (final map in maps) {
      final Appointment appointment = Appointment.fromMap(map);
      final int profileId = appointment.profile_id!;

      if (!uniqueProfileIds.contains(profileId)) {
        uniqueProfileIds.add(profileId);
        uniqueAppointments.add(appointment);
      }
    }

    return uniqueAppointments;
  }

  // // Retrieve based on User and Profile (all) for practitioners
  // Future<List<Appointment>> maternityPatientsUnderCare(
  //   int? practitionerId,
  // ) async {
  //   final db = await _databaseService.database;

  //   final List<Map<String, dynamic>> maps = await db.query(
  //     'appointment',
  //     where: 'practitioner_id = ?',
  //     whereArgs: [practitionerId],
  //   );

  //   final Set<int> uniqueProfileIds = <int>{};
  //   final List<Appointment> uniqueAppointments = [];

  //   for (final map in maps) {
  //     final Appointment appointment = Appointment.fromMap(map);
  //     final int profileId = appointment.profile_id!;

  //     if (!uniqueProfileIds.contains(profileId)) {
  //       uniqueProfileIds.add(profileId);
  //       uniqueAppointments.add(appointment);
  //     }
  //   }

  //   return uniqueAppointments;
  // }

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

  // Assign Practitioner to Appointment
  Future<void> assignAppointmentPractitioner(
      int appointmentId, int practitionerId) async {
    final db = await _databaseService.database;

    Map<String, dynamic> valuesToUpdate = {
      'practitioner_id': practitionerId,
    };

    await db.update('appointment', valuesToUpdate,
        where: 'appointment_id = ?', whereArgs: [appointmentId]);
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
  Future<void> leaveRemarksAsPractitioner(
      int id, String practitionerRemarks) async {
    final db = await _databaseService.database;

    Map<String, dynamic> valuesToUpdate = {
      'practitioner_remarks': practitionerRemarks,
    };

    await db.update('appointment', valuesToUpdate,
        where: 'appointment_id = ?', whereArgs: [id]);
  }

  // Retrieve Patient Name
  Future<String?> getPatientName(int? profileId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'profile',
      where: 'profile_id = ?',
      whereArgs: [profileId],
    );

    // Assuming 'f_name' and 'l_name' are columns in the 'appointment' table
    final String patientName = maps.first['name'];

    return patientName;
  }

  // appointment count by status
  Future<int> getAppointmentCountStatus(int? profileId, String status) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'appointment',
      where: 'profile_id = ? AND status = ?',
      whereArgs: [profileId, status],
    );
    return maps.length;
  }

//////////////////////////////////////////////////////////////////////////
//// ---------------------------------------------------------------- ////
//// MEDICATION DATABASE ////////////////////////////////////////////////
//// ---------------------------------------------------------------- ////
//////////////////////////////////////////////////////////////////////////

  // Insert
  Future<void> insertMedication(Medication medication) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    await db.insert(
      'medication',
      medication.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve based on User and Profile
  Future<List<Medication>> medication(int userId, int? profileId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medication',
      where: 'user_id = ? AND profile_id = ?',
      whereArgs: [userId, profileId],
    );
    return List.generate(
        maps.length, (index) => Medication.fromMap(maps[index]));
  }

  // Retrieve based on User
  Future<List<Medication>> medicationUser(int userId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medication',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return List.generate(
        maps.length, (index) => Medication.fromMap(maps[index]));
  }

  // Retrieve One Appointment Info
  Future<List<Medication>> medicationInfo(int? medicationId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medication',
      where: 'medication_id = ?',
      whereArgs: [medicationId],
    );
    return List.generate(
        maps.length, (index) => Medication.fromMap(maps[index]));
  }

  // Retrieve All
  Future<List<Medication>> medicationAll() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medication',
    );
    return List.generate(
        maps.length, (index) => Medication.fromMap(maps[index]));
  }

  // Edit Medication
  Future<void> editMedication(Medication medication) async {
    final db = await _databaseService.database;
    await db.update('medication', medication.toMap(),
        where: 'medication_id = ?', whereArgs: [medication.medication_id]);
  }

  // Delete
  Future<void> deleteMedication(int id) async {
    final db = await _databaseService.database;
    await db.delete('medication', where: 'medication_id = ?', whereArgs: [id]);
  }

  // Retrieve Medicine Count
  Future<int> getMedicineCount(int userId) async {
    final db = await _databaseService.database;
    final medicineCount = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM medicine WHERE user_id = ?',
      [userId],
    ));

    return medicineCount ?? 0;
  }
}
