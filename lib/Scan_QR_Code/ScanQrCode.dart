// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
//
// class QRScannerScreen extends StatefulWidget {
//   const QRScannerScreen({super.key});
//
//   @override
//   _QRScannerScreenState createState() => _QRScannerScreenState();
// }
//
// class _QRScannerScreenState extends State<QRScannerScreen> {
//   bool isProcessing = false;
//   final MobileScannerController controller = MobileScannerController();
//
//   void showMessage(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(msg)),
//     );
//   }
//
//
//
//   Future<void> processQRCode(String reservationId) async {
//     if (isProcessing) return;
//     setState(() => isProcessing = true);
//
//     try {
//       final ownerEmail = FirebaseAuth.instance.currentUser?.email;
//       if (ownerEmail == null) {
//         showMessage("Error: Owner email missing.");
//         return;
//       }
//
//       final docRef =
//       FirebaseFirestore.instance.collection("reservations").doc(reservationId);
//       final doc = await docRef.get();
//
//       if (!doc.exists) {
//         showMessage("❌ Reservation not found.");
//         return;
//       }
//
//       final data = doc.data()!;
//       final reservationOwnerEmail = data["ownerId"];
//       final status = data["status"];
//
//       if (reservationOwnerEmail != ownerEmail) {
//         showMessage("⛔ This reservation does NOT belong to your garage!");
//         return;
//       }
//
//       // FIRST SCAN → start timer
//       if (status == "pending" || status == null) {
//         await docRef.update({
//           "status": "active",
//           "startTime": Timestamp.now(),
//         });
//         showMessage("✅ Vehicle CHECKED-IN!");
//         return;
//       }
//
//       // SECOND SCAN → stop timer & save duration
//       if (status == "active") {
//         final startTime = (data["startTime"] as Timestamp).toDate();
//         final endTime = DateTime.now();
//
//         final secondsSpent = endTime.difference(startTime).inSeconds;
//         final readable = formatDurationReadable(secondsSpent);
//
//         await docRef.update({
//           "status": "completed",
//           "endTime": Timestamp.fromDate(endTime),
//           "totalDuration": secondsSpent,        // in seconds
//           "durationFormatted": readable,        // human-readable text
//         });
//
//         showMessage("✅ Vehicle CHECKED-OUT! Duration: $readable");
//         return;
//       }
//
//       if (status == "completed") {
//         showMessage("ℹ️ Reservation already completed.");
//         return;
//       }
//
//       showMessage("⚠️ Unknown status: $status");
//     } catch (e) {
//       showMessage("Error: $e");
//     } finally {
//       await Future.delayed(const Duration(seconds: 3));
//       controller.start(); // restart scanner
//       setState(() => isProcessing = false);
//     }
//   }
//
//   /// ✅ Helper function (keep it global or inside the State class)
//   String formatDurationReadable(int seconds) {
//     final d = Duration(seconds: seconds);
//     final h = d.inHours.toString().padLeft(2, '0');
//     final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
//     final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
//     return "$h:$m:$s";
//   }
//
//
//   void handleQrScan(String reservationId) async {
//     final docRef = FirebaseFirestore.instance
//         .collection("reservations")
//         .doc(reservationId);
//
//     final snap = await docRef.get();
//     if (!snap.exists) return;
//
//     final data = snap.data()!;
//     final status = data["status"];
//
//     // FIRST SCAN → start timer
//     if (status == null || status == "pending" || status == "created") {
//       await docRef.update({
//         "status": "active",
//         "startTime": Timestamp.now(),
//       });
//
//       print("Reservation started.");
//       return;
//     }
//
//     // SECOND SCAN → stop timer & save readable duration
//     if (status == "active") {
//       final startTime = (data["startTime"] as Timestamp).toDate();
//       final endTime = DateTime.now();
//
//       final secondsSpent = endTime.difference(startTime).inSeconds;
//       final readable = formatDurationReadable(secondsSpent);
//
//       await docRef.update({
//         "status": "completed",
//         "endTime": Timestamp.fromDate(endTime),
//         "totalDuration": secondsSpent,        // in seconds
//         "durationFormatted": readable,        // human-readable text
//       });
//
//       showMessage("✅ Vehicle CHECKED-OUT! Duration: $readable");
//       return;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("QR Scanner"),
//         backgroundColor: Colors.blue,
//       ),
//       body: MobileScanner(
//         controller: controller,
//         onDetect: (capture) {
//           if (isProcessing) return;  // prevent double-processing
//
//           final barcode = capture.barcodes.first;
//           final value = barcode.rawValue;
//
//           if (value != null) {
//             controller.stop();  // 🔥 stop camera immediately
//             processQRCode(value.trim());
//           }
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool isProcessing = false;
  final MobileScannerController controller = MobileScannerController();

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  /// 🔓 RELEASE PARKING SPOT
  Future<void> releaseSpot({
    required String ownerEmail,
    required String parkingId,
    required String spotId,
  }) async {
    final parkingRef = FirebaseFirestore.instance
        .collection('owners')
        .doc(ownerEmail)
        .collection('Owners Parking')
        .doc(parkingId);

    final snap = await parkingRef.get();
    if (!snap.exists) return;

    final data = snap.data()!;
    List spots = List.from(data['spots']);

    for (int i = 0; i < spots.length; i++) {
      if (spots[i]['id'] == spotId) {
        spots[i]['status'] = 'Available';
        break;
      }
    }

    await parkingRef.update({'spots': spots});
  }

  /// 🔥 MAIN QR PROCESS
  Future<void> processQRCode(String reservationId) async {
    if (isProcessing) return;
    setState(() => isProcessing = true);

    try {
      final ownerEmail = FirebaseAuth.instance.currentUser?.email;
      if (ownerEmail == null) {
        showMessage("❌ Owner not logged in");
        return;
      }

      final docRef =
      FirebaseFirestore.instance.collection("reservations").doc(reservationId);
      final doc = await docRef.get();

      if (!doc.exists) {
        showMessage("❌ Reservation not found.");
        return;
      }

      final data = doc.data()!;
      final reservationOwnerEmail = data["ownerId"];
      final status = data["status"];

      if (reservationOwnerEmail != ownerEmail) {
        showMessage("⛔ This reservation does NOT belong to your garage!");
        return;
      }

      // ✅ FIRST SCAN → START RESERVATION
      if (status == null || status == "pending") {
        await docRef.update({
          "status": "active",
          "startTime": Timestamp.now(),
        });

        showMessage("✅ Vehicle CHECKED-IN!");
        return;
      }

      // ✅ SECOND SCAN → END RESERVATION + FREE SPOT
      if (status == "active") {
        final startTime = (data["startTime"] as Timestamp).toDate();
        final endTime = DateTime.now();

        final secondsSpent = endTime.difference(startTime).inSeconds;
        final readable = formatDurationReadable(secondsSpent);

        // 1️⃣ complete reservation
        await docRef.update({
          "status": "completed",
          "endTime": Timestamp.fromDate(endTime),
          "totalDuration": secondsSpent,
          "durationFormatted": readable,
        });

        // 2️⃣ release spot 🔥🔥🔥
        await releaseSpot(
          ownerEmail: data['ownerId'],
          parkingId: data['parkingId'],
          spotId: data['spotId'],
        );

        showMessage("✅ Vehicle CHECKED-OUT! Duration: $readable");
        return;
      }

      if (status == "completed") {
        showMessage("ℹ️ Reservation already completed.");
        return;
      }

      showMessage("⚠️ Unknown reservation status");
    } catch (e) {
      showMessage("❌ Error: $e");
    } finally {
      await Future.delayed(const Duration(seconds: 3));
      controller.start();
      setState(() => isProcessing = false);
    }
  }

  /// ⏱ FORMAT TIME
  String formatDurationReadable(int seconds) {
    final d = Duration(seconds: seconds);
    final h = d.inHours.toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Scanner"),
        backgroundColor: Colors.blue,
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: (capture) {
          if (isProcessing) return;

          final barcode = capture.barcodes.first;
          final value = barcode.rawValue;

          if (value != null) {
            controller.stop();
            processQRCode(value.trim());
          }
        },
      ),
    );
  }
}
