// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

class HomeFeed {
  final int? homefeed_id;
  final String category;
  final String title;
  final String body;
  final String datetime_posted;

  HomeFeed({
    this.homefeed_id,
    required this.category,
    required this.title,
    required this.body,
    required this.datetime_posted,
  });

  Map<String, dynamic> toMap() {
    return {
      'homefeed_id': homefeed_id,
      'category': category,
      'title': title,
      'body': body,
      'datetime_posted': datetime_posted,
    };
  }

  factory HomeFeed.fromMap(Map<String, dynamic> map) {
    return HomeFeed(
      homefeed_id: map['homefeed_id']?.toInt() ?? 0,
      category: map['category'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      datetime_posted: map['datetime_posted'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());
  factory HomeFeed.fromJson(String source) =>
      HomeFeed.fromMap(json.decode(source));
  // Implement toString to make it easier to see information about each appointment when using the print statement.
  @override
  String toString() {
    return 'HomeFeed(homefeed_id: $homefeed_id, category: $category, title: $title, body: $body, datetime_posted: $datetime_posted)';
  }
}
