import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'db_helper.dart'; // Corrected path

class SyncService {
  // Replace with your actual local or hosted API URL
  static const String apiUrl = "http://192.168.1.100:8000/api/youth/sync"; 

  static Future<void> performAutoSync() async {
    final dbHelper = DBHelper();
    final unsyncedData = await dbHelper.getUnsyncedData();

    if (unsyncedData.isEmpty) return;

    for (var profile in unsyncedData) {
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(profile),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Success: Update local status to 1 (Synced)
          await dbHelper.markAsSynced(profile['id']);
        } else if (response.statusCode == 409) {
          // Conflict: API detected duplicate (Natural Key match)
          // We mark it as 1 so the app stops trying to sync a duplicate
          await dbHelper.markAsSynced(profile['id']);
          debugPrint("Duplicate entry handled for: ${profile['full_name']}");
        }
      } catch (e) {
        debugPrint("Sync error: $e");
        break; // Stop loop if server is down
      }
    }
  }
}