// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

class Contraction {
  final int? contraction_id;
  final int contraction_duration;
  final int contraction_rating;
  final String contraction_datetime;
  final int user_id;
  final int? profile_id;
  
  Contraction({
    this.contraction_id,
    required this.contraction_duration,
    required this.contraction_rating,
    required this.contraction_datetime,
    required this.user_id,
    required this.profile_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'contraction_id': contraction_id,
      'contraction_duration': contraction_duration,
      'contraction_rating': contraction_rating,
      'contraction_datetime': contraction_datetime,
      'user_id': user_id,
      'profile_id': profile_id,
    };
  }

  factory Contraction.fromMap(Map<String, dynamic> map) {
    return Contraction(
      contraction_id: map['contraction_id']?.toInt() ?? 0,
      contraction_duration: map['contraction_duration'] ?? 0,
      contraction_rating: map['contraction_rating'] ?? 0,
      contraction_datetime: map['contraction_datetime'] ?? '',
      user_id: map['user_id']?.toInt() ?? 0,
      profile_id: map['profile_id']?.toInt() ?? 0,
    );
  }
  
  String toJson() => json.encode(toMap());
  factory Contraction.fromJson(String source) => Contraction.fromMap(json.decode(source));
  // Implement toString to make it easier to see information about each appointment when using the print statement.
  @override
  String toString() {
    return 'Contraction(contraction_id: $contraction_id, contraction_duration: $contraction_duration, contraction_rating: $contraction_rating, contraction_datetime: $contraction_datetime, user_id: $user_id, profile_id: $profile_id)';
  }
}