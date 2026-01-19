import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../active reservation/active_reservation.dart';
import 'package:intl/intl.dart';

import '../active reservation/upComingShowQR.dart';


class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedRating = 0; // stores rating from 1 to 5
  TextEditingController commentController = TextEditingController(); // stores comment

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    //hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
    removeExpiredPendingReservations();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  //hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
  Future<void> removeExpiredPendingReservations() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('reservations')
        .where('status', isEqualTo: 'pending')
        .get();

    final now = DateTime.now();

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final createdAt = data['createdAt'] as Timestamp?;
      final spotId = data['spotId'] as String?;
      final parkingId = data['parkingId'] as String?;
      final ownerEmail = data['ownerId'] as String?;


      ///change the timeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
      if (createdAt != null && now.difference(createdAt.toDate()).inMinutes >= 30) {
        // 1️⃣ Delete reservation
        await doc.reference.delete();

        // 2️⃣ Free the spot
        if (spotId != null && ownerEmail != null && parkingId != null) {
          await freeSpot(spotId, ownerEmail, parkingId);
        }
      }
    }
  }

  // hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh
  Future<void> freeSpot(String spotId, String ownerEmail, String parkingId) async {
    final firestore = FirebaseFirestore.instance;

    try {
      final parkingDocRef = firestore
          .collection('owners')
          .doc(ownerEmail)
          .collection('Owners Parking')
          .doc(parkingId);

      final docSnapshot = await parkingDocRef.get();
      if (!docSnapshot.exists) return;

      final data = docSnapshot.data() as Map<String, dynamic>;
      List spots = List.from(data['spots'] ?? []);

      for (int i = 0; i < spots.length; i++) {
        if (spots[i]['id'] == spotId) {
          spots[i]['status'] = 'Available';
          break;
        }
      }

      await parkingDocRef.update({'spots': spots});
      print("Spot $spotId is now available");
    } catch (e) {
      print("Error freeing spot: $e");
    }
  }




  // ----------------------------
  //  Beautiful Reservation Card
  // ----------------------------


  Widget buildReservationCard(Map<String, dynamic> r) {
    // Decide which timestamp to show based on status
    Timestamp? selectedTime;
    String timeLabel = "";

    if (r["status"] == "pending") {
      selectedTime = r["createdAt"];
      timeLabel = "Created at:";
    } else if (r["status"] == "active") {
      selectedTime = r["startTime"];
      timeLabel = "Started at:";
    } else if (r["status"] == "completed") {
      selectedTime = r["endTime"];
      timeLabel = "Ended at:";
    }

    String formattedTime = "";
    if (selectedTime != null) {
      formattedTime =
          DateFormat('EEE, MMM d • h:mm a').format(selectedTime.toDate());
    }

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
              // STATUS BADGE
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (() {
                    if (r["status"] == "active") return Colors.green.shade50;
                    if (r["status"] == "completed") return Colors.red.shade50;
                    return Colors.blue.shade50; // pending
                  })(),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  r["status"] ?? "Confirmed",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: (() {
                      if (r["status"] == "active") return Colors.red;
                      if (r["status"] == "completed") return Colors.green;
                      return Color(0XFF2F66F5)
                      ; // pending
                    })(),
                  ),
                ),
              ),

            ],
          ),

          const SizedBox(height: 10),

          // TIME + PRICE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, size: 18, color: Colors.grey),
                  const SizedBox(width: 4),

                  // THE NEW LABEL + TIME
                  Text(
                    "$timeLabel $formattedTime",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),

              Text(
                "${r["pricePerHour"] ?? "0"} JD",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),

              ),
            ],
          ),

          const SizedBox(height: 4),

          // Spot number
          Text(
            "Spot: ${r["spotId"] ?? "-"}",
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          // BUTTON
// BUTTON (QR OR RATE)
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                color: r["status"] == "completed"
                    ? Color(0XFF2F66F5)
                    : const Color(0XFF2F66F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  if (r["status"] == "completed") {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        int selectedRating = 0;
                        final TextEditingController commentController = TextEditingController();

                        return StatefulBuilder(
                          builder: (context, setState) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Rate Your Experience",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    // ⭐ STAR RATING
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: List.generate(5, (index) {
                                        return IconButton(
                                          onPressed: () {
                                            setState(() {
                                              selectedRating = index + 1;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.star,
                                            size: 32,
                                            color: index < selectedRating
                                                ? const Color(0XFF2F66F5)
                                                : Colors.grey.shade300,
                                          ),
                                        );
                                      }),
                                    ),

                                    const SizedBox(height: 10),

                                    // 📝 COMMENT
                                    TextField(
                                      controller: commentController,
                                      maxLines: 3,
                                      decoration: InputDecoration(
                                        hintText: "Leave a comment (optional)",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 16),

                                    // 🔘 BUTTONS
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text("Cancel"),
                                          ),
                                        ),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: selectedRating == 0
                                                ? null
                                                : () async {
                                              try {
                                                final parkingName = r["parkingName"] ?? "Unknown Parking";
                                                final userEmail = FirebaseAuth.instance.currentUser!.email ?? "unknown";

                                                final ratingsRef = FirebaseFirestore.instance
                                                    .collection('AllRatings')
                                                    .doc(parkingName);

                                                final logRef = FirebaseFirestore.instance
                                                    .collection('AllRatings')      // parent collection
                                                    .doc(parkingName)              // parent doc per parking
                                                    .collection('UsersRatings')     // subcollection
                                                    .doc(parkingName);                        // auto-generated document for this rating

                                                await logRef.set({
                                                  'userPhoneNumber': userEmail,
                                                  'message': commentController.text.trim(),
                                                  'timestamp': FieldValue.serverTimestamp(),
                                                  'rating': selectedRating,
                                                });

                                                final docSnapshot = await ratingsRef.get();

                                                if (docSnapshot.exists) {
                                                  // Get current userRatings map
                                                  Map<String, dynamic> userRatings =
                                                  Map<String, dynamic>.from(docSnapshot.data()?['userRatings'] ?? {});

                                                  if (userRatings.containsKey(userEmail)) {
                                                    // User already rated
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text("You have already rated this parking!"),
                                                        behavior: SnackBarBehavior.floating,
                                                      ),
                                                    );
                                                    return;
                                                  }

                                                  // Add new rating
                                                  userRatings[userEmail] = selectedRating;

                                                  // Calculate average
                                                  double average = userRatings.values.fold(0, (sum, r) => sum + (r as int)) / userRatings.length;

                                                  // Update ratings document
                                                  await ratingsRef.update({
                                                    'userRatings': userRatings,
                                                    'averageRating': average,
                                                  });
                                                } else {
                                                  // First rating
                                                  await ratingsRef.set({
                                                    'userRatings': {userEmail: selectedRating},
                                                    'averageRating': selectedRating.toDouble(),
                                                  });
                                                }

                                                // Log rating with comment and timestamp in a separate collection
                                                await logRef.set({
                                                  'userPhoneNumber': userEmail,
                                                  'message': commentController.text.trim(), // can be empty
                                                  'timestamp': FieldValue.serverTimestamp(),
                                                  'rating': selectedRating,
                                                });

                                                Navigator.pop(context);

                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    behavior: SnackBarBehavior.floating,
                                                    backgroundColor: Colors.transparent,
                                                    elevation: 0,
                                                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                    content: Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                                      decoration: BoxDecoration(
                                                        gradient: const LinearGradient(
                                                          colors: [Colors.grey, Color(0XFF2F66F5)],
                                                        ),
                                                        borderRadius: BorderRadius.circular(14),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black.withOpacity(0.15),
                                                            blurRadius: 10,
                                                            offset: const Offset(0, 6),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        children: const [
                                                          Icon(Icons.star_rounded, color: Colors.white, size: 26),
                                                          SizedBox(width: 12),
                                                          Expanded(
                                                            child: Text(
                                                              "Thank you for your rating!",
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    duration: Duration(seconds: 3),
                                                  ),
                                                );
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text("Failed to submit rating: $e")),
                                                );
                                              }

                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0XFF2F66F5),
                                            ),
                                            child: const Text(
                                              "Submit",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),


                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );

                  }
else {
                    // 🔵 SHOW QR CODE
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ActiveReservationScreenUpcoming(
                          reservationId: r["reservationId"],
                        ),
                      ),
                    );
                  }
                },
                icon: Icon(
                  r["status"] == "completed" ? Icons.star_rate : Icons.qr_code,
                ),
                label: Text(
                  r["status"] == "completed"
                      ? "Rate Reservation"
                      : "Show QR Code",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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


  Future<void> submitParkingRating() async {
    // 1️⃣ Check if the user selected a rating
    if (selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a rating")),
      );
      return;
    }

    final email = FirebaseAuth.instance.currentUser!.email!;

    // 2️⃣ Create a new document in a "Parkings Rating" collection
    final docRef = FirebaseFirestore.instance
        .collection('Rating')
        .doc(email)
        .collection('Parkings Rating')
        .doc(); // .doc() without an ID auto-generates a unique ID

    try {
      // 3️⃣ Save data
      await docRef.set({
        'rating': selectedRating,
        'comment': commentController.text.isNotEmpty
            ? commentController.text
            : null,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 4️⃣ Show success SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.blueGrey.shade800,
          elevation: 8,
          duration: const Duration(seconds: 3),
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "Rating submitted successfully!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      // 5️⃣ Clear the form
      setState(() {
        selectedRating = 0;
        commentController.clear();
      });

      Navigator.pop(context, true); // Optional: go back or refresh dashboard
    } catch (e) {
      print("Submit failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Submit failed: $e")),
      );
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false, // remove default back button
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child:ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0XFF2F66F5),
                    Color(0XFF2F66F5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child:                const Icon(
                   Icons.arrow_back,
                   color: Colors.black,
                   size: 28,
                 ),
              )

            ),
            const SizedBox(width: 10),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
Colors.black,
                Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const Text(
                "My Booking",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
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
              indicatorColor: Colors.transparent,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
              indicator: BoxDecoration(
                 //---------------------------------------
                 color:  Color(0XFF2F66F5),
                // ---------------------------------------
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: "Upcoming"),
                Tab(text: "Past",),
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


                //------------------UPCOMING--------------------
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

                    // Sort: active first, pending later
                    upcoming.sort((a, b) {
                      final statusA = (a.data() as Map<String, dynamic>)["status"];
                      final statusB = (b.data() as Map<String, dynamic>)["status"];

                      // "active" should be above "pending"
                      if (statusA == "active" && statusB != "active") return -1;
                      if (statusA != "active" && statusB == "active") return 1;

                      return 0; // keep same order otherwise
                    });




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
                    // 🔥 Sort completed by endTime DESC (latest completed on top)
                    past.sort((a, b) {
                      final dataA = a.data() as Map<String, dynamic>;
                      final dataB = b.data() as Map<String, dynamic>;

                      final endA = dataA["endTime"] as Timestamp?;
                      final endB = dataB["endTime"] as Timestamp?;

                      // Null safety
                      if (endA == null && endB == null) return 0;
                      if (endA == null) return 1;   // put nulls at bottom
                      if (endB == null) return -1;

                      // DESCENDING → newest first
                      return endB.toDate().compareTo(endA.toDate());
                    });



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
