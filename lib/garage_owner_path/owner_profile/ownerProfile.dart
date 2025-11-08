import 'dart:ui';
import 'package:flutter/material.dart';

class OwnerProfileScreen extends StatelessWidget {
  const OwnerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryGradient = const LinearGradient(
      colors: [Color(0xFF2F66F5), Color(0xFF4A90FF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: _NoGlowScrollBehavior(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ✨ Blue Glassmorphic Profile Header
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: primaryGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 6))
                        ],
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.white24,
                            child: Text(
                              "MJ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 18),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Mohammad Jamal",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "mohammad.j@email.com",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // 🏢 Business Info + Payment Methods
                _buildGlassTile(
                  icon: Icons.store_mall_directory_outlined,
                  title: "Business Information",
                  subtitle: "Update business details",
                  color: const Color(0xFF2F66F5),
                ),
                const SizedBox(height: 15),
                _buildGlassTile(
                  icon: Icons.payment_outlined,
                  title: "Payment Methods",
                  subtitle: "Manage payout accounts",
                  color: const Color(0xFF2F66F5),
                ),
                const SizedBox(height: 25),

                // ⚙️ Settings Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Settings",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800),
                  ),
                ),
                const SizedBox(height: 15),

                _buildGlassSwitch(
                  icon: Icons.notifications_none,
                  title: "Notifications",
                  subtitle: "إشعارات",
                  value: true,
                  onChanged: (v) {},
                  activeColor: const Color(0xFF2F66F5),
                ),
                const SizedBox(height: 12),
                _buildGlassTile(
                  icon: Icons.language_outlined,
                  title: "Language",
                  subtitle: "English",
                  color: const Color(0xFF2F66F5),
                ),
                const SizedBox(height: 12),
                _buildGlassTile(
                  icon: Icons.lock_outline,
                  title: "Privacy & Security",
                  subtitle: "الخصوصية والأمان",
                  color: const Color(0xFF2F66F5),
                ),
                const SizedBox(height: 25),

                // 🆘 Support Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Support",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800),
                  ),
                ),
                const SizedBox(height: 12),
                _buildGlassTile(
                  icon: Icons.help_outline,
                  title: "Help Center",
                  subtitle: "مركز المساعدة",
                  color: const Color(0xFF2F66F5),
                ),

                const SizedBox(height: 35),

                // 🚪 Log Out Button with gradient
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Logged out successfully"),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 6))
                        ],
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        height: 56,
                        child: const Text(
                          "Log Out",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Modern Glassmorphic Info Tile
  Widget _buildGlassTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.75),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: ListTile(
            leading: Icon(icon, color: color),
            title: Text(title,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(subtitle),
            trailing: const Icon(Icons.arrow_forward_ios, size: 18),
            onTap: () {},
          ),
        ),
      ),
    );
  }

  // 🔹 Glassmorphic Tile with Switch
  Widget _buildGlassSwitch({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    Color? activeColor,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.75),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: ListTile(
            leading: Icon(icon, color: const Color(0xFF2F66F5)),
            title: Text(title,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(subtitle),
            trailing: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: activeColor ?? const Color(0xFF2F66F5),
            ),
          ),
        ),
      ),
    );
  }
}

// 🚫 Removes scroll glow
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
