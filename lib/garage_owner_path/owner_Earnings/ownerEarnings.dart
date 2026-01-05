import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  double todayTotal = 0.0;
  double weekTotal = 0.0;
  double monthTotal = 0.0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEarnings();
  }

  Future<void> _loadEarnings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final String email = user.email!;

    try {
      // Fetch all garages owned by this owner
      final parkingSnapshot = await FirebaseFirestore.instance
          .collection('owners')
          .doc(email)
          .collection('Owners Parking')
          .get();

      double today = 0;
      double week = 0;
      double month = 0;

      for (var parkingDoc in parkingSnapshot.docs) {
        String garageName = parkingDoc['Parking name'];

        // Get Earnings Document FROM earnings collection
        final earningDoc = await FirebaseFirestore.instance
            .collection("earnings")
            .doc(garageName)
            .get();

        if (earningDoc.exists) {
          final data = earningDoc.data()!;

          today += (data['todayEarnings'] ?? 0).toDouble();
          week += (data['weekEarnings'] ?? 0).toDouble();
          month += (data['monthEarnings'] ?? 0).toDouble();
        }
      }

      setState(() {
        todayTotal = today;
        weekTotal = week;
        monthTotal = month;
        isLoading = false;
      });

    } catch (e) {
      debugPrint("Error loading earnings: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Earnings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ===== Monthly Total Card =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                // gradient: const LinearGradient(
                //   colors: [Colors.grey, Color(0xFF36D1DC)],
                // ),
                color: Color(0xFF2F66F5),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total This Month",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${monthTotal.toStringAsFixed(2)} JD",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(child: _statCard("Today", todayTotal)),
                const SizedBox(width: 12),
                Expanded(child: _statCard("This Week", weekTotal)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, double value) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "${value.toStringAsFixed(2)} JD",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
