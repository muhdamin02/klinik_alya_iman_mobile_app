// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

class BabyKicks {
  final int? kick_id;
  final int kick_count;
  final int kick_duration;
  final String kick_datetime;
  final int user_id;
  final int? profile_id;
  
  BabyKicks({
    this.kick_id,
    required this.kick_count,
    required this.kick_duration,
    required this.kick_datetime,
    required this.user_id,
    required this.profile_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'kick_id': kick_id,
      'kick_count': kick_count,
      'kick_duration': kick_duration,
      'kick_datetime': kick_datetime,
      'user_id': user_id,
      'profile_id': profile_id,
    };
  }

  factory BabyKicks.fromMap(Map<String, dynamic> map) {
    return BabyKicks(
      kick_id: map['kick_id']?.toInt() ?? 0,
      kick_count: map['kick_count'] ?? 0,
      kick_duration: map['kick_duration'] ?? 0,
      kick_datetime: map['kick_datetime'] ?? '',
      user_id: map['user_id']?.toInt() ?? 0,
      profile_id: map['profile_id']?.toInt() ?? 0,
    );
  }
  
  String toJson() => json.encode(toMap());
  factory BabyKicks.fromJson(String source) => BabyKicks.fromMap(json.decode(source));
  // Implement toString to make it easier to see information about each appointment when using the print statement.
  @override
  String toString() {
    return 'BabyKicks(kick_id: $kick_id, kick_count: $kick_count, kick_duration: $kick_duration, kick_datetime: $kick_datetime, user_id: $user_id, profile_id: $profile_id)';
  }
}