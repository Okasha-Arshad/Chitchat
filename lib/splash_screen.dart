import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'gradient_background.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Simulate a delay using a Timer
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });

    return Scaffold(
      backgroundColor:
          Colors.transparent, // Make scaffold background transparent
      body: GradientBackground(
        child: Center(
          child: Text(
            'Chitchat',
            style: GoogleFonts.cormorant(
              textStyle: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
