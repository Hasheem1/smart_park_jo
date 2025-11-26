// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../active reservation/active_reservation.dart';
//
// class ReservationScreen extends StatefulWidget {
//   final String garageName;
//   final String imageUrl;
//   final String distance;
//
//   const ReservationScreen({
//     super.key,
//     required this.garageName,
//     required this.imageUrl,
//     required this.distance,
//   });
//
//   @override
//   State<ReservationScreen> createState() => _ReservationScreenState();
// }
//
// class _ReservationScreenState extends State<ReservationScreen> {
//   DateTime selectedDate = DateTime.now();
//   TimeOfDay? selectedTime;
//   int durationHours = 2;
//
//   double pricePerHour = 1.5; // You can pass this later if needed
//
//   @override
//   Widget build(BuildContext context) {
//     double totalPrice = pricePerHour * durationHours;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           "Reserve Spot",
//           style: TextStyle(color: Colors.black),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // --- GARAGE INFO CARD ---
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     spreadRadius: 1,
//                     blurRadius: 6,
//                   )
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: Image.network(
//                       widget.imageUrl,
//                       width: 80,
//                       height: 80,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         widget.garageName,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           const Icon(Icons.location_on,
//                               size: 16, color: Colors.grey),
//                           const SizedBox(width: 5),
//                           Text(
//                             "${widget.distance} km",
//                             style: const TextStyle(color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 25),
//
//             // --- SELECT DATE ---
//             const Text(
//               "Select Date",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 dateButton("Today", DateTime.now()),
//                 dateButton("Tomorrow", DateTime.now().add(const Duration(days: 1))),
//                 dateButton(DateFormat("MMM d")
//                     .format(DateTime.now().add(const Duration(days: 2))), DateTime.now().add(const Duration(days: 2))),
//               ],
//             ),
//
//             const SizedBox(height: 25),
//
//             // --- SELECT TIME ---
//             const Text(
//               "Start Time",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//             ),
//             const SizedBox(height: 10),
//             GestureDetector(
//               onTap: () async {
//                 TimeOfDay? time = await showTimePicker(
//                   context: context,
//                   initialTime: TimeOfDay.now(),
//                 );
//                 if (time != null) setState(() => selectedTime = time);
//               },
//               child: Container(
//                 padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: Colors.blue),
//                 ),
//                 child: Text(
//                   selectedTime == null
//                       ? "Select Time"
//                       : selectedTime!.format(context),
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 25),
//
//             // --- DURATION ---
//             const Text(
//               "Duration",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//             ),
//             const SizedBox(height: 10),
//
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.grey.shade300),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       if (durationHours > 1) {
//                         setState(() => durationHours--);
//                       }
//                     },
//                     icon: const Icon(Icons.remove),
//                   ),
//                   Text(
//                     "$durationHours hours",
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   IconButton(
//                     onPressed: () => setState(() => durationHours++),
//                     icon: const Icon(Icons.add),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 25),
//
//             // --- SUMMARY CARD ---
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.blue.shade50,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text("Summary",
//                       style:
//                       TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                   const SizedBox(height: 10),
//                   summaryRow("Price per hour", "$pricePerHour JD"),
//                   summaryRow("Duration", "$durationHours hours"),
//                   const Divider(),
//                   summaryRow("Total", "$totalPrice JD",
//                       isBold: true, color: Colors.blue),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 30),
//
//             // --- CONTINUE BUTTON ---
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 onPressed: () {
//                   Navigator.push(context, MaterialPageRoute(
//                       builder: (context)=>ActiveReservationScreen()
//                   )
//                   );
//                 },
//                 child: const Text(
//                   "Confirm reservation",
//                   style: TextStyle(fontSize: 16, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // --- DATE BUTTON WIDGET ---
//   Widget dateButton(String label, DateTime date) {
//     bool isSelected = DateFormat("yyyy-MM-dd").format(date) ==
//         DateFormat("yyyy-MM-dd").format(selectedDate);
//
//     return Padding(
//       padding: const EdgeInsets.only(right: 10),
//       child: GestureDetector(
//         onTap: () => setState(() => selectedDate = date),
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//           decoration: BoxDecoration(
//             color: isSelected ? Colors.blue : Colors.white,
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(color: Colors.blue),
//           ),
//           child: Text(
//             label,
//             style: TextStyle(
//               color: isSelected ? Colors.white : Colors.blue,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // --- SUMMARY ROW ---
//   Widget summaryRow(String label, String value,
//       {bool isBold = false, Color? color}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label,
//               style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
//           Text(value,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//                 color: color ?? Colors.black,
//               )),
//         ],
//       ),
//     );
//   }
// }
//
//
//
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../garage_owner_path/manage_spots/availableSpotsScreen.dart';
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
    required this.parkingPrice
  });

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime selectedDate = DateTime.now();
  int durationHours = 1;

  double pricePerHour = 1.5;
  String? selectedSpotId;


  @override
//   void initState() {
//     // TODO: implement initState
// final String email=widget.owneremail;
//   }
  Widget build(BuildContext context) {
    double totalPrice = double.parse(widget.parkingPrice) * durationHours;
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
                color: Colors.white,
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
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 5),
                          Text(
                            "${widget.distance} ",
                            style: const TextStyle(color: Colors.grey),
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
                  summaryRow("Price per hour", "${widget.parkingPrice} JD"),
                  const Divider(),
                  summaryRow("Total", "$totalPrice JD",
                      isBold: true, color: Colors.blue),
                ],
              ),
            ),
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

            const SizedBox(height: 30),

            // --- SAVE TO FIREBASE + CONTINUE ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
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

    final DateTime fullDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    double totalPrice = double.parse(widget.parkingPrice) * durationHours;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("reservations")
        .add({
      "parking lot":selectedSpotId,
      "garageName": widget.garageName,
      "distance": widget.distance,
      "totalPrice": totalPrice,
      "createdAt": Timestamp.now(),
      "imageUrl":widget.imageUrl

    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ActiveReservationScreen()),
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
