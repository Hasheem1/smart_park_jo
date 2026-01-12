import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../active reservation/active_reservation.dart';

class ReservationScreen extends StatefulWidget {
  final String garageName;
  final String imageUrl;
  final String distance;
  final String owneremail;
  final String parkinguid;
  final String parkingPrice;

  const ReservationScreen({
    super.key,
    required this.garageName,
    required this.imageUrl,
    required this.distance,
    required this.owneremail,
    required this.parkinguid,
    required this.parkingPrice,
  });

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime selectedDate = DateTime.now();
  int durationHours = 1;

  int pricePerHour = 1;
  String? selectedSpotId;


  @override
//   void initState() {
//     // TODO: implement initState
// final String email=widget.owneremail;
//   }
  Widget build(BuildContext context) {
    double pricePerHour = double.parse(widget.parkingPrice);
    double totalPrice = pricePerHour * durationHours;
    final firestore = FirebaseFirestore.instance;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Reserve Spot",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- GARAGE INFO CARD ---
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient( colors: [ Colors.blue.shade50.withOpacity(0.5),
                  Colors.blue.shade100.withOpacity(0.3),
                ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 6,
                  )
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.garageName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 16, color: Colors.blueGrey),
                          const SizedBox(width: 5),
                          Text(
                            "${widget.distance} ",
                            style: const TextStyle(color: Colors.blueGrey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Summary",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                summaryRow(
                  "Price per hour",
                  "${double.tryParse(widget.parkingPrice)?.toStringAsFixed(2) ?? '0.00'} JD",
                ),
                  const Divider(),
                  summaryRow("Total","${totalPrice.toStringAsFixed(2)} JD",
                      isBold: true, color: Color(0XFF2F66F5),),
                ],
              ),
            ),

            SizedBox(height: 20,),
            Column(
              children: [
                StreamBuilder<DocumentSnapshot>(
                  stream: firestore
                      .collection('owners')
                      .doc(widget.owneremail)
                      .collection('Owners Parking')
                      .doc(widget.parkinguid)
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
                        child: Text("No available spots"),
                      );
                    }

                    return DropdownButtonFormField<String>(
                      value: selectedSpotId,
                      hint: const Text(
                        "Select parking spot",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.green.shade50,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),

                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(20),

                      menuMaxHeight: 350,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 28),
                      iconEnabledColor: Colors.green,

                      items: spots.map<DropdownMenuItem<String>>((spot) {
                        final String id = spot['id'];
                        final String status = spot['status'];

                        final bool available = status == "Available";

                        return DropdownMenuItem<String>(
                          value: id,
                          enabled: available,
                          child: Row(
                            children: [
                              Icon(
                                Icons.local_parking,
                                color: available ? Colors.green : Colors.red,
                                size: 22,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "$id • $status",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: available ? Colors.black87 : Colors.red.shade400,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      onChanged: (value) {
                        if (value == null) return;

                        final spot = spots.firstWhere((s) => s['id'] == value);

                        if (spot['status'] != "Available") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Spot ${spot['id']} is already occupied ❌"),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return;
                        }

                        setState(() {
                          selectedSpotId = value;
                        });

                        _selectSpot(context, value);
                      },
                    );



                  },
                ),
              ],
            ),

            const SizedBox(height: 30),

            // --- SAVE TO FIREBASE + CONTINUE ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:  Color(0XFF2F66F5),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: saveReservation,
                child: const Text(
                  "Confirm reservation",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  // ---------- SAVE TO FIRESTORE FUNCTION ----------
  Future<void> saveReservation() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must be logged in!")),
      );
      return;
    }

    if (selectedSpotId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 10),
              Expanded(child: Text(
                "Please select a parking spot!",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              )),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black87, // dark modern color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // extra rounded
          ),
          margin: const EdgeInsets.all(16),
          elevation: 10, // noticeable modern shadow
          duration: const Duration(seconds: 3),
        ),
      );

      return;
    }

    // Calculate total price
    double pricePerHour = double.parse(widget.parkingPrice);
    double moneyToSubtract = pricePerHour * durationHours;
    // Get user's current money
    final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final userSnapshot = await userDocRef.get();
    final userData = userSnapshot.data() ?? {};
    double currentMoney = (userData['money'] ?? 0.0);

    // Check if user has enough money
    if (currentMoney < moneyToSubtract) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating, // modern floating style
          margin: const EdgeInsets.all(16),   // floating with space around
          backgroundColor:  Color(0XFF2F66F5),    // dark, modern look
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // super rounded corners
          ),
          elevation: 6,
          duration: const Duration(seconds: 3),
          content: Row(
            children: const [
              Icon(Icons.error_outline, color: Colors.redAccent),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "You don't have enough money to make a reservation!",
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

      return; // Stop execution if not enough money
    }


    await userDocRef.set({
      'money': currentMoney - moneyToSubtract,
    }, SetOptions(merge: true));

    // Create reservation
    final reservationRef = await FirebaseFirestore.instance.collection("reservations").add({
      "userId": user.uid,
      "ownerId": widget.owneremail,
      "parkingId": widget.parkinguid,
      "parkingName": widget.garageName,
      "spotId": selectedSpotId,
      "imageUrl": widget.imageUrl,
      "distance": widget.distance,
      "pricePerHour": pricePerHour,
      "totalPrice": moneyToSubtract,
      "createdAt": Timestamp.now(),
      "status": "pending",
    });
    // final data = snapshot.data!.data() as Map<String, dynamic>;
    // final List spots = data['spots'] ?? [];

    // spot State


    occupySpot(selectedSpotId!);

    // ───────────────
    // Earnings logic
    // ───────────────
    final earningRef = FirebaseFirestore.instance.collection("earnings").doc(widget.garageName);
    final earningSnapshot = await earningRef.get();
    final earningData = earningSnapshot.data() ?? {};

    double total = (earningData["totalEarnings"] ?? 0).toDouble();
    double today = (earningData["todayEarnings"] ?? 0).toDouble();
    double week = (earningData["weekEarnings"] ?? 0).toDouble();
    double month = (earningData["monthEarnings"] ?? 0).toDouble();

    Timestamp lastUpdatedTs = earningData["lastUpdated"] ?? Timestamp.now();
    DateTime last = lastUpdatedTs.toDate();
    DateTime now = DateTime.now();

    // Reset logic
    if (now.year != last.year || now.month != last.month || now.day != last.day) {
      today = 0;
    }
    if (now.weekday == 1 && last.weekday != 1) {
      week = 0;
    }
    if (now.month != last.month || now.year != last.year) {
      month = 0;
    }

    // Update earnings
    await earningRef.set({
      "parkingId": widget.parkinguid,
      "parkingName": widget.garageName,
      "totalEarnings": total + moneyToSubtract,
      "todayEarnings": today + moneyToSubtract,
      "weekEarnings": week + moneyToSubtract,
      "monthEarnings": month + moneyToSubtract,
      "lastUpdated": Timestamp.now(),
    }, SetOptions(merge: true));

    // Navigate to QR screen
    String reservationId = reservationRef.id;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActiveReservationScreen(
          reservationId: reservationId,
        ),
      ),
    );
  }



  // ---------- DATE BUTTON WIDGET ----------
  Widget dateButton(String label, DateTime date) {
    bool isSelected = DateFormat("yyyy-MM-dd").format(date) ==
        DateFormat("yyyy-MM-dd").format(selectedDate);

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () => setState(() => selectedDate = date),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // ---------- SUMMARY ROW ----------
  Widget summaryRow(String label, String value,
      {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: color ?? Colors.black,
              )),
        ],
      ),
    );
  }
  void _selectSpot(BuildContext context, String spotId) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.local_parking_rounded,
                    size: 32,
                    color:  Color(0XFF2F66F5),
                  ),
                ),

                const SizedBox(height: 20),

                // Title
                const Text(
                  "Confirm Parking Spot",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0XFF2F66F5),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Subtitle
                Text(
                  "You’re about to reserve\nspot $spotId",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 28),

                // Confirm Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      backgroundColor:  Color(0XFF2F66F5),
                    ),
                    onPressed: () {
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          margin: const EdgeInsets.all(16),
                          content: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Icon bubble
                                Container(
                                  height: 36,
                                  width: 36,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check_circle_rounded,
                                    size: 22,
                                    color:  Color(0XFF2F66F5),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // Text
                                Expanded(
                                  child: Text(
                                    "Spot $spotId selected",
                                    style: const TextStyle(

                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 8),

                                // Emoji / subtle accent
                                // const Text("🚗", style: TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                        ),
                      );

                    },
                    child: const Text(
                      "Confirm Spot",
                      style: TextStyle(fontSize: 16,color: Colors.white),

                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Cancel Button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> occupySpot(String spotId) async {
    final firestore = FirebaseFirestore.instance;

    try {
      // Reference to the parking document
      final parkingDocRef = firestore
          .collection('owners')
          .doc(widget.owneremail)
          .collection('Owners Parking')
          .doc(widget.parkinguid);

      // Get the current data of the document
      final docSnapshot = await parkingDocRef.get();
      if (!docSnapshot.exists) return;

      final data = docSnapshot.data() as Map<String, dynamic>;
      List spots = List.from(data['spots'] ?? []);

      // Update the specific spot
      for (int i = 0; i < spots.length; i++) {
        if (spots[i]['id'] == spotId) {
          spots[i]['status'] = 'Occupied';
          break;
        }
      }

      // Save the updated spots back to Firestore
      await parkingDocRef.update({'spots': spots});

      // Optional: show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          margin: const EdgeInsets.all(16),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                // Icon bubble (occupied)
                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.car_rental_rounded,
                    size: 22,
                    color: Colors.orange,
                  ),
                ),

                const SizedBox(width: 12),

                // Text
                Expanded(
                  child: Text(
                    "Spot $spotId is now occupied",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                const Text("✅", style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ),
      );

    } catch (e) {
      print("Error updating spot: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to occupy spot $spotId ❌")),
      );
    }
  }

}
