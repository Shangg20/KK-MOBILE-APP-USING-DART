import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/db_helper.dart';
import '../services/sync_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool isOnline = true;
  int pendingCount = 0;

  @override
  void initState() {
    super.initState();
    _refreshPendingCount();
    
    // START THE AUTO-WATCHER
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      bool hasInternet = !results.contains(ConnectivityResult.none);
      
      setState(() {
        isOnline = hasInternet;
      });

      if (hasInternet) {
        // TRIGGER AUTO SYNC
        SyncService.performAutoSync().then((_) => _refreshPendingCount());
      }
    });
  }

  Future<void> _refreshPendingCount() async {
    final data = await DBHelper().getUnsyncedData();
    if (mounted) {
      setState(() {
        pendingCount = data.length;
      });
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("KK Profiling Dashboard")),
      body: Column(
        children: [
          // AUTOMATED STATUS BAR (NO BUTTON NEEDED)
          _buildStatusBar(),
          
          Expanded(
            child: Center(
              child: Text("Display stats or list here"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBar() {
    Color barColor = isOnline ? Colors.green.shade100 : Colors.orange.shade100;
    String message = isOnline 
      ? (pendingCount > 0 ? "Syncing $pendingCount records..." : "All data synced")
      : "Offline: $pendingCount records pending sync";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: barColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(isOnline ? Icons.sync : Icons.sync_disabled, size: 18),
          const SizedBox(width: 10),
          Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}