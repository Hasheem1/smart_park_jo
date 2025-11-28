import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../active reservation/active_reservation.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ----------------------------
  // 🔵 Beautiful Reservation Card
  // ----------------------------

  Widget buildReservationCard(Map<String, dynamic> r) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE + TITLE + STATUS
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  r["imageUrl"] ?? "https://via.placeholder.com/70",
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r["parkingName"] ?? "Unknown Parking",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      r["dateText"] ?? "",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // STATUS BADGE
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  r["status"] ?? "Confirmed",
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Duration + Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, size: 18, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    r["duration"] ?? "",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),

              Text(
                "${r["price"] ?? "0"} JD",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // Spot number
          Text(
            "Spot: ${r["spot"] ?? "-"}",
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          // BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ActiveReservationScreen(
                      reservationId: r["reservationId"],  // PASS THE ID
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.qr_code),
              label: const Text("Show QR Code"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------
  // 🔥 Upcoming or Past Query
  // ----------------------------
  Stream<QuerySnapshot> reservationQuery() {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection("reservations")
        .where("userId", isEqualTo: userId)
        .snapshots();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Bookings"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),

          // ----------------------------
          // 🔵 BEAUTIFUL TAB BAR
          // ----------------------------
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(30),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: "Upcoming"),
                Tab(text: "Past"),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ----------------------------
          // TAB CONTENT
          // ----------------------------
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // UPCOMING
                StreamBuilder(
                  stream: reservationQuery(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData) {
                      return const Center(child: Text("No upcoming reservations."));
                    }

                    final docs = snapshot.data!.docs;

                    final upcoming = docs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final status = data["status"] ?? "pending";

                      return status == "pending" || status == "active";
                    }).toList();



                    if (upcoming.isEmpty) {
                      return const Center(child: Text("No upcoming reservations."));
                    }

                    return ListView.builder(
                      itemCount: upcoming.length,
                      itemBuilder: (_, i) {
                        final data = upcoming[i].data() as Map<String, dynamic>;
                        data["reservationId"] = upcoming[i].id;

                        return buildReservationCard(data);
                      },
                    );
                  },
                ),



                // PAST
                StreamBuilder(
                  stream: reservationQuery(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData) {
                      return const Center(child: Text("No past reservations."));
                    }

                    final docs = snapshot.data!.docs;

                    final past = docs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final status = data["status"] ?? "pending";

                      return status == "completed";
                    }).toList();


                    if (past.isEmpty) {
                      return const Center(child: Text("No past reservations."));
                    }

                    return ListView.builder(
                      itemCount: past.length,
                      itemBuilder: (_, i) {
                        final data = past[i].data() as Map<String, dynamic>;
                        data["reservationId"] = past[i].id;

                        return buildReservationCard(data);
                      },
                    );
                  },
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
