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
            // 1. TOP HEADER SECTION
            Container(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/kk_background.png'),
                  fit: BoxFit.cover,
                  opacity: 0.3, // Light opacity to show the white background
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.menu, size: 30),
                      const Text(
                        "Kk Profiling",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const Icon(Icons.logout, size: 30),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Offline Mode Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.wifi_off),
                        const SizedBox(width: 10),
                        const Text("Offline Mode", style: TextStyle(fontWeight: FontWeight.w500)),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: brandBlue,
                            shape: StadiumBorder(),
                          ),
                          child: const Text("Go Online", style: TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // 2. SYNC WARNING BOX
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: warningRed,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red),
                            const SizedBox(width: 10),
                            const Text("3 record not synced to server"),
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

                  // 3. STATS CARDS
                  Row(
                    children: [
                      _buildStatCard("Total Collected", "5", brandBlue),
                      const SizedBox(width: 16),
                      _buildStatCard("Pending Sync", "3", Colors.red),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 4. COLLECT BUTTON (Big Blue Card)
                  GestureDetector(
                    onTap: () {
                      // Navigate to the Stepper form we discussed
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: brandBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.person_add, color: Colors.white, size: 50),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
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

                  // 5. DATA COLLECTION TIPS
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blue[100]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.lightbulb_outline),
                            SizedBox(width: 10),
                            Text("Data Collection Tips", style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text("• Verify Youth information accuracy"),
                        const Text("• Works Offline- syncs when online"),
                        const Text("• All data is securely stored"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 6. SYNC STATUS & ABOUT
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
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
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
          Text(subtitle, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}