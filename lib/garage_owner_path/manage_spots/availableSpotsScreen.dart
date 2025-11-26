import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AvailableSpotsScreen extends StatefulWidget {
  final String parkingId;
  final String owneremail;


  const AvailableSpotsScreen({super.key, required this.parkingId,required this.owneremail
  });

  @override
  State<AvailableSpotsScreen> createState() => _AvailableSpotsScreenState();
}

class _AvailableSpotsScreenState extends State<AvailableSpotsScreen> {

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    String? selectedSpotId;


    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Available Spot"),
        backgroundColor: const Color(0xFF1565C0),
      ),
      body: Column(
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: firestore
                .collection('owners')
                .doc(widget.owneremail)
                .collection('Owners Parking')
                .doc(widget.parkingId)
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

              return DropdownButtonFormField<String>(
                value: selectedSpotId,
                hint: const Text("Select a parking spot"),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.green.shade50,
                ),
                items: availableSpots.map<DropdownMenuItem<String>>((spot) {
                  return DropdownMenuItem<String>(
                    value: spot['id'],
                    child: Text(
                      spot['id'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSpotId = value;
                  });
                  _selectSpot(context, value!); // same function you already use
                },
              );

            },
          ),
        ],
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
