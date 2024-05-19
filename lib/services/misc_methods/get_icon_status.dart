import 'package:flutter/material.dart';

IconData getIconForStatus(String status) {
  switch (status) {
    case 'Pending':
      return Icons.hourglass_empty;
    case 'Confirmed':
      return Icons.check_circle_outline_rounded;
    case 'Cancelled':
      return Icons.cancel;
    case 'In Progress':
      return Icons.timelapse_rounded;
    case 'Assigned':
      return Icons.assignment_ind_outlined;
    case 'Attended':
      return Icons.event_available_rounded;
    case 'Absent':
      return Icons.event_busy_rounded;
    default:
      return Icons.help;
  }
}
