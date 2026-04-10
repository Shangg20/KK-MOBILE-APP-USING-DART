import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color brandDeepBlue = Color(0xFF1E3A8A);
    const Color brandGradientDark = Color(0xFF111827);

    return Scaffold(
      body: Stack(
        children: [
          /// 🔵 1. BACKGROUND (STRONGER BLUR)
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/kk_background.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ),

          /// 🔵 2. DARK OVERLAY (for readability like image)
          Container(
            color: const Color.fromRGBO(0, 0, 0, 0.3),
          ),

          /// 🔵 3. SMOOTHER BLUE WAVE
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: ExactWaveClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.65,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [brandDeepBlue, brandGradientDark],
                  ),
                ),
              ),
            ),
          ),

          /// 🔵 4. CONTENT
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 4),

                /// ✅ LOGO (FLOATING ABOVE WAVE)
                SizedBox(
                  width: 140,
                  height: 140,
                  child: Image.asset(
                    'assets/sk_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),

                const Spacer(flex: 2),

                /// ✅ TITLE
                const Text(
                  'KK PROFILING\nSYSTEM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.8,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 12),

                /// ✅ SUBTITLE
                const Text(
                  'SK DATA COLLECTION APP',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    letterSpacing: 2.5,
                  ),
                ),

                const Spacer(flex: 2),

                /// ✅ ROUNDED LOADING BAR (LIKE IMAGE)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 90),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: const LinearProgressIndicator(
                      minHeight: 6,
                      color: Colors.white,
                      backgroundColor: Colors.white24,
                    ),
                  ),
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 🌊 FIXED WAVE (SMOOTHER & MORE LIKE DESIGN)
class ExactWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Start slightly lower from left
    path.moveTo(0, size.height * 0.30);

    // First smooth dip
    path.cubicTo(
      size.width * 0.20, size.height * 0.05, // control point 1
      size.width * 0.40, size.height * 0.45, // control point 2
      size.width * 0.55, size.height * 0.35, // end point
    );

    // Second smooth rise (right side curve)
    path.cubicTo(
      size.width * 0.75, size.height * 0.25, // control point 1
      size.width * 0.90, size.height * 0.10, // control point 2
      size.width, size.height * 0.18,        // end point
    );

    // Close bottom
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}