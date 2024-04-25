// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

class MedicalHistory {
  final int? medical_history_id;
  final String title;
  final String body;
  final String datetime_posted;
  final int user_id;
  final int? profile_id;

  MedicalHistory({
    this.medical_history_id,
    required this.title,
    required this.body,
    required this.datetime_posted,
    required this.user_id,
    required this.profile_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'medical_history_id': medical_history_id,
      'title': title,
      'body': body,
      'datetime_posted': datetime_posted,
      'user_id': user_id,
      'profile_id': profile_id,
    };
  }

  factory MedicalHistory.fromMap(Map<String, dynamic> map) {
    return MedicalHistory(
      medical_history_id: map['medical_history_id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      datetime_posted: map['datetime_posted'] ?? '',
      user_id: map['user_id']?.toInt() ?? 0,
      profile_id: map['profile_id'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());
  factory MedicalHistory.fromJson(String source) =>
      MedicalHistory.fromMap(json.decode(source));
  // Implement toString to make it easier to see information about each appointment when using the print statement.
  @override
  String toString() {
    return 'MedicalHistory(medical_history_id: $medical_history_id, title: $title, body: $body, datetime_posted: $datetime_posted)';
  }
}
