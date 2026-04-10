import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/db_helper.dart';
import '../services/sync_service.dart';
import 'settings_screen.dart';
import 'add_profile_screen.dart';

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

    // LISTEN FOR CONNECTIVITY CHANGES
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      bool hasInternet = !results.contains(ConnectivityResult.none);
      if (mounted) {
        setState(() {
          isOnline = hasInternet;
        });
      }

      if (hasInternet) {
        // TRIGGER AUTO SYNC WHEN ONLINE
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
    const Color brandBlue = Color(0xFF3B82F6);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. ORIGINAL HEADER WITH MENU
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/kk_background.png'),
                  fit: BoxFit.cover,
                  opacity: 0.4,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "KK Profiling",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.more_vert, size: 28),
                          onSelected: (value) {
                            if (value == 'settings') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SettingsScreen()),
                              );
                            } else if (value == 'logout') {
                              _showLogoutDialog(context);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'settings',
                              child: Row(children: [Icon(Icons.settings, size: 20), SizedBox(width: 12), Text("Settings")]),
                            ),
                            const PopupMenuItem(
                              value: 'logout',
                              child: Row(children: [Icon(Icons.logout, color: Colors.redAccent, size: 20), SizedBox(width: 12), Text("Logout", style: TextStyle(color: Colors.redAccent))]),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // 2. INTEGRATED AUTOMATED STATUS BAR
                    _buildAutomatedStatusBar(),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // 3. STAT CARDS (UPDATED DYNAMICALLY)
                  Row(
                    children: [
                      _buildStatCard("Total Profiles", "5", brandBlue), // Update logic later
                      const SizedBox(width: 16),
                      _buildStatCard("Pending Sync", "$pendingCount", pendingCount > 0 ? Colors.orange : Colors.green),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 4. MAIN ACTION BUTTON
                  GestureDetector(
                    onTap: () {
                      // Navigate to 3-step form
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddProfileScreen()),
                        ).then((_) => _refreshPendingCount()); // Refresh count when coming back
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: brandBlue,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: brandBlue.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.person_add_alt_1, color: Colors.white, size: 45),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Collect Youth Profile", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              Text("Start house-to-house profiling", style: TextStyle(color: Colors.white70, fontSize: 13)),
                            ],
                          ),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),
                  
                  // 5. INFO SECTION
                  _buildSimpleInfoCard("Sync Status", isOnline ? "Cloud Connection Active" : "Local Storage Enabled", brandBlue.withValues(alpha: 0.1), hasBorder: true),
                  const SizedBox(height: 15),
                  _buildSimpleInfoCard("Current Locale", "Almeria, Biliran", Colors.grey.shade50, hasBorder: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildAutomatedStatusBar() {
    bool showSyncing = isOnline && pendingCount > 0;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: isOnline ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isOnline ? Colors.green.shade200 : Colors.orange.shade200),
      ),
      child: Row(
        children: [
          showSyncing 
            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.green))
            : Icon(isOnline ? Icons.cloud_done : Icons.cloud_off, size: 20, color: isOnline ? Colors.green : Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isOnline 
                ? (pendingCount > 0 ? "Uploading $pendingCount records..." : "All data is secured")
                : "Offline: $pendingCount records waiting for signal",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: isOnline ? Colors.green.shade900 : Colors.orange.shade900),
            ),
          ),
          if (isOnline && pendingCount == 0)
            const Icon(Icons.check_circle, color: Colors.green, size: 16),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Confirm logout? Any unsynced data will remain saved on this device."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(count, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleInfoCard(String title, String subtitle, Color bgColor, {bool hasBorder = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
        border: hasBorder ? Border.all(color: Colors.grey.shade300) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
        ],
      ),
    );
  }
}