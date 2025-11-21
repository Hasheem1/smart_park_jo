import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../add_lot/addLotScreen.dart';
import '../owner_Earnings/ownerEarnings.dart';
import '../owner_profile/ownerProfile.dart';
import 'editParkingScreen.dart';
import '../manage_spots/manageSpotsS.dart';
import '../../ai_chat_bot/chatBot.dart';

class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Dashboard",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600)),
                        Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const ChatScreen()),
                                  );
                                },
                                child: const Text(
                                  "✨",
                                  style: TextStyle(fontSize: 25),
                                )),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const OwnerProfileScreen()),
                                );
                              },
                              child: const Icon(
                                size: 30,
                                Icons.person_outline,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Occupancy and Today cards
                    Row(
                      children: [
                        Expanded(
                          child: _smallInfoCard(
                              title: "Occupancy", value: "75%", subtitle: "60/80 spots"),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _smallInfoCard(
                              title: "Today", value: "450 JD", subtitle: "+12%", subtitleColor: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final added = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddParkingLotScreen(),
                        ),
                      );
                      if (added == true) {
                        (context as Element).reassemble();
                      }
                    },
                    child: _actionButton(Icons.add, "Add Lot"),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EarningsScreen()),
                      );
                    },
                    child: _actionButton(Icons.bar_chart_rounded, "Earnings"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text("My Lots", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('owners')
                    .doc(userEmail)
                    .collection('Owners Parking')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("No parking lots added yet.",
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  return Column(
                    children: docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return _lotCard(
                        context: context,
                        imageUrl: data['image_url'] ?? "",
                        title: data['Parking name'] ?? 'No Name',
                        occupied: "0/${data['Parking Capacity'] ?? '0'}",
                        today: "0 JD",
                        fullData: data,
                        parkingId: doc.id,
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---
  static Widget _smallInfoCard({
    required String title,
    required String value,
    required String subtitle,
    Color subtitleColor = Colors.white70,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(color: subtitleColor, fontSize: 14)),
        ],
      ),
    );
  }

  static Widget _actionButton(IconData icon, String label) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.black87),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  static Widget _lotCard({
    required BuildContext context,
    required String imageUrl,
    required String title,
    required String occupied,
    required String today,
    required Map<String, dynamic> fullData,
    required String parkingId,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: imageUrl.isNotEmpty
                ? Image.network(imageUrl, height: 150, width: double.infinity, fit: BoxFit.cover)
                : Container(height: 150, color: Colors.grey.shade300),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _infoText("Occupied", occupied),
                    _infoText("Today", today, color: Colors.green),
                  ],
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: 0.76,
                  color: const Color(0xFF1565C0),
                  backgroundColor: Colors.grey.shade200,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ManageSpotsScreen()),
                          );
                        },
                        child: const Text("Manage Spots",
                            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditParkingScreen(
                                  parkingData: fullData, parkingId: parkingId),
                            ),
                          );
                          if (updated == true) {
                            (context as Element).reassemble();
                          }
                        },
                        child: const Text("Edit Parking",
                            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _infoText(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54, fontSize: 13)),
        Text(value, style: TextStyle(fontWeight: FontWeight.w500, color: color ?? Colors.black)),
      ],
    );
  }
}
