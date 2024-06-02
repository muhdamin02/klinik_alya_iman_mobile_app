// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

class HealthProfile {
  final int? health_profile_id;
  final String allergies;
  final double blood_sugar_level;
  final String current_condition;
  final String blood_pressure;
  final int user_id;
  final int? profile_id;

  HealthProfile({
    this.health_profile_id,
    required this.allergies,
    required this.blood_sugar_level,
    required this.current_condition,
    required this.blood_pressure,
    required this.user_id,
    required this.profile_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'health_profile_id': health_profile_id,
      'allergies': allergies,
      'blood_sugar_level': blood_sugar_level,
      'current_condition': current_condition,
      'blood_pressure': blood_pressure,
      'user_id': user_id,
      'profile_id': profile_id,
    };
  }

  factory HealthProfile.fromMap(Map<String, dynamic> map) {
    return HealthProfile(
      health_profile_id: map['health_profile_id']?.toInt() ?? 0,
      allergies: map['allergies'] ?? '',
      blood_sugar_level: map['blood_sugar_level']?.toDouble() ?? 0,
      current_condition: map['current_condition'] ?? '',
      blood_pressure: map['blood_pressure'] ?? '',
      user_id: map['user_id']?.toInt() ?? 0,
      profile_id: map['profile_id'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());
  factory HealthProfile.fromJson(String source) =>
      HealthProfile.fromMap(json.decode(source));
  // Implement toString to make it easier to see information about each appointment when using the print statement.
  @override
  String toString() {
    return 'HealthProfile(health_profile_id: $health_profile_id, allergies: $allergies, blood_sugar_level: $blood_sugar_level, current_condition: $current_condition, blood_pressure: $blood_pressure, user_id: $user_id, profile_id: $profile_id)';
  }
}
