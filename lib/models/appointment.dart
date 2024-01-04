// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

class Appointment {
  final int? appointment_id;
  final String appointment_date;
  final String appointment_time;
  final int user_id;
  final int? profile_id;
  final String status;
  final String system_remarks;
  final String patient_remarks;
  final String practitioner_remarks;
  final String random_id;

  Appointment({
    this.appointment_id,
    required this.appointment_date,
    required this.appointment_time,
    required this.user_id,
    required this.profile_id,
    required this.status,
    required this.system_remarks,
    required this.patient_remarks,
    required this.practitioner_remarks,
    required this.random_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'appointment_id': appointment_id,
      'appointment_date': appointment_date,
      'appointment_time': appointment_time,
      'user_id': user_id,
      'profile_id': profile_id,
      'status': status,
      'system_remarks': system_remarks,
      'patient_remarks': patient_remarks,
      'practitioner_remarks': practitioner_remarks,
      'random_id': random_id,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      appointment_id: map['appointment_id']?.toInt() ?? 0,
      appointment_date: map['appointment_date'] ?? '',
      appointment_time: map['appointment_time'] ?? '',
      user_id: map['user_id']?.toInt() ?? 0,
      profile_id: map['profile_id']?.toInt() ?? 0,
      status: map['status'] ?? '',
      system_remarks: map['system_remarks'] ?? '',
      patient_remarks: map['patient_remarks'] ?? '',
      practitioner_remarks: map['practitioner_remarks'] ?? '',
      random_id: map['random_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());
  factory Appointment.fromJson(String source) =>
      Appointment.fromMap(json.decode(source));
  // Implement toString to make it easier to see information about each appointment when using the print statement.
  @override
  String toString() {
    return 'Appointment(appointment_id: $appointment_id, appointment_date: $appointment_date, appointment_time: $appointment_time, user_id: $user_id, profile_id: $profile_id, status: $status, system_remarks: $system_remarks, patient_remarks: $patient_remarks, practitioner_remarks: $practitioner_remarks, random_id: $random_id)';
  }
}
