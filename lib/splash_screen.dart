import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'gradient_background.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/auth_services.dart';
import 'chat_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check login state
    Future.delayed(Duration(seconds: 3), () async {
      AuthService authService = AuthService();
      var loginState = await authService.getLoginState();
      if (loginState != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              userId: loginState['userId']!,
              recipientId: loginState['recipientId']!,
            ),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
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
