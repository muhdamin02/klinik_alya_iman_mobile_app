// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

class Profile {
  final int? profile_id;
  final String f_name;
  final String l_name;
  final String dob;
  final String? gender;
  final int user_id;
  Profile({
    this.profile_id,
    required this.f_name,
    required this.l_name,
    required this.dob,
    required this.gender,
    required this.user_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'profile_id': profile_id,
      'f_name': f_name,
      'l_name': l_name,
      'dob': dob,
      'gender': gender,
      'user_id': user_id,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      profile_id: map['profile_id']?.toInt() ?? 0,
      f_name: map['f_name'] ?? '',
      l_name: map['l_name'] ?? '',
      dob: map['dob'] ?? '',
      gender: map['gender'] ?? '',
      user_id: map['user_id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());
  factory Profile.fromJson(String source) =>
      Profile.fromMap(json.decode(source));
  // Implement toString to make it easier to see information about each profile when using the print statement.
  @override
  String toString() {
    return 'User(profile_id: $profile_id, f_name: $f_name, l_name: $l_name, dob: $dob, gender: $gender, user_id: $user_id)';
  }
}
