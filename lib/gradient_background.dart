import 'package:flutter/material.dart';
import 'main.dart'; // Import kColorScheme for accessing colors

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary.withOpacity(1),
            Theme.of(context).colorScheme.primary,
          ],
        ),
      ),
      child: child,
    );
  }
}
