// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

class Profile {
  final int? profile_id;
  final String name;
  final String identification;
  final String dob;
  final String? gender;
  final double height;
  final double weight;
  final double body_fat_percentage;
  final String activity_level;
  final double belly_size;
  final String maternity;
  final String maternity_due;
  final String? ethnicity;
  final String? marital_status;
  final String occupation;
  final String medical_alert;
  final String profile_pic;
  final String creation_date;

  final int user_id;

  Profile({
    this.profile_id,
    required this.name,
    required this.identification,
    required this.dob,
    required this.gender,
    required this.height,
    required this.weight,
    required this.body_fat_percentage,
    required this.activity_level,
    required this.belly_size,
    required this.maternity,
    required this.maternity_due,
    required this.ethnicity,
    required this.marital_status,
    required this.occupation,
    required this.medical_alert,
    required this.profile_pic,
    required this.creation_date,
    required this.user_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'profile_id': profile_id,
      'name': name,
      'identification': identification,
      'dob': dob,
      'gender': gender,
      'height': height,
      'weight': weight,
      'body_fat_percentage': body_fat_percentage,
      'activity_level': activity_level,
      'belly_size': belly_size,
      'maternity': maternity,
      'maternity_due': maternity_due,
      'ethnicity': ethnicity,
      'marital_status': marital_status,
      'occupation': occupation,
      'medical_alert': medical_alert,
      'profile_pic': profile_pic,
      'creation_date': creation_date,
      'user_id': user_id,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      profile_id: map['profile_id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      identification: map['identification'] ?? '',
      dob: map['dob'] ?? '',
      gender: map['gender'] ?? '',
      height: map['height'] ?? 0,
      weight: map['weight'] ?? 0,
      body_fat_percentage: map['body_fat_percentage'] ?? 0,
      activity_level: map['activity_level'] ?? '',
      belly_size: map['belly_size'] ?? 0,
      maternity: map['maternity'] ?? '',
      maternity_due: map['maternity_due'] ?? '',
      ethnicity: map['ethnicity'] ?? '',
      marital_status: map['marital_status'] ?? '',
      occupation: map['occupation'] ?? '',
      medical_alert: map['medical_alert'] ?? '',
      profile_pic: map['profile_pic'] ?? '',
      creation_date: map['creation_date'] ?? '',
      user_id: map['user_id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());
  factory Profile.fromJson(String source) =>
      Profile.fromMap(json.decode(source));
  // Implement toString to make it easier to see information about each profile when using the print statement.
  @override
  String toString() {
    return 'User(profile_id: $profile_id, name: $name, identification: $identification, dob: $dob, gender: $gender, height: $height, weight: $weight, body_fat_percentage: $body_fat_percentage, activity_level: $activity_level, belly_size: $belly_size, maternity: $maternity, maternity_due: $maternity_due, ethnicity: $ethnicity, marital_status: $marital_status, occupation: $occupation, medical_alert: $medical_alert, profile_pic: $profile_pic, creation_date: $creation_date, user_id: $user_id)';
  }
}
