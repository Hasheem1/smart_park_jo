import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_park_jo/garage_owner_path/owner_profile/profile_screen/businessInfo.dart';
import 'package:smart_park_jo/garage_owner_path/owner_profile/profile_screen/helpCenter.dart';
import 'package:smart_park_jo/garage_owner_path/owner_profile/profile_screen/paymentMethod.dart';
import 'package:smart_park_jo/garage_owner_path/owner_profile/profile_screen/privacy&security.dart';
import 'package:smart_park_jo/role_selection_screen/roleSelectionScreen.dart';

class OwnerProfileScreen extends StatefulWidget {
  const OwnerProfileScreen({super.key});

  @override
  State<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('owners');
  final String? userEmail = FirebaseAuth.instance.currentUser?.email;
  @override
  Widget build(BuildContext context) {
    final primaryGradient = const LinearGradient(
      colors: [Colors.grey, Color(0xFF36D1DC)],
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
                FutureBuilder<DocumentSnapshot>(
                  future: users.doc(userEmail).get(),
                  builder: (
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
                    String trimEmail = data['email'];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            // gradient: primaryGradient,
                            color: Color(0xFF2F66F5),
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
                                child: Text(trimEmail.substring(0,2).toUpperCase(),style: TextStyle(fontSize: 30,color: Color(0xFF2F66F5)),),
                                // backgroundImage: NetworkImage(
                                //   "https://www.pngall.com/wp-content/uploads/5/Profile-PNG-File.png",
                                // ),
                              ),
                              const SizedBox(width: 18),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Text(
                                    data['name'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    data['email'],
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

                _buildGlassTile(
                  icon: Icons.person_2_outlined,
                  title: "Parking Owner Information",
                  subtitle: "Update Parking Owner details",
                  color: const Color(0xFF2F66F5),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BusinessInfoScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 15),
                // _buildGlassTile(
                //   icon: Icons.credit_card,
                //   title: "Payment info",
                //   subtitle: "Update Payment info",
                //   color: const Color(0xFF2F66F5),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (_) => const AddPaymentMethodScreen(),
                //       ),
                //     );
                //   },
                // ),
                // const SizedBox(height: 15),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // _buildGlassTile(
                //   icon: Icons.language_outlined,
                //   title: "Language",
                //   subtitle: "English",
                //   color: const Color(0xFF2F66F5),
                // ),
                // const SizedBox(height: 12),
                _buildGlassTile(
                  icon: Icons.lock_outline,
                  title: "Privacy & Security",
                  subtitle: "الخصوصية والأمان",
                  color: const Color(0xFF2F66F5),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PrivacySecurityScreen(),
                      ),
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
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildGlassTile(
                  icon: Icons.help_outline,
                  title: "Help Center",
                  subtitle: "مركز المساعدة",
                  color: const Color(0xFF2F66F5),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HelpCenterScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      logout();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        // gradient: primaryGradient,
                        color: Color(0xFF2F66F5),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
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
                            color: Colors.white,
                          ),
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
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
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
            leading: Icon(icon, color: const Color(0xFF2F66F5)),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(subtitle),
            trailing: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: activeColor ?? const Color(0xFF2F66F5),
            ),
          ),
        ),
      ),
    );
  }

  void logout() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RoleSelectionScreen()),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.red[400],
            title: Text(
              "Log out of your account",
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              "Are you sure you want to log out?",
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RoleSelectionScreen(),
                    ),
                  );
                },
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    }
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
