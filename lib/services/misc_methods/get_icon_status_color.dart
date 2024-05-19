import 'package:flutter/material.dart';

Color getIconColorForStatus(String status) {
  switch (status) {
    case 'Pending':
      return const Color(0xFFFFD271);
    case 'Confirmed':
      return const Color(0xFFFFD271);
    case 'Cancelled':
      return const Color(0xFFFFD271);
    case 'In Progress':
      return const Color(0xFFFFD271);
    case 'Assigned':
      return const Color(0xFFFFD271);
    case 'Attended':
      return const Color(0xFFEDF2FF);
    case 'Absent':
      return const Color(0xFFB6CBFF);
    default:
      return const Color(0xFFFFD271);
  }
}
