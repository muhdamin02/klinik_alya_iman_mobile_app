// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

class PractitionerProfile {
  final int? practitioner_id;
  final String name;
  final String dob;
  final String? gender;
  final String branch;
  final String email;
  final String phone;
  final String specialization;
  final String qualifications;
  final String profile_pic;
  final String creation_date;
  final int? user_id;

  PractitionerProfile({
    this.practitioner_id,
    required this.name,
    required this.dob,
    required this.gender,
    required this.branch,
    required this.email,
    required this.phone,
    required this.specialization,
    required this.qualifications,
    required this.profile_pic,
    required this.creation_date,
    required this.user_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'practitioner_id': practitioner_id,
      'name': name,
      'dob': dob,
      'gender': gender,
      'branch': branch,
      'email': email,
      'phone': phone,
      'specialization': specialization,
      'qualifications': qualifications,
      'profile_pic': profile_pic,
      'creation_date': creation_date,
      'user_id': user_id,
    };
  }

  factory PractitionerProfile.fromMap(Map<String, dynamic> map) {
    return PractitionerProfile(
      practitioner_id: map['practitioner_id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      dob: map['dob'] ?? '',
      gender: map['gender'] ?? '',
      branch: map['branch'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      specialization: map['specialization'] ?? '',
      qualifications: map['qualifications'] ?? '',
      profile_pic: map['profile_pic'] ?? '',
      creation_date: map['creation_date'] ?? '',
      user_id: map['user_id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());
  factory PractitionerProfile.fromJson(String source) =>
      PractitionerProfile.fromMap(json.decode(source));
  // Implement toString to make it easier to see information about each profile when using the print statement.
  @override
  String toString() {
    return 'PractitionerProfile(practitioner_id: $practitioner_id, name: $name, dob: $dob, gender: $gender, branch: $branch, email: $email, phone: $phone, specialization: $specialization, qualifications: $qualifications, profile_pic: $profile_pic, creation_date: $creation_date, user_id: $user_id)';
  }
}
