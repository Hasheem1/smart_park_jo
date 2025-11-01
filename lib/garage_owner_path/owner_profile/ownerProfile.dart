import 'package:flutter/material.dart';

class OwnerProfileScreen extends StatelessWidget {
  const OwnerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: _NoGlowScrollBehavior(), // 👈 removes scrollbar & glow
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🟩 Profile Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFF43A047),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white24,
                          child: Text(
                            "MJ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Mohammad Jamal",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "mohammad.j@email.com",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🧾 Business Info
                  _buildProfileTile(
                    icon: Icons.store_mall_directory_outlined,
                    title: "Business Information",
                    subtitle: "Update business details",
                  ),

                  const SizedBox(height: 10),

                  // 💳 Payment Methods
                  _buildProfileTile(
                    icon: Icons.payment_outlined,
                    title: "Payment Methods",
                    subtitle: "Manage payout accounts",
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Settings",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  // 🔔 Notifications
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.notifications_none,
                          color: Colors.purpleAccent),
                      title: const Text("Notifications"),
                      subtitle: const Text("إشعارات"),
                      trailing: Switch(
                        value: false,
                        onChanged: (value) {},
                        activeColor: Colors.green,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 🌐 Language
                  _buildProfileTile(
                    icon: Icons.language_outlined,
                    title: "Language",
                    subtitle: "English",
                  ),

                  const SizedBox(height: 10),

                  // 🔒 Privacy & Security
                  _buildProfileTile(
                    icon: Icons.lock_outline,
                    title: "Privacy & Security",
                    subtitle: "الخصوصية والأمان",
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Support",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  // 🆘 Help Center
                  _buildProfileTile(
                    icon: Icons.help_outline,
                    title: "Help Center",
                    subtitle: "مركز المساعدة",
                  ),

                  const SizedBox(height: 30),

                  // 🚪 Log Out Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Logged out successfully")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Log Out",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),


                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Reusable Info Tile Widget
  static Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle),
        onTap: () {},
      ),
    );
  }
}

// 🚫 Custom Scroll Behavior (removes scroll glow + scrollbar)
class _NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}
