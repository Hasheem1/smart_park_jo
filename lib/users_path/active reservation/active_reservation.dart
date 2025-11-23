// import 'dart:async';
// import 'package:flutter/material.dart';
//
// class ActiveReservationScreen extends StatefulWidget {
//   const ActiveReservationScreen({super.key});
//
//   @override
//   _ActiveReservationScreenState createState() =>
//       _ActiveReservationScreenState();
// }
//
// class _ActiveReservationScreenState extends State<ActiveReservationScreen> {
//   Duration remainingTime = const Duration(minutes: 2);
//   Timer? timer;
//
//   @override
//   void initState() {
//     super.initState();
//     timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       if (remainingTime.inSeconds > 0) {
//         setState(() => remainingTime -= const Duration(seconds: 1));
//       } else {
//         timer?.cancel();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }
//
//   String get timeFormatted {
//     final minutes =
//     remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0');
//     final seconds =
//     remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0');
//     return '$minutes:$seconds';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final totalSeconds = 120;
//     final progress = remainingTime.inSeconds / totalSeconds;
//     final width = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.green.shade600,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           "Active Reservation",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//             fontSize: 20,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             // Timer Section - Full Width
//             Container(
//               width: double.infinity,
//               margin: const EdgeInsets.only(top: 10, bottom: 30),
//               padding: const EdgeInsets.symmetric(vertical: 40),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.white, Colors.blue.shade50],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(24),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.blue.withOpacity(0.1),
//                     blurRadius: 10,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   const Text(
//                     "Time Remaining",
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.black54,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   // Large circular timer that adapts to screen width
//                   Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       SizedBox(
//                         width: width * 0.6, // takes ~60% of screen width
//                         height: width * 0.6,
//                         child: CircularProgressIndicator(
//                           value: progress,
//                           strokeWidth: 14,
//                           backgroundColor: Colors.blue.withOpacity(0.1),
//                           valueColor: AlwaysStoppedAnimation(
//                             Colors.green.shade500,
//                           ),
//                         ),
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             timeFormatted,
//                             style: const TextStyle(
//                               fontSize: 48,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black87,
//                               letterSpacing: 1.2,
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           const Text(
//                             "min : sec",
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.black45,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             // Parking Info Card
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: Colors.blue.withOpacity(0.15)),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.blue.withOpacity(0.08),
//                     blurRadius: 8,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(Icons.local_parking,
//                           color: Colors.green.shade500, size: 26),
//                       const SizedBox(width: 8),
//                       const Text(
//                         "City Center Parking",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: const [
//                           Icon(Icons.location_on,
//                               color: Colors.blueAccent, size: 18),
//                           SizedBox(width: 4),
//                           Text(
//                             "0.5 km away",
//                             style: TextStyle(
//                               color: Colors.black54,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Text(
//                         "5 JOD",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.green.shade600,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 6),
//                   const Text(
//                     "Car Plate Number: 8",
//                     style: TextStyle(
//                       color: Colors.black54,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 35),
//
//             // Buttons Section
//             _buildButton(
//               color: Colors.blueAccent,
//               label: "Get Directions",
//               icon: Icons.navigation,
//               textColor: Colors.white,
//               onTap: () {},
//             ),
//             const SizedBox(height: 15),
//             _buildButton(
//               color: Colors.green.shade500,
//               label: "Extend Time",
//               icon: Icons.access_time,
//               textColor: Colors.white,
//               onTap: () {},
//             ),
//             const SizedBox(height: 15),
//             _buildButton(
//               color: Colors.white,
//               label: "End Reservation",
//               icon: Icons.stop_circle_outlined,
//               textColor: Colors.redAccent,
//               borderColor: Colors.redAccent,
//               onTap: () {},
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildButton({
//     required Color color,
//     required String label,
//     required IconData icon,
//     required Color textColor,
//     Color? borderColor,
//     required VoidCallback onTap,
//   }) {
//     return ElevatedButton.icon(
//       onPressed: onTap,
//       icon: Icon(icon, color: textColor),
//       label: Text(
//         label,
//         style: TextStyle(
//           color: textColor,
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color,
//         minimumSize: const Size(double.infinity, 55),
//         elevation: color == Colors.white ? 0 : 3,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(14),
//           side: BorderSide(
//             color: borderColor ?? Colors.transparent,
//             width: borderColor != null ? 1.5 : 0,
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ActiveReservationScreen extends StatefulWidget {
  const ActiveReservationScreen({super.key});

  @override
  _ActiveReservationScreenState createState() =>
      _ActiveReservationScreenState();
}

class _ActiveReservationScreenState extends State<ActiveReservationScreen> {
  // countdown state
  Duration remainingTime = Duration.zero;
  Timer? timer;

  // reservation data
  Map<String, dynamic>? reservationData;
  String? reservationDocId;
  bool loading = true;
  bool expiredInFirestore = false;

  // local fallback image (user uploaded screenshot)
  final String localImagePath =
      '/mnt/data/Desktop Screenshot 2025.11.23 - 16.46.31.67 (2).png';

  @override
  void initState() {
    super.initState();
    fetchLatestReservation();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // Fetch the most recent reservation for the current user
  Future<void> fetchLatestReservation() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() {
        loading = false;
        reservationData = null;
      });
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("reservations")
          .orderBy("createdAt", descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          reservationData = null;
          loading = false;
        });
        return;
      }

      final doc = snapshot.docs.first;
      final data = doc.data();

      // safe guards for expected fields
      if (data["startDate"] == null || data["durationHours"] == null) {
        // missing required fields
        setState(() {
          reservationData = data;
          reservationDocId = doc.id;
          loading = false;
        });
        return;
      }

      final Timestamp startTimestamp = data["startDate"];
      final DateTime startDate = startTimestamp.toDate();
      final int durationHours = (data["durationHours"] is int)
          ? data["durationHours"] as int
          : int.tryParse("${data["durationHours"]}") ?? 0;

      final DateTime endTime = startDate.add(Duration(hours: durationHours));
      final Duration diff = endTime.difference(DateTime.now());

      setState(() {
        reservationData = data;
        reservationDocId = doc.id;
        loading = false;
        remainingTime = diff.isNegative ? Duration.zero : diff;
      });

      // If already expired, mark expiredInFirestore accordingly
      if (diff.inSeconds <= 0) {
        // Optionally update Firestore to mark inactive/expired
        await markReservationExpiredIfNeeded(uid, doc.id, data);
      } else {
        startCountdown(endTime, uid, doc.id);
      }
    } catch (e, st) {
      // In production, report error to your crash service
      debugPrint("Error fetching reservation: $e\n$st");
      setState(() {
        loading = false;
        reservationData = null;
      });
    }
  }

  // start a periodic timer that updates remainingTime and auto-expire in Firestore
  void startCountdown(DateTime endTime, String uid, String docId) {
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      final diff = endTime.difference(DateTime.now());

      if (diff.inSeconds <= 0) {
        // time expired
        timer?.cancel();
        setState(() {
          remainingTime = Duration.zero;
        });

        await markReservationExpiredIfNeeded(uid, docId, reservationData);
      } else {
        setState(() {
          remainingTime = diff;
        });
      }
    });
  }

  // Update Firestore to mark reservation inactive/expired (only if not already)
  Future<void> markReservationExpiredIfNeeded(
      String uid, String docId, Map<String, dynamic>? data) async {
    if (data == null) return;
    try {
      final docRef = FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("reservations")
          .doc(docId);

      // we'll use an `isActive` flag to mark expired reservations
      final snapshot = await docRef.get();
      if (!snapshot.exists) return;

      final current = snapshot.data();
      if (current == null) return;

      // if isActive is already false (or missing), update to ensure consistency
      if (current.containsKey("isActive")) {
        final isActive = current["isActive"] == true;
        if (isActive) {
          await docRef.update({"isActive": false, "expiredAt": Timestamp.now()});
        }
      } else {
        // field missing — set it to false and add expiredAt
        await docRef.update({"isActive": false, "expiredAt": Timestamp.now()});
      }

      setState(() {
        expiredInFirestore = true;
      });
    } catch (e) {
      debugPrint("Error marking expired: $e");
    }
  }

  // End reservation manually (button)
  Future<void> endReservationNow() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final docId = reservationDocId;
    if (uid == null || docId == null) return;

    try {
      final docRef = FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("reservations")
          .doc(docId);

      await docRef.update({
        "isActive": false,
        "endedAt": Timestamp.now(),
      });

      timer?.cancel();
      setState(() {
        remainingTime = Duration.zero;
        expiredInFirestore = true;
      });
    } catch (e) {
      debugPrint("Error ending reservation: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to end reservation.")),
      );
    }
  }

  String get timeFormatted {
    if (remainingTime.inSeconds <= 0) return "00:00:00";
    final hours = remainingTime.inHours.toString().padLeft(2, '0');
    final minutes =
    remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
    remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  String formatDateTimeSafely(dynamic tsOrString) {
    if (tsOrString == null) return "N/A";
    try {
      DateTime dt;
      if (tsOrString is Timestamp) {
        dt = tsOrString.toDate();
      } else if (tsOrString is DateTime) {
        dt = tsOrString;
      } else {
        // try parse string
        dt = DateTime.parse(tsOrString.toString());
      }
      return DateFormat.yMMMd().add_jm().format(dt);
    } catch (_) {
      return tsOrString.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (reservationData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Active Reservation")),
        body: const Center(
          child: Text(
            "No reservations found.",
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
        ),
      );
    }

    // read fields safely
    final garageName = reservationData!["garageName"] ?? "Unknown Garage";
    final imageUrl = reservationData!["imageUrl"] as String?;
    final distance = reservationData!["distance"] ?? "";
    final totalPrice =
    reservationData!.containsKey("totalPrice") ? reservationData!["totalPrice"].toString() : "0";
    final carPlate = reservationData!["carPlate"] ?? reservationData!["car_plate"] ?? "N/A";
    final startDateStr = reservationData!["startDate"];
    final durationHours = reservationData!["durationHours"] ?? 0;

    // compute end time display
    DateTime? startDate;
    DateTime? endDate;
    try {
      if (startDateStr is Timestamp) {
        startDate = startDateStr.toDate();
      } else if (startDateStr is DateTime) {
        startDate = startDateStr;
      }
      if (startDate != null) {
        endDate = startDate.add(Duration(hours: durationHours is int ? durationHours : int.tryParse("$durationHours") ?? 0));
      }
    } catch (_) {
      startDate = null;
      endDate = null;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Active Reservation",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Timer / status card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.blue.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.06), blurRadius: 8)],
              ),
              child: Column(
                children: [
                  Text(
                    expiredInFirestore || remainingTime.inSeconds <= 0
                        ? "Reservation Expired"
                        : "Time Remaining",
                    style: const TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    timeFormatted,
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                      color: remainingTime.inSeconds <= 0 ? Colors.redAccent : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (startDate != null && endDate != null)
                    Text(
                      "${formatDateTimeSafely(startDate)}  →  ${formatDateTimeSafely(endDate)}",
                      style: const TextStyle(fontSize: 13, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Reservation details card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.12)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // image + title row
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: _buildReservationImage(imageUrl),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(garageName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 6),
                            Text(distance.toString(), style: const TextStyle(color: Colors.black54)),
                          ],
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 12),

                  // price + duration + car plate
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Price: $totalPrice JOD", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade700)),
                      Text("Duration: ${durationHours ?? 'N/A'} hrs", style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text("Car Plate: $carPlate", style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // action buttons
            _buildButton(
              color: Colors.green.shade600,
              label: expiredInFirestore || remainingTime.inSeconds <= 0 ? "Expired" : "End Reservation",
              icon: expiredInFirestore || remainingTime.inSeconds <= 0 ? Icons.check_circle_outline : Icons.stop_circle_outlined,
              textColor: Colors.white,
              onTap: expiredInFirestore || remainingTime.inSeconds <= 0
                  ? null
                  : () async {
                // confirm before ending
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("End Reservation"),
                    content: const Text("Are you sure you want to end this reservation?"),
                    actions: [
                      TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text("Cancel")),
                      TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text("End")),
                    ],
                  ),
                );
                if (confirmed == true) {
                  await endReservationNow();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Builds the image widget: try network image first, otherwise use local file fallback
  Widget _buildReservationImage(String? imageUrl) {
    const size = 80.0;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(imageUrl, width: size, height: size, fit: BoxFit.cover, errorBuilder: (_, __, ___) {
        // if network fails, try local fallback
        final f = File(localImagePath);
        if (f.existsSync()) {
          return Image.file(f, width: size, height: size, fit: BoxFit.cover);
        }
        return Container(width: size, height: size, color: Colors.grey.shade200);
      });
    } else {
      final f = File(localImagePath);
      if (f.existsSync()) {
        return Image.file(f, width: size, height: size, fit: BoxFit.cover);
      }
      return Container(width: size, height: size, color: Colors.grey.shade200);
    }
  }

  Widget _buildButton({
    required Color color,
    required String label,
    required IconData icon,
    required Color textColor,
    required VoidCallback? onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: textColor),
      label: Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}


