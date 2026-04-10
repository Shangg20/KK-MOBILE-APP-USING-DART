import 'package:flutter/material.dart';
import 'home_screen.dart'; // Make sure this exists

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    // Standard color for input fields/buttons to match branding
    const Color brandBlue = Color(0xFF427AD1);

    return Scaffold(
      // Important to keep the background stable when keyboard appears
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // 1. FULL-SCREEN BACKGROUND IMAGE
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/kk_background.png'), // Your PH flag asset
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. CENTERED LOGIN FORM (The inner stack creates the layered effect)
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // 2A. THE DEEP BLUE FORM CARD (Positioned below the circle)
                  Container(
                    margin: const EdgeInsets.only(top: 55), // Space for the circle
                    padding: const EdgeInsets.fromLTRB(25, 60, 25, 40), // Top padding gives space inside for the label
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E3A8A), // Deep Blue Card color
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 5))
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Keep form compact
                      children: [
                        // Title Label
                        const Text(
                          "KK PERSONNEL LOGIN",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 35),

                        // Username Field (matching requested blue inputs)
                        _buildLabel("Username"),
                        _buildTextField(_usernameController, Icons.person, "Enter your username", false, brandBlue),
                        const SizedBox(height: 20),

                        // Password Field
                        _buildLabel("Password"),
                        _buildTextField(_passwordController, Icons.lock, "Enter your password", true, brandBlue),
                        
                        // "Authorized Personnel" text (centered below password)
                        const SizedBox(height: 10),
                        const Text(
                          "Authorized SK Personnel Only",
                          style: TextStyle(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w400),
                        ),
                        
                        const SizedBox(height: 40), // Space before login button

                        // THE LOGIN BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, // White button as requested
                              elevation: 3,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            child: const Text(
                              "LOGIN",
                              style: TextStyle(color: brandBlue, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 2B. THE WHITE LOGO CIRCLE (Layers *over* the form card using translate)
                  Transform.translate(
                    offset: const Offset(0, 0), // Lifts the circle halfway up over the card edge
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white, // Pure white background for cleaner look
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2), // Optional thin white outline
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 1, offset: Offset(0, 3))
                        ],
                      ),
                      padding: const EdgeInsets.all(15.0), // Padding so the SK logo doesn't touch the circle edges
                      child: Image.asset('assets/sk_logo.png', fit: BoxFit.contain), // Your SK logo asset
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- BUILD HELPER METHODS ---

  Widget _buildLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 8),
        child: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, IconData icon, String hint, bool isPassword, Color brandColor) {
    return Container(
      decoration: BoxDecoration(
        color: brandColor, // Using the standard requested blue for input backgrounds
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? _isObscured : false,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(icon, color: brandColor, size: 20),
            ),
          ),
          suffixIcon: isPassword ? IconButton(
            icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility, color: Colors.white70),
            onPressed: () => setState(() => _isObscured = !_isObscured),
          ) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  void _handleLogin() {
    // Simplified Mock Logic for testing
    if (_usernameController.text == "admin" && _passwordController.text == "sk2026") {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Credentials")),
      );
    }
  }
}