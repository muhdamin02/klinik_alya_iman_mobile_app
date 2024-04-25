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
      user_id: map['user_id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());
  factory Profile.fromJson(String source) =>
      Profile.fromMap(json.decode(source));
  // Implement toString to make it easier to see information about each profile when using the print statement.
  @override
  String toString() {
    return 'User(profile_id: $profile_id, name: $name, identification: $identification, dob: $dob, gender: $gender, height: $height, weight: $weight, body_fat_percentage: $body_fat_percentage, activity_level: $activity_level, belly_size: $belly_size, maternity: $maternity, user_id: $user_id)';
  }
}
