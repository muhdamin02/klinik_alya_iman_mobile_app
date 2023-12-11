// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

class Appointment {
  final int? appointment_id;
  final String appointment_date;
  final int user_id;
  final int? profile_id;
  final String status;
  final String remarks;
  final int? practitioner_id;
  
  Appointment({
    this.appointment_id,
    required this.appointment_date,
    required this.user_id,
    required this.profile_id,
    required this.status,
    required this.remarks,
    required this.practitioner_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'appointment_id': appointment_id,
      'appointment_date': appointment_date,
      'user_id': user_id,
      'profile_id': profile_id,
      'status': status,
      'remarks': remarks,
      'practitioner_id': practitioner_id,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      appointment_id: map['appointment_id']?.toInt() ?? 0,
      appointment_date: map['appointment_date'] ?? '',
      user_id: map['user_id']?.toInt() ?? 0,
      profile_id: map['profile_id']?.toInt() ?? 0,
      status: map['status'] ?? '',
      remarks: map['remarks'] ?? '',
      practitioner_id: map['practitioner_id']?.toInt() ?? 0,
    );
  }
  
  String toJson() => json.encode(toMap());
  factory Appointment.fromJson(String source) => Appointment.fromMap(json.decode(source));
  // Implement toString to make it easier to see information about each appointment when using the print statement.
  @override
  String toString() {
    return 'Appointment(appointment_id: $appointment_id, appointment_date: $appointment_date, user_id: $user_id, profile_id: $profile_id, status: $status, remarks: $remarks, practitioner_id: $practitioner_id)';
  }
}