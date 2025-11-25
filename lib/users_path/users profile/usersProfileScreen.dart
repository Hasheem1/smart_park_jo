import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_park_jo/garage_owner_path/owner_profile/profile_screen/helpCenter.dart';
import 'package:smart_park_jo/garage_owner_path/owner_profile/profile_screen/privacy&security.dart';

import '../../garage_owner_path/owner_profile/profile_screen/paymentMethod.dart';
import 'info/userDetails.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final String? userEmail = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    final primaryGradient = const LinearGradient(
      colors: [Color(0xFF36D1DC),Color(0xFF5B86E5)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,


    );
    // final List<Color> appGradientColors = [
    //   Color(0xFF0F2027),
    //   Color(0xFF203A43),
    //   Color(0xFF2C5364),
    //   Color(0xFF36D1DC),
    //   Color(0xFF5B86E5),
    // ];
    return Scaffold(
      backgroundColor:    Colors.white70  ,


      body: SafeArea(
        child: ScrollConfiguration(
          behavior: _NoGlowScrollBehavior(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ✨ Blue Glassmorphic Profile Header
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .get(),                  builder: (
                      BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot,
                      ) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          "Something went wrong",
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.orange),
                      );
                    }

                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const Center(
                        child: Text(
                          "No data found",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      );
                      // );
                    }

                    Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                    String trimEmail = data['phone number'].toString();
                    return ClipRRect(
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
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(backgroundColor: Colors.white,
                                radius: 30,
                                child: Text(trimEmail.substring(0,2).toUpperCase(),style: TextStyle(fontSize: 30,color: Color(0xFF4A90FF)),),

                              ),
                              const SizedBox(width: 18),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "+962 ${data['phone number'].toString()}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 4),
                                  Text(
                                    data['password'].toString(),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 25),

                // 🏢 Business Info + Payment Methods
                _buildGlassTile(
                  icon: Icons.person_2_outlined,
                  title: "Personal Information",
                  subtitle: "Update business details",
                  color: const Color(0xFF36D1DC),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const Userdetails()),
                    );
                  },
                ),
                const SizedBox(height: 15),

                _buildGlassTile(
                  icon: Icons.credit_card,
                  title: "Payment info",
                  subtitle: "Update Payment info",
                  color: const Color(0xFF36D1DC),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddPaymentMethodScreen(),
                      ),
                    );
                  },
                ),
                // const SizedBox(height: 15),
                // _buildGlassTile(
                //   icon: Icons.car_rental,
                //   title: "Vehicle Details",
                //   subtitle: "Plate: 22-27366",
                //   color: const Color(0xFF36D1DC),
                //
                // ),
                const SizedBox(height: 25),

                // ⚙️ Settings Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Settings",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                // const SizedBox(height: 15),
                //
                // _buildGlassSwitch(
                //   icon: Icons.notifications_none,
                //   title: "Notifications",
                //   subtitle: "إشعارات",
                //   value: true,
                //   onChanged: (v) {},
                //   activeColor: const Color(0xFF36D1DC),
                // ),
                const SizedBox(height: 12),
                // _buildGlassTile(
                //   icon: Icons.language_outlined,
                //   title: "Language",
                //   subtitle: "English",
                //   color: const Color(0xFF2F66F5),
                // ),
                const SizedBox(height: 12),
                _buildGlassTile(
                  icon: Icons.lock_outline,
                  title: "Privacy & Security",
                  subtitle: "الخصوصية والأمان",
                  color: const Color(0xFF36D1DC),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PrivacySecurityScreen()),
                    );
                  },
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
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),
                _buildGlassTile(
                  icon: Icons.help_outline,
                  title: "Help Center",
                  subtitle: "مركز المساعدة",
                  color: const Color(0xFF36D1DC),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HelpCenterScreen()),
                    );
                  },
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
    VoidCallback? onTap, // 👈 added optional onTap
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
            onTap: onTap, // 👈 call custom onTap action
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
            leading: Icon(icon, color: const Color(0xFF36D1DC)),
            title: Text(title,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(subtitle),
            trailing: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: activeColor ?? const Color(0xFF36D1DC),
            ),
          ),
        ),
      ),
    );
  }
}


class _NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context,
      Widget child,
      ScrollableDetails details,
      ) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}

