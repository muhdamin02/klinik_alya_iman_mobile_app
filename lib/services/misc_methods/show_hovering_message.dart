import 'package:flutter/material.dart';

void showHoveringMessage(BuildContext context, String message, double top,
    double left, double width) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top:
          MediaQuery.of(context).size.height * top, // Adjust position as needed
      left: MediaQuery.of(context).size.width * left,
      width: MediaQuery.of(context).size.width * width,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  // Remove the overlay entry after 2 seconds
  Future.delayed(const Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}
