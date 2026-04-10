import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "App Configuration", 
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)
            ),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("Sync History"),
            subtitle: const Text("Logs of previous data uploads"),
            onTap: () {
              // Future functionality for your thesis data tracking
            },
          ),
          ListTile(
            leading: const Icon(Icons.storage_outlined),
            title: const Text("Clear Local Cache"),
            subtitle: const Text("Wipe data already synced to server"),
            onTap: () {
              // Future logic to clear sqflite tables
            },
          ),
          const Divider(),
          const AboutListTile(
            icon: Icon(Icons.info_outline),
            applicationName: "KK Profiling System",
            applicationVersion: "1.0.0",
            applicationLegalese: "© 2026 Almeria Biliran SK",
            child: Text("This app is for official profiling use only."),
          ),
        ],
      ),
    );
  }
}