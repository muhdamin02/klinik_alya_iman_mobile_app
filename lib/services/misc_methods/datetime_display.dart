import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeDisplay extends StatelessWidget {
  final String datetime;

  const DateTimeDisplay({Key? key, required this.datetime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime dateTime = DateTime.parse(datetime);
    // Format the date and time
    final formattedDate = DateFormat('MMM d yyyy, h:mm a').format(dateTime);

    return Text(formattedDate);
  }

  String getStringDate() {
    final DateTime dateTime = DateTime.parse(datetime);
    return DateFormat('MMM d, yyyy').format(dateTime);
  }

  String getStringTime() {
    final DateTime dateTime = DateTime.parse(datetime);
    return DateFormat('h:mm a').format(dateTime);
  }
}
