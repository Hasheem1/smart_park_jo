import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ActiveReservationScreen extends StatefulWidget {
  final String reservationId;

  const ActiveReservationScreen({
    super.key,
    required this.reservationId,
  });

  @override
  _ActiveReservationScreenState createState() =>
      _ActiveReservationScreenState();
}

class _ActiveReservationScreenState extends State<ActiveReservationScreen> {
  Duration elapsedTime = Duration.zero;
  Timer? timer;

  Map<String, dynamic>? reservationData;
  bool loading = true;

  final String localImagePath =
      '/mnt/data/Desktop Screenshot 2025.11.23 - 16.46.31.67 (2).png';

  @override
  void initState() {
    super.initState();
    listenToReservation();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  /// 🔥 Real-time listener
  void listenToReservation() {
    FirebaseFirestore.instance
        .collection("reservations")
        .doc(widget.reservationId)
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists) {
        setState(() {
          reservationData = null;
          loading = false;
        });
        return;
      }

      final data = snapshot.data()!;
      reservationData = data;

      final status = data["status"];
      final startTimestamp = data["startTime"];

      DateTime? startTime =
      startTimestamp != null ? startTimestamp.toDate() : null;

      if (status == "active" && startTime != null) {
        startCountUp(startTime);
      }

      if (status == "completed") {
        timer?.cancel();
      }

      setState(() => loading = false);
    });
  }

  /// 🔥 Count UP from startTime
  void startCountUp(DateTime startTime) {
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final diff = DateTime.now().difference(startTime);

      setState(() {
        elapsedTime = diff;
      });
    });
  }

  /// Format time
  String get timeFormatted {
    final h = elapsedTime.inHours.toString().padLeft(2, '0');
    final m = elapsedTime.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = elapsedTime.inSeconds.remainder(60).toString().padLeft(2, '0');
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
          child: Text("No reservation found.",
              style: TextStyle(fontSize: 18, color: Colors.black54)),
        ),
      );
    }

    final status = reservationData!["status"];
    final garageName = reservationData!["parkingName"] ?? "Unknown Garage";
    final imageUrl = reservationData!["imageUrl"] as String?;
    final distance = reservationData!["distance"] ?? "";
    final totalPrice = reservationData!["totalPrice"]?.toString() ?? "0";
    final durationTime=reservationData!["durationFormatted"]?.toString()??0;

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

            // -------------------------------
            // TIMER
            // -------------------------------
            if (status == "active") ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 5)
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Time Elapsed",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      timeFormatted,
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // QR CODE BOX
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
                  Text(
                    status == "completed"
                        ? "Reservation completed"
                        : "Show this QR at the parking entrance",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // -------------------------------
            // RESERVATION DETAILS
            // -------------------------------
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
                                style: const TextStyle(color: Colors.black54)),
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

            //bill
            Text("your bill is $durationTime")
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
              : Container(
              width: size, height: size, color: Colors.grey.shade200);
        },
      );
    }

    final f = File(localImagePath);
    return f.existsSync()
        ? Image.file(f, width: size, height: size, fit: BoxFit.cover)
        : Container(width: size, height: size, color: Colors.grey.shade200);
  }

}
