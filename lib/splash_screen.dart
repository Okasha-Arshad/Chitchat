import 'package:chittchat/user_list_screen.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'gradient_background.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/auth_services.dart';

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
            builder: (context) => UserListScreen(),
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
