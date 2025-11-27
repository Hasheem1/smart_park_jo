// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
//
// class ActiveReservationScreen extends StatefulWidget {
//   const ActiveReservationScreen({super.key, required String reservationId});
//
//   @override
//   _ActiveReservationScreenState createState() =>
//       _ActiveReservationScreenState();
// }
//
// class _ActiveReservationScreenState extends State<ActiveReservationScreen> {
//   // countdown state
//   Duration remainingTime = Duration.zero;
//   Timer? timer;
//
//   // reservation data
//   Map<String, dynamic>? reservationData;
//   String? reservationDocId;
//   bool loading = true;
//   bool expiredInFirestore = false;
//
//   final String localImagePath =
//       '/mnt/data/Desktop Screenshot 2025.11.23 - 16.46.31.67 (2).png';
//
//   @override
//   void initState() {
//     super.initState();
//     fetchLatestReservation();
//   }
//
//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }
//
//   // Fetch the most recent reservation for the current user
//   Future<void> fetchLatestReservation() async {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) {
//       setState(() {
//         loading = false;
//         reservationData = null;
//       });
//       return;
//     }
//
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection("users")
//           .doc(uid)
//           .collection("reservations")
//           .orderBy("createdAt", descending: true)
//           .limit(1)
//           .get();
//
//       if (snapshot.docs.isEmpty) {
//         setState(() {
//           reservationData = null;
//           loading = false;
//         });
//         return;
//       }
//
//       final doc = snapshot.docs.first;
//       final data = doc.data();
//
//       // safe guards for expected fields
//       if (data["startDate"] == null || data["durationHours"] == null) {
//         // missing required fields
//         setState(() {
//           reservationData = data;
//           reservationDocId = doc.id;
//           loading = false;
//         });
//         return;
//       }
//
//       final Timestamp startTimestamp = data["startDate"];
//       final DateTime startDate = startTimestamp.toDate();
//       final int durationHours = (data["durationHours"] is int)
//           ? data["durationHours"] as int
//           : int.tryParse("${data["durationHours"]}") ?? 0;
//
//       final DateTime endTime = startDate.add(Duration(hours: durationHours));
//       final Duration diff = endTime.difference(DateTime.now());
//
//       setState(() {
//         reservationData = data;
//         reservationDocId = doc.id;
//         loading = false;
//         remainingTime = diff.isNegative ? Duration.zero : diff;
//       });
//
//       // If already expired, mark expiredInFirestore accordingly
//       if (diff.inSeconds <= 0) {
//         // Optionally update Firestore to mark inactive/expired
//         await markReservationExpiredIfNeeded(uid, doc.id, data);
//       } else {
//         startCountdown(endTime, uid, doc.id);
//       }
//     } catch (e, st) {
//       // In production, report error to your crash service
//       debugPrint("Error fetching reservation: $e\n$st");
//       setState(() {
//         loading = false;
//         reservationData = null;
//       });
//     }
//   }
//
//   // start a periodic timer that updates remainingTime and auto-expire in Firestore
//   void startCountdown(DateTime endTime, String uid, String docId) {
//     timer?.cancel();
//
//     timer = Timer.periodic(const Duration(seconds: 1), (_) async {
//       final diff = endTime.difference(DateTime.now());
//
//       if (diff.inSeconds <= 0) {
//         // time expired
//         timer?.cancel();
//         setState(() {
//           remainingTime = Duration.zero;
//         });
//
//         await markReservationExpiredIfNeeded(uid, docId, reservationData);
//       } else {
//         setState(() {
//           remainingTime = diff;
//         });
//       }
//     });
//   }
//
//   // Update Firestore to mark reservation inactive/expired (only if not already)
//   Future<void> markReservationExpiredIfNeeded(
//       String uid, String docId, Map<String, dynamic>? data) async {
//     if (data == null) return;
//     try {
//       final docRef = FirebaseFirestore.instance
//           .collection("users")
//           .doc(uid)
//           .collection("reservations")
//           .doc(docId);
//
//       // we'll use an `isActive` flag to mark expired reservations
//       final snapshot = await docRef.get();
//       if (!snapshot.exists) return;
//
//       final current = snapshot.data();
//       if (current == null) return;
//
//       // if isActive is already false (or missing), update to ensure consistency
//       if (current.containsKey("isActive")) {
//         final isActive = current["isActive"] == true;
//         if (isActive) {
//           await docRef.update({"isActive": false, "expiredAt": Timestamp.now()});
//         }
//       } else {
//         // field missing — set it to false and add expiredAt
//         await docRef.update({"isActive": false, "expiredAt": Timestamp.now()});
//       }
//
//       setState(() {
//         expiredInFirestore = true;
//       });
//     } catch (e) {
//       debugPrint("Error marking expired: $e");
//     }
//   }
//
//   // End reservation manually (button)
//   Future<void> endReservationNow() async {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     final docId = reservationDocId;
//     if (uid == null || docId == null) return;
//
//     try {
//       final docRef = FirebaseFirestore.instance
//           .collection("users")
//           .doc(uid)
//           .collection("reservations")
//           .doc(docId);
//
//       await docRef.update({
//         "isActive": false,
//         "endedAt": Timestamp.now(),
//       });
//
//       timer?.cancel();
//       setState(() {
//         remainingTime = Duration.zero;
//         expiredInFirestore = true;
//       });
//     } catch (e) {
//       debugPrint("Error ending reservation: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Failed to end reservation.")),
//       );
//     }
//   }
//
//   String get timeFormatted {
//     if (remainingTime.inSeconds <= 0) return "00:00:00";
//     final hours = remainingTime.inHours.toString().padLeft(2, '0');
//     final minutes =
//     remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0');
//     final seconds =
//     remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0');
//     return '$hours:$minutes:$seconds';
//   }
//
//   String formatDateTimeSafely(dynamic tsOrString) {
//     if (tsOrString == null) return "N/A";
//     try {
//       DateTime dt;
//       if (tsOrString is Timestamp) {
//         dt = tsOrString.toDate();
//       } else if (tsOrString is DateTime) {
//         dt = tsOrString;
//       } else {
//         // try parse string
//         dt = DateTime.parse(tsOrString.toString());
//       }
//       return DateFormat.yMMMd().add_jm().format(dt);
//     } catch (_) {
//       return tsOrString.toString();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (loading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     if (reservationData == null) {
//       return Scaffold(
//         appBar: AppBar(title: const Text("Active Reservation")),
//         body: const Center(
//           child: Text(
//             "No reservations found.",
//             style: TextStyle(fontSize: 18, color: Colors.black54),
//           ),
//         ),
//       );
//     }
//
//     // read fields safely
//     final garageName = reservationData!["garageName"] ?? "Unknown Garage";
//     final imageUrl = reservationData!["imageUrl"] as String?;
//     final distance = reservationData!["distance"] ?? "";
//     final totalPrice =
//     reservationData!.containsKey("totalPrice") ? reservationData!["totalPrice"].toString() : "0";
//     final carPlate = reservationData!["carPlate"] ?? reservationData!["car_plate"] ?? "N/A";
//     final startDateStr = reservationData!["startDate"];
//     final durationHours = reservationData!["durationHours"] ?? 0;
//
//     // compute end time display
//     DateTime? startDate;
//     DateTime? endDate;
//     try {
//       if (startDateStr is Timestamp) {
//         startDate = startDateStr.toDate();
//       } else if (startDateStr is DateTime) {
//         startDate = startDateStr;
//       }
//       if (startDate != null) {
//         endDate = startDate.add(Duration(hours: durationHours is int ? durationHours : int.tryParse("$durationHours") ?? 0));
//       }
//     } catch (_) {
//       startDate = null;
//       endDate = null;
//     }
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.green.shade600,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           "Active Reservation",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             // Timer / status card
//
//
//             const SizedBox(height: 20),
//
//             // Reservation details card
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: Colors.grey.withOpacity(0.12)),
//                 boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // image + title row
//                   Row(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: _buildReservationImage(imageUrl),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(garageName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
//                             const SizedBox(height: 6),
//                             Text(distance.toString(), style: const TextStyle(color: Colors.black54)),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//
//                   const SizedBox(height: 12),
//
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("Price: $totalPrice JOD", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade700)),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 24),
//
//             // action buttons
//
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Builds the image widget: try network image first, otherwise use local file fallback
//   Widget _buildReservationImage(String? imageUrl) {
//     const size = 80.0;
//     if (imageUrl != null && imageUrl.isNotEmpty) {
//       return Image.network(imageUrl, width: size, height: size, fit: BoxFit.cover, errorBuilder: (_, __, ___) {
//         // if network fails, try local fallback
//         final f = File(localImagePath);
//         if (f.existsSync()) {
//           return Image.file(f, width: size, height: size, fit: BoxFit.cover);
//         }
//         return Container(width: size, height: size, color: Colors.grey.shade200);
//       });
//     } else {
//       final f = File(localImagePath);
//       if (f.existsSync()) {
//         return Image.file(f, width: size, height: size, fit: BoxFit.cover);
//       }
//       return Container(width: size, height: size, color: Colors.grey.shade200);
//     }
//   }
//
//
// }
//
//
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ActiveReservationScreen extends StatefulWidget {
  final String reservationId; // <-- IMPORTANT

  const ActiveReservationScreen({
    super.key,
    required this.reservationId,
  });

  @override
  _ActiveReservationScreenState createState() =>
      _ActiveReservationScreenState();
}

class _ActiveReservationScreenState extends State<ActiveReservationScreen> {
  Duration remainingTime = Duration.zero;
  Timer? timer;

  Map<String, dynamic>? reservationData;
  String? reservationDocId;
  bool loading = true;
  bool expiredInFirestore = false;

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

  Future<void> fetchLatestReservation() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("reservations")
          .doc(widget.reservationId)
          .get();

      if (!snapshot.exists) {
        setState(() {
          reservationData = null;
          loading = false;
        });
        return;
      }

      final data = snapshot.data()!;
      reservationData = data;
      reservationDocId = widget.reservationId;

      // No timer logic right now because you did not save startDate
      setState(() {
        loading = false;
        remainingTime = Duration.zero;
      });

    } catch (e) {
      setState(() {
        loading = false;
        reservationData = null;
      });
    }
  }


  void startCountdown(DateTime endTime, String uid, String docId) {
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      final diff = endTime.difference(DateTime.now());

      if (diff.inSeconds <= 0) {
        timer?.cancel();
        setState(() => remainingTime = Duration.zero);
        await markReservationExpiredIfNeeded(uid, docId, reservationData);
      } else {
        setState(() => remainingTime = diff);
      }
    });
  }

  Future<void> markReservationExpiredIfNeeded(
      String uid, String docId, Map<String, dynamic>? data) async {
    if (data == null) return;
    try {
      final docRef = FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("reservations")
          .doc(docId);

      final current = (await docRef.get()).data();
      if (current == null) return;

      if (current["isActive"] == true) {
        await docRef.update({
          "isActive": false,
          "expiredAt": Timestamp.now(),
        });
      }

      setState(() => expiredInFirestore = true);
    } catch (_) {}
  }

  Future<void> endReservationNow() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final docId = reservationDocId;
    if (uid == null || docId == null) return;

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("reservations")
          .doc(docId)
          .update({
        "isActive": false,
        "endedAt": Timestamp.now(),
      });

      timer?.cancel();
      setState(() {
        remainingTime = Duration.zero;
        expiredInFirestore = true;
      });
    } catch (_) {}
  }

  String get timeFormatted {
    if (remainingTime.inSeconds <= 0) return "00:00:00";
    final h = remainingTime.inHours.toString().padLeft(2, '0');
    final m = remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$h:$m:$s';
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
          child: Text("No reservations found.",
              style: TextStyle(fontSize: 18, color: Colors.black54)),
        ),
      );
    }

    final garageName = reservationData!["parkingName"] ?? "Unknown Garage";
    final imageUrl = reservationData!["imageUrl"] as String?;
    final distance = reservationData!["distance"] ?? "";
    final totalPrice = reservationData!["totalPrice"]?.toString() ?? "0";

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
            const SizedBox(height: 20),

            // ----------------------------------------
            // ✅ QR CODE BOX
            // ----------------------------------------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.12)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04), blurRadius: 6)
                ],
              ),
              child: Column(
                children: [
                  QrImageView(
                    data: widget.reservationId,
                    size: 220,
                    version: QrVersions.auto,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Show this QR at the parking entrance",
                    style:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ----------------------------------------
            // RESERVATION DETAILS CARD
            // ----------------------------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.12)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 6,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                            Text(garageName,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 6),
                            Text(distance.toString(),
                                style:
                                const TextStyle(color: Colors.black54)),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text("Price: $totalPrice JOD",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReservationImage(String? imageUrl) {
    const size = 80.0;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          final f = File(localImagePath);
          return f.existsSync()
              ? Image.file(f, width: size, height: size, fit: BoxFit.cover)
              : Container(width: size, height: size, color: Colors.grey.shade200);
        },
      );
    }

    final f = File(localImagePath);
    return f.existsSync()
        ? Image.file(f, width: size, height: size, fit: BoxFit.cover)
        : Container(width: size, height: size, color: Colors.grey.shade200);
  }
}
