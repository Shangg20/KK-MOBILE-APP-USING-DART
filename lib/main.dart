import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const KKProfilingApp());
}

class KKProfilingApp extends StatelessWidget {
  const KKProfilingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KK Profiling System',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      // The app starts here
      home: const SplashScreen(),
    );
  }
}