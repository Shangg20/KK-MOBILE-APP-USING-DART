import 'package:flutter/material.dart';
import 'screens/splash_screen.dart'; // Ensure this import exists
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart'; // Good to add this here too

void main() {
  runApp(const KKProfilingApp());
}

class KKProfilingApp extends StatelessWidget {
  const KKProfilingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KK Profiling System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // 1. CHANGE THIS: Set the start point back to the splash screen
      initialRoute: '/', 
      
      // 2. UPDATE ROUTES: Map the screens to names
      routes: {
        '/': (context) => const SplashScreen(), // Often '/' is used for splash
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}