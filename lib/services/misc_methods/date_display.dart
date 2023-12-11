import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateDisplay extends StatelessWidget {
  final String date;

  const DateDisplay({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final DateTime dateTime = DateTime.parse(date);
    final formattedDate = DateFormat.yMMMMd().format(dateTime);

    return Text(formattedDate);
  }
}