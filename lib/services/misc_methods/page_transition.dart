import 'package:flutter/material.dart';

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Define the duration of the fade transition
    const Duration duration = Duration(milliseconds: 50); // Adjust the duration as needed

    // Create a Tween with the defined duration
    var tween = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ),
    );

    // Use the Tween to control the opacity of the child widget
    return FadeTransition(
      opacity: tween,
      child: child,
    );
  }
}
