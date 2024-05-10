// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

class Postpartum {
  final int? postpartum_id;
  final int postpartum_category;
  final String postpartum_title;
  final String postpartum_content;
  final String last_edited;

  Postpartum({
    this.postpartum_id,
    required this.postpartum_category,
    required this.postpartum_title,
    required this.postpartum_content,
    required this.last_edited,
  });

  Map<String, dynamic> toMap() {
    return {
      'postpartum_id': postpartum_id,
      'postpartum_category': postpartum_category,
      'postpartum_title': postpartum_title,
      'postpartum_content': postpartum_content,
      'last_edited': last_edited,
    };
  }

  factory Postpartum.fromMap(Map<String, dynamic> map) {
    return Postpartum(
      postpartum_id: map['postpartum_id']?.toInt() ?? 0,
      postpartum_category: map['postpartum_category'] ?? 0,
      postpartum_title: map['postpartum_title'] ?? '',
      postpartum_content: map['postpartum_content'] ?? '',
      last_edited: map['last_edited'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());
  factory Postpartum.fromJson(String source) =>
      Postpartum.fromMap(json.decode(source));
  // Implement toString to make it easier to see information about each appointment when using the print statement.
  @override
  String toString() {
    return 'Postpartum(postpartum_id: $postpartum_id, postpartum_category: $postpartum_category, postpartum_title: $postpartum_title, postpartum_content: $postpartum_content, last_edited: $last_edited)';
  }
}
