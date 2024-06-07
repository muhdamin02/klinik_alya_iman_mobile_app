import 'package:flutter/material.dart';

Color getColorForMaternity(String button, String trimester, String element) {
  bool selected;
  if (button == trimester) {
    selected = true;
  } else {
    selected = false;
  }

  if (selected) {
    switch (element) {
      case 'outline':
        return const Color(0xFF5F4712);
      case 'texticon':
        return const Color(0xFF5F4712);
      case 'button':
        return const Color(0xFFFFD271);
      default:
        return const Color(0xFFFFD271);
    }
  } else {
    switch (element) {
      case 'outline':
        return const Color(0xFF6086f6);
      case 'texticon':
        return const Color(0xFF1F3299);
      case 'button':
        return const Color(0xFFC1D3FF);
      default:
        return const Color(0xFFC1D3FF);
    }
  }
}
