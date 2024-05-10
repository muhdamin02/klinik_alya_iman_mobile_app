// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

class NewbornCare {
  final int? care_id;
  final int care_category;
  final String care_title;
  final String care_content;
  final String last_edited;

  NewbornCare({
    this.care_id,
    required this.care_category,
    required this.care_title,
    required this.care_content,
    required this.last_edited,
  });

  Map<String, dynamic> toMap() {
    return {
      'care_id': care_id,
      'care_category': care_category,
      'care_title': care_title,
      'care_content': care_content,
      'last_edited': last_edited,
    };
  }

  factory NewbornCare.fromMap(Map<String, dynamic> map) {
    return NewbornCare(
      care_id: map['care_id']?.toInt() ?? 0,
      care_category: map['care_category'] ?? 0,
      care_title: map['care_title'] ?? '',
      care_content: map['care_content'] ?? '',
      last_edited: map['last_edited'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());
  factory NewbornCare.fromJson(String source) =>
      NewbornCare.fromMap(json.decode(source));
  // Implement toString to make it easier to see information about each appointment when using the print statement.
  @override
  String toString() {
    return 'NewbornCare(care_id: $care_id, care_category: $care_category, care_title: $care_title, care_content: $care_content, last_edited: $last_edited)';
  }
}
