// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

class MedicationAdherence {
  final int? adherence_id;
  final String adherence_status;
  final int? profile_id;
  final int? medication_id;

  MedicationAdherence({
    this.adherence_id,
    required this.adherence_status,
    required this.profile_id,
    required this.medication_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'adherence_id': adherence_id,
      'adherence_status': adherence_status,
      'profile_id': profile_id,
      'medication_id': medication_id,
    };
  }

  factory MedicationAdherence.fromMap(Map<String, dynamic> map) {
    return MedicationAdherence(
      adherence_id: map['adherence_id']?.toInt() ?? 0,
      adherence_status: map['adherence_status'] ?? '',
      profile_id: map['profile_id']?.toInt() ?? 0,
      medication_id: map['medication_id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());
  factory MedicationAdherence.fromJson(String source) =>
      MedicationAdherence.fromMap(json.decode(source));
  // Implement toString to make it easier to see information about each appointment when using the print statement.
  @override
  String toString() {
    return 'MedicationAdherence(adherence_id: $adherence_id, adherence_status: $adherence_status, profile_id: $profile_id, medication_id: $medication_id)';
  }
}
