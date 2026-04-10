import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Colors from your design
    const Color brandBlue = Color(0xFF3B82F6);
    const Color warningRed = Color(0xFFFEE2E2);
    const Color statusTeal = Color(0xFFCCFBF1);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. UPDATED HEADER SECTION (Tightened coverage & No Menu Icon)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/kk_background.png'),
                  fit: BoxFit.cover,
                  opacity: 0.2, 
                ),
              ),
              child: SafeArea( // Ensures content stays below the status bar
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
                        IconButton(
                          icon: const Icon(Icons.exit_to_app, size: 28),
                          onPressed: () {
                            // Using pushReplacement to go back to login
                            Navigator.pushReplacementNamed(context, '/login_screen');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    
                    // 2. OFFLINE MODE BAR
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.wifi_off, size: 20, color: Colors.grey),
                          const SizedBox(width: 10),
                          const Text(
                            "Offline Mode", 
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)
                          ),
                          const Spacer(),
                          SizedBox(
                            height: 35,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: brandBlue,
                                shape: const StadiumBorder(),
                                elevation: 0,
                              ),
                              child: const Text(
                                "Go Online", 
                                style: TextStyle(color: Colors.white, fontSize: 12)
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // 3. SYNC WARNING BOX
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: warningRed,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red),
                            SizedBox(width: 10),
                            Text("3 record not synced to server"),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.sync, color: Colors.white),
                          label: const Text("Sync Now", style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(backgroundColor: brandBlue),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 4. STATS CARDS
                  Row(
                    children: [
                      _buildStatCard("Total Collected", "5", brandBlue),
                      const SizedBox(width: 16),
                      _buildStatCard("Pending Sync", "3", Colors.red),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 5. COLLECT BUTTON (Big Blue Card)
                  GestureDetector(
                    onTap: () {
                      // Logic to open your 3-step profiling form
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: brandBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.person_add, color: Colors.white, size: 50),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Collect Youth Profile", 
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              Text("Gather youth information", 
                                style: TextStyle(color: Colors.white70)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 6. DATA COLLECTION TIPS
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blue[100]!),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lightbulb_outline),
                            SizedBox(width: 10),
                            Text("Data Collection Tips", style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text("• Verify Youth information accuracy"),
                        Text("• Works Offline- syncs when online"),
                        Text("• All data is securely stored"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 7. SYNC STATUS & ABOUT
                  _buildSimpleInfoCard("Sync Status", "3 record waiting to sync", statusTeal),
                  const SizedBox(height: 16),
                  _buildSimpleInfoCard("About This App", 
                    "Mobile data collection tool for SK Youth Profiling System.", Colors.white, 
                    hasBorder: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for Stats
  Widget _buildStatCard(String title, String count, Color countColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text(count, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: countColor)),
          ],
        ),
      ),
    );
  }

  // Helper widget for Simple Cards
  Widget _buildSimpleInfoCard(String title, String subtitle, Color bgColor, {bool hasBorder = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
        border: hasBorder ? Border.all(color: Colors.black26) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
          const SizedBox(height: 5),
          Center(child: Text(subtitle, textAlign: TextAlign.center)),
        ],
      ),
    );
  }
}