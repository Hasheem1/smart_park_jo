// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class AvailableSpotsScreen extends StatefulWidget {
//   final String parkingId;
//   final String owneremail;
//
//
//   const AvailableSpotsScreen({super.key, required this.parkingId,required this.owneremail
//   });
//
//   @override
//   State<AvailableSpotsScreen> createState() => _AvailableSpotsScreenState();
// }
//
// class _AvailableSpotsScreenState extends State<AvailableSpotsScreen> {
//
//   @override
//   Widget build(BuildContext context) {
//     final firestore = FirebaseFirestore.instance;
//     String? selectedSpotId;
//
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Choose Available Spot"),
//         backgroundColor: const Color(0xFF1565C0),
//       ),
//       body: Column(
//         children: [
//       StreamBuilder<DocumentSnapshot>(
//       stream: firestore
//           .collection('owners')
//           .doc(widget.owneremail)
//           .collection('Owners Parking')
//           .doc(widget.parkingId)
//           .snapshots(),   // <-- REAL-TIME UPDATES
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         final data = snapshot.data!.data() as Map<String, dynamic>;
//         final List spots = data['spots'] ?? [];
//
//         return StreamBuilder<DocumentSnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('owners')
//               .doc(widget.owneremail)
//               .collection('Owners Parking')
//               .doc(widget.parkingId)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             final data = snapshot.data!.data() as Map<String, dynamic>?;
//             final List spots = List<Map<String, dynamic>>.from(data?['spots'] ?? []);
//
//             if (spots.isEmpty) {
//               return const Center(child: Text("No spots available"));
//             }
//
//             return GridView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: spots.length,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 12,
//                 crossAxisSpacing: 12,
//                 childAspectRatio: 2.5,
//               ),
//               itemBuilder: (context, index) {
//                 final spot = spots[index];
//                 final isAvailable = spot['status'] == "Available";
//
//                 return GestureDetector(
//                   onTap: isAvailable
//                       ? () {
//                     setState(() {
//                       selectedSpotId = spot['id'];
//                     });
//                     _selectSpot(context, spot['id']);
//                   }
//                       : null, // Do nothing if occupied
//                   child: Container(
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       color: isAvailable ? Colors.green.shade200 : Colors.red.shade200,
//                       borderRadius: BorderRadius.circular(12),
//                       border: selectedSpotId == spot['id']
//                           ? Border.all(color: Colors.blue, width: 3)
//                           : null,
//                     ),
//                     child: Text(
//                       "${spot['id']} (${spot['status']})",
//                       style: TextStyle(
//                         color: isAvailable ? Colors.black : Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         );
//       //
//
//       },
//     )
//
//
//
//
//
//
//
//         ],
//       ),
//     );
//   }
//
//   void _selectSpot(BuildContext context, String spotId) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Confirm Spot"),
//         content: Text("Do you want to choose spot $spotId ?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text("Spot $spotId selected ✅")),
//               );
//
//               // Later we can convert this to REAL RESERVATION
//             },
//             child: const Text("Confirm"),
//           ),
//         ],
//       ),
//     );
//   }
// }
