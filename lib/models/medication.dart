// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

class Medication {
  final int? medication_id;
  final String medication_name;
  final String medication_type;
  final String frequency_type;
  final int frequency_interval;
  final int daily_frequency;
  final String next_dose_day;
  final String dose_times;
  final String medication_time;
  final int medication_quantity;
  final int user_id;
  final int? profile_id;
  
  Medication({
    this.medication_id,
    required this.medication_name,
    required this.medication_type,
    required this.frequency_type,
    required this.frequency_interval,
    required this.daily_frequency,
    required this.next_dose_day,
    required this.dose_times,
    required this.medication_time,
    required this.medication_quantity,
    required this.user_id,
    required this.profile_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'medication_id': medication_id,
      'medication_name': medication_name,
      'medication_type': medication_type,
      'frequency_type': frequency_type,
      'frequency_interval': frequency_interval,
      'daily_frequency': daily_frequency,
      'next_dose_day': next_dose_day,
      'dose_times': dose_times,
      'medication_time': medication_time,
      'medication_quantity': medication_quantity,
      'user_id': user_id,
      'profile_id': profile_id,
    };
  }

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      medication_id: map['medication_id']?.toInt() ?? 0,
      medication_name: map['medication_name'] ?? '',
      medication_type: map['medication_type'] ?? '',
      frequency_type: map['frequency_type'] ?? '',
      frequency_interval: map['frequency_interval'].toInt() ?? 0,
      daily_frequency: map['daily_frequency'].toInt ?? 0,
      next_dose_day: map['next_dose_day'] ?? '',
      dose_times: map['dose_times'] ?? '',
      medication_time: map['medication_time'] ?? '',
      medication_quantity: map['medication_quantity']?.toInt() ?? 0,
      user_id: map['user_id']?.toInt() ?? 0,
      profile_id: map['profile_id']?.toInt() ?? 0,
    );
  }
  
  String toJson() => json.encode(toMap());
  factory Medication.fromJson(String source) => Medication.fromMap(json.decode(source));
  // Implement toString to make it easier to see information about each appointment when using the print statement.
  @override
  String toString() {
    return 'Medication(medication_id: $medication_id, medication_name: $medication_name, medication_type: $medication_type, frequency_type: $frequency_type, frequency_interval: $frequency_interval, daily_frequency: $daily_frequency, next_dose_day: $next_dose_day, dose_times: $dose_times, medication_time: $medication_time, medication_quantity: $medication_quantity, user_id: $user_id, profile_id: $profile_id)';
  }
}