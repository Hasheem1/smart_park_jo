// ✅ FINAL MODERNIZED UI VERSION OF OwnerDashboardScreen
// You chose to use NEW FIREBASE FIELD NAMES:
// Parking Image / Parking name / Parking Capacity / Occupied Spots / Today Earnings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../add_lot/addLotScreen.dart';
import '../owner_Earnings/ownerEarnings.dart';
import '../owner_profile/ownerProfile.dart';
import 'editParkingScreen.dart';
import '../manage_spots/manageSpotsS.dart';
import '../../ai_chat_bot/chatBot.dart';

class OwnerDashboardScreen extends StatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email;

    return Scaffold(
      backgroundColor:  Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _modernHeader(context),
              const SizedBox(height: 18),
              _modernStats(userEmail),
              const SizedBox(height: 25),
              _modernActions(context),
              const SizedBox(height: 25),

              const Text(
                "My Parking Lots",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),

              _modernLotsList(context, userEmail),
            ],
          ),
        ),
      ),
    );
  }

  // -----------------------------------------------------------
  Widget _modernHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Owner Dashboard",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.smart_toy_outlined, color: Colors.white),
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ChatScreen()),
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.account_circle, color: Colors.white),
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OwnerProfileScreen(),
                      ),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------
  Widget _modernStats(String? userEmail) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('owners')
          .doc(userEmail)
          .collection('Owners Parking')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(height: 80);
        }

        int totalCapacity = 0;
        int totalOccupied = 0;

        for (var doc in snapshot.data!.docs) {
          final data = doc.data() as Map<String, dynamic>;

          totalCapacity +=
              int.tryParse(data['Parking Capacity']?.toString() ?? '0') ?? 0;
          totalOccupied +=
              int.tryParse(data['Occupied Spots']?.toString() ?? '0') ?? 0;
        }

        return Row(
          children: [
            _statCard(
              "Parking's Number",

            snapshot.data!.docs.length.toString(),
              Icons.local_parking,
            ),
            const SizedBox(width: 12),
            _statCard(
              "Active Lots",
              totalCapacity.toString(),
              Icons.layers,
            ),
          ],
        );
      },
    );
  }

  Widget _statCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // color: Colors.white,
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade50.withOpacity(0.5),
              Colors.blue.shade100.withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF2C5364)),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }


  // -----------------------------------------------------------
  Widget _modernActions(BuildContext context) {
    return Row(
      children: [
        _actionCard(
          context,
          "Add Lot",
          Icons.add_circle,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddParkingLotScreen()),
          ),
        ),
        const SizedBox(width: 15),
        _actionCard(
          context,
          "Earnings",
          Icons.payments,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EarningsScreen()),
          ),
        ),

      ],
    );
  }

  Widget _actionCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 22),
          decoration: BoxDecoration(
            // gradient: const LinearGradient(
            //   colors: [Colors.grey, Color(0xFF36D1DC)],
            // ),
            color: Color(0xFF2F66F5),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 30),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -----------------------------------------------------------
  Widget _modernLotsList(BuildContext context, String? userEmail) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('owners')
              .doc(userEmail)
              .collection('Owners Parking')
              .snapshots(), // 👈 REAL-TIME STREAM
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
                "No parking lots added yet.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          );
        }

        final docs = snapshot.data!.docs;

        return Column(
          children:
              docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return _lotCard(
                  context: context,
                  data: data,
                  parkingId: doc.id,
                  userEmail: userEmail,
                );
              }).toList(),
        );
      },
    );
  }

  Widget _lotCard({
    required BuildContext context,
    required Map<String, dynamic> data,
    required String parkingId,
    required String? userEmail, // add this
  }) {
    final imageUrl = data['image_url'] ?? "";
    final List spots = data['spots'] ?? [];

    final int occupiedCount = spots
        .where((spot) => spot['status'] == 'Occupied')
        .length;

    final capacity =
        "$occupiedCount/${data['Parking Capacity'] ?? spots.length}";


    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade50.withOpacity(0.5),
            Colors.blue.shade100.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Circular Image with subtle shadow
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child:
                  imageUrl.isNotEmpty
                      ? Image.network(
                        imageUrl,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      )
                      : Container(
                        width: 70,
                        height: 70,
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 32,
                          color: Colors.grey,
                        ),
                      ),
            ),
          ),
          const SizedBox(width: 16),

          // Info Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data['Parking name'] ?? "Unnamed Parking",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('AllRatings')
                          .doc(data['Parking name']) // use parking name as doc id
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return const Text("N/A");
                        }

                        final ratingData = snapshot.data!.data() as Map<String, dynamic>;
                        final double averageRating = (ratingData['averageRating'] ?? 0).toDouble();

                        return Text(
                          "${averageRating.toStringAsFixed(0)} ⭐", // e.g., "4.5 ⭐"
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "Capacity: $capacity",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),

                // Buttons Row
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2F66F5),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          textStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => EditParkingScreen(
                                      parkingData: data,
                                      parkingId: parkingId,
                                    ),
                              ),
                            ),
                        child: const Text("Edit"),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2F66F5),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          textStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ManageSpotsScreen(
                                      parkingId: parkingId,
                                      parkingData: data,
                                    ),
                              ),
                            ),

                        child: const Text("Manage"),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2F66F5),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          textStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () async {
                          // Show confirmation dialog
                          final confirm = await showDialog(
                            context: context,
                            builder: (ctx) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 5,
                              backgroundColor: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Icon on top
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        // gradient: LinearGradient(
                                        //   colors: [Colors.grey,Color(0xFF36D1DC),],
                                        // ),
                                        color: Color(0xFF2F66F5)
                                      ),
                                      child: const Icon(
                                        Icons.delete_forever,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    const Text(
                                      "Confirm Delete",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      "Are you sure you want to delete this parking lot?",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () => Navigator.of(ctx).pop(false),
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(color: Colors.grey.shade300),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              padding: const EdgeInsets.symmetric(vertical: 14),
                                            ),
                                            child: const Text(
                                              "Cancel",
                                              style: TextStyle(color: Colors.black87, fontSize: 16),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () => Navigator.of(ctx).pop(true),
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(vertical: 14),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              backgroundColor: Colors.redAccent,
                                              elevation: 0,
                                            ),
                                            child: const Text(
                                              "Delete",
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white70),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );


                          if (confirm != null && confirm) {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('owners')
                                  .doc(
                                    userEmail,
                                  ) // Make sure userEmail is passed to _lotCard
                                  .collection('Owners Parking')
                                  .doc(parkingId)
                                  .delete();

                              // Optional: Show success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: const Color(0xFF4CAF50), // modern green
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                  elevation: 10,
                                  duration: const Duration(seconds: 3),
                                  content: Row(
                                    children: const [
                                      Icon(Icons.check_circle, color: Colors.white),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          "Parking lot deleted successfully!",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );


                              // Refresh UI
                              setState(() {});
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Failed to delete: $e")),
                              );
                            }
                          }
                        },

                        child: const Text("Delete"),
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
}
