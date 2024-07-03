import 'package:flutter/material.dart';
import 'package:chittchat/screens/login_screen.dart';
import 'package:chittchat/screens/signup_screen.dart';
import '../widgets/gradient_background.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 2, 7, 66),
        elevation: 0, // remove the shadow
      ),
      body: GradientBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Connect friends easily & quickly',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 80,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Our chat app is the perfect way to stay connected with friends and family.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 150),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpScreen(),
                      ),
                    );
                    // Handle sign up with email
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 109,
                      vertical: 15,
                    ),
                  ),
                  child: const Text(
                    'Sign up with email',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(title: 'Hello'),
                      ),
                    );
                    // Handle log in
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Existing account? Log in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
