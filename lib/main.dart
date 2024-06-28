import 'package:chittchat/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'providers/user_provider.dart';

// Define your custom colors
const Color darkBlueColor = Color.fromARGB(255, 2, 7, 66); // Dark blue color
const Color purpleColor = Color.fromARGB(255, 32, 2, 35); // Purple color
const Color greyColor = Color(0xFF9E9E9E); // Grey color

final ColorScheme kColorScheme = ColorScheme.fromSeed(
  seedColor: darkBlueColor,
  primary: darkBlueColor,
  secondary: purpleColor,
);

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chitchat',
      theme: ThemeData(
        colorScheme: kColorScheme,
        scaffoldBackgroundColor: kColorScheme.surface,
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyLarge: TextStyle(color: kColorScheme.onSurface),
              bodyMedium: TextStyle(color: kColorScheme.onSurface),
            ),
        buttonTheme: ThemeData.light().buttonTheme.copyWith(
              buttonColor: kColorScheme.primary,
              shape: RoundedRectangleBorder(),
              textTheme: ButtonTextTheme.primary,
            ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[900], // Mixture of black and blue
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
