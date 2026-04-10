import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SK Profiling Dashboard"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text("Profiles will appear here..."),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // We will point this to our 3-Step Form next!
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}