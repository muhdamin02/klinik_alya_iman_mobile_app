import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateDisplay extends StatelessWidget {
  final String date;

  const DateDisplay({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime dateTime = DateTime.parse(date);
    final formattedDate = DateFormat.yMMMMd().format(dateTime);

    return Text(formattedDate);
  }

  String getStringDate() {
    final DateTime dateTime = DateTime.parse(date);
    return DateFormat.yMMMMd().format(dateTime);
  }
}
