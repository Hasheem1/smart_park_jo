import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ManageSpotsScreen extends StatefulWidget {
  final String parkingId;
  final Map<String, dynamic> parkingData;

  const ManageSpotsScreen({
    super.key,
    required this.parkingId,
    required this.parkingData,
  });

  @override
  State<ManageSpotsScreen> createState() => _ManageSpotsScreenState();
}

class _ManageSpotsScreenState extends State<ManageSpotsScreen> {
  String selectedFilter = "All";
  late List<Map<String, dynamic>> spots;

  @override
  @override
  void initState() {
    super.initState();
    spots = List<Map<String, dynamic>>.from(widget.parkingData['spots'] ?? []);
  }


  @override
  Widget build(BuildContext context) {
    final availableCount =
        spots.where((spot) => spot["status"] == "Available").length;
    final occupiedCount =
        spots.where((spot) => spot["status"] == "Occupied").length;

    List<Map<String, dynamic>> filteredSpots = spots.where((spot) {
      if (selectedFilter == "All") return true;
      return spot["status"] == selectedFilter;
    }).toList();

    return Scaffold(

      backgroundColor: Colors.transparent,
      body: Container(decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [

            Colors.white, Colors.white
          ],
        ),


      ),

        height: double.infinity,

        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 20,),
              Row(
                children: [
                  IconButton(
                    icon:
                    const Icon(Icons.arrow_back_ios_new_rounded,
                         color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    "Manage Spots",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // SUMMARY CARDS
              Row(
                children: [
                  _summaryCard("Available", availableCount),
                  const SizedBox(width: 12),
                  _summaryCard("Occupied", occupiedCount),
                ],
              ),
              const SizedBox(height: 20),

              // FILTER BUTTONS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _filterButton("All"),
                  _filterButton("Available"),
                  _filterButton("Occupied"),
                ],
              ),
              const SizedBox(height: 20),

              // SPOTS GRID
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredSpots.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final spot = filteredSpots[index];
                  final isAvailable =
                      spot["status"] == "Available";

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              spot["id"],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Switch(focusColor: Color(0xFF2F66F5),
                              activeColor: Color(0xFF2F66F5),
                              value: isAvailable,
                              onChanged: (value) {
                                setState(() {
                                  spot["status"] = value ? "Available" : "Occupied";
                                });

                                _updateSpotsInFirebase(); // ✅ SAVE IN FIREBASE
                              },
                            ),

                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          spot["status"],
                          style: TextStyle(
                            color: isAvailable
                                ? const Color(0xFF2E7D32)
                                : const Color(0xFFC62828),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _updateSpotsInFirebase() async {
    final userEmail = FirebaseAuth.instance.currentUser!.email;

    final firestore = FirebaseFirestore.instance;

    await firestore
        .collection('owners')
        .doc(userEmail)
        .collection('Owners Parking')
        .doc(widget.parkingId)
        .update({
      'spots': spots,
    });
  }

  Widget _summaryCard(String title, int value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade50.withOpacity(0.5),
              Colors.blue.shade100.withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Color(0xFF2F66F5),fontWeight: FontWeight.bold,fontSize: 20)),
            const SizedBox(height: 8),
            Text(
              "$value",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F66F5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterButton(String label) {
    final bool isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected
                ? const [
              Color(0xFF2F66F5),
              Color(0xFF1E4FD8),
            ]
                : [
              const Color(0xFF2F66F5).withOpacity(0.25),
              const Color(0xFF1E4FD8).withOpacity(0.45),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),

        child: Text(
          label,
          style:  TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
