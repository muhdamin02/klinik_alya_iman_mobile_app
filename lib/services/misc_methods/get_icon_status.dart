import 'package:flutter/material.dart';

IconData getIconForStatus(String status) {
  if (status == 'Pending') {
    return Icons.hourglass_empty;
  } else if (status == 'Confirmed') {
    return Icons.check_circle_outline_rounded;
  } else if (status == 'Cancelled') {
    return Icons.cancel;
  } else if (status == 'In Progress') {
    return Icons.timelapse;
  } else if (status == 'Assigned') {
    return Icons.assignment_ind_outlined;
  } else {
    return Icons.help; // Default icon for unknown statuses
  }
}
