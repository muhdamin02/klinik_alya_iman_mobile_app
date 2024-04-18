// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

class Symptoms {
  final int? symptom_id;
  final String symptom_category;
  final String symptom_name;
  final String symptom_description;
  final String symptom_entry_date;
  final String symptom_last_edit_date;
  final int user_id;
  final int? profile_id;

  Symptoms({
    this.symptom_id,
    required this.symptom_category,
    required this.symptom_name,
    required this.symptom_description,
    required this.symptom_entry_date,
    required this.symptom_last_edit_date,
    required this.user_id,
    required this.profile_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'symptom_id': symptom_id,
      'symptom_category': symptom_category,
      'symptom_name': symptom_name,
      'symptom_description': symptom_description,
      'symptom_entry_date': symptom_entry_date,
      'symptom_last_edit_date': symptom_last_edit_date,
      'user_id': user_id,
      'profile_id': profile_id,
    };
  }

  factory Symptoms.fromMap(Map<String, dynamic> map) {
    return Symptoms(
        symptom_id: map['symptom_id']?.toInt() ?? 0,
        symptom_category: map['symptom_category'] ?? '',
        symptom_name: map['symptom_name'] ?? '',
        symptom_description: map['symptom_description'] ?? '',
        symptom_entry_date: map['symptom_entry_date'] ?? '',
        symptom_last_edit_date: map['symptom_last_edit_date'] ?? '',
        user_id: map['user_id']?.toInt() ?? 0,
        profile_id: map['profile_id']?.toInt() ?? 0);
  }

  String toJson() => json.encode(toMap());
  factory Symptoms.fromJson(String source) =>
      Symptoms.fromMap(json.decode(source));
  // Implement toString to make it easier to see information about each appointment when using the print statement.
  @override
  String toString() {
    return 'Symptoms(symptom_id: $symptom_id, symptom_category: $symptom_category, symptom_name: $symptom_name, symptom_description: $symptom_description, symptom_entry_date: $symptom_entry_date, symptom_last_edit_date: $symptom_last_edit_date, user_id: $user_id, profile_id: $profile_id)';
  }
}
