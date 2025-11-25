import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AvailableSpotsScreen extends StatelessWidget {
  final String parkingId;

  const AvailableSpotsScreen({super.key, required this.parkingId});

  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser!.email;
    final firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Available Spot"),
        backgroundColor: const Color(0xFF1565C0),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: firestore
            .collection('owners')
            .doc(userEmail)
            .collection('Owners Parking')
            .doc(parkingId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final List spots = data['spots'] ?? [];

          final availableSpots = spots
              .where((spot) => spot['status'] == 'Available')
              .toList();

          if (availableSpots.isEmpty) {
            return const Center(
              child: Text("No available spots 😔"),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: availableSpots.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.3,
            ),
            itemBuilder: (context, index) {
              final spot = availableSpots[index];

              return GestureDetector(
                onTap: () {
                  _selectSpot(context, spot['id']);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green.shade400,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      spot['id'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _selectSpot(BuildContext context, String spotId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Spot"),
        content: Text("Do you want to choose spot $spotId ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Spot $spotId selected ✅")),
              );

              // Later we can convert this to REAL RESERVATION
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }
}
