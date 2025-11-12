import 'package:flutter/material.dart';

class SmartCityProfileScreen extends StatefulWidget {
  const SmartCityProfileScreen({Key? key}) : super(key: key);

  @override
  State<SmartCityProfileScreen> createState() => _SmartCityProfileScreenState();
}

class _SmartCityProfileScreenState extends State<SmartCityProfileScreen> {
  bool isNotificationOn = true;

  final Color primaryBlue = const Color(0xFF2196F3);
  final Color accentGreen = const Color(0xFF4CAF50);
  final Color lightBackground = const Color(0xFFF8FAFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header section with gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryBlue, accentGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.white24,
                    child: Text(
                      "AK",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Ahmad Khalil",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  const Text(
                    "ahmad.khalil@email.com",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Profile Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildCard(
                    icon: Icons.person_outline,
                    title: "Personal Information",
                    onTap: () {},
                  ),
                  _buildCard(
                    icon: Icons.directions_car_rounded,
                    title: "Vehicle Details",
                    subtitle: "Plate: A12345",
                    onTap: () {},
                  ),
                  _buildCard(
                    icon: Icons.notifications_active_outlined,
                    title: "Notifications",
                    trailing: Switch(
                      value: isNotificationOn,
                      activeColor: accentGreen,
                      onChanged: (value) {
                        setState(() {
                          isNotificationOn = value;
                        });
                      },
                    ),
                  ),
                  _buildCard(
                    icon: Icons.language_outlined,
                    title: "Language",
                    onTap: () {},
                  ),
                  _buildCard(
                    icon: Icons.lock_outline,
                    title: "Privacy & Security",
                    onTap: () {},
                  ),
                  _buildCard(
                    icon: Icons.help_outline,
                    title: "Help Center",
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Logout button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.logout_rounded, color: Colors.white),
                label: const Text(
                  "Logout",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadowColor: Colors.redAccent.withOpacity(0.4),
                  elevation: 4,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [const Color(0xFF2196F3), const Color(0xFF4CAF50)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
          subtitle,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        )
            : null,
        trailing: trailing ??
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 16),
        onTap: onTap,
      ),
    );
  }
}
