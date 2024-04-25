// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

class BodyChanges {
  final int? body_changes_id;
  final String body_changes;
  final double p_body_weight;
  final double p_belly_size;
  final double c_body_weight;
  final double c_belly_size;
  final String datetime;
  final int user_id;
  final int? profile_id;

  BodyChanges({
    this.body_changes_id,
    required this.body_changes,
    required this.p_body_weight,
    required this.p_belly_size,
    required this.c_body_weight,
    required this.c_belly_size,
    required this.datetime,
    required this.user_id,
    required this.profile_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'body_changes_id': body_changes_id,
      'body_changes': body_changes,
      'p_body_weight': p_body_weight,
      'p_belly_size': p_belly_size,
      'c_body_weight': c_body_weight,
      'c_belly_size': c_belly_size,
      'datetime': datetime,
      'user_id': user_id,
      'profile_id': profile_id,
    };
  }

  factory BodyChanges.fromMap(Map<String, dynamic> map) {
    return BodyChanges(
      body_changes_id: map['body_changes_id']?.toInt() ?? 0,
      body_changes: map['body_changes'] ?? '',
      p_body_weight: map['p_body_weight'] ?? 0,
      p_belly_size: map['p_belly_size'] ?? 0,
      c_body_weight: map['c_body_weight'] ?? 0,
      c_belly_size: map['c_belly_size'] ?? 0,
      datetime: map['datetime'] ?? '',
      user_id: map['user_id']?.toInt() ?? 0,
      profile_id: map['profile_id'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());
  factory BodyChanges.fromJson(String source) =>
      BodyChanges.fromMap(json.decode(source));
  // Implement toString to make it easier to see information about each appointment when using the print statement.
  @override
  String toString() {
    return 'BodyChanges(body_changes_id: $body_changes_id, body_changes: $body_changes, p_body_weight: $p_body_weight, p_belly_size: $p_belly_size, c_body_weight: $c_body_weight, c_belly_size: $c_belly_size, datetime: $datetime)';
  }
}
