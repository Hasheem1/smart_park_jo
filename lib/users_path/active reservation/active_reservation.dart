import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../users_home_screen/UsersHomeScreen.dart';

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
        appBar: AppBar(
          title: const Text("Active Reservation"),
          backgroundColor: Colors.green,
        ),
        body: const Center(
          child: Text("No reservation found.",
              style: TextStyle(fontSize: 18, color: Colors.black54)),
        ),
      );
    }

    final status = reservationData!["status"];
    final garageName = reservationData!["parkingName"] ?? "Unknown Garage";
    final imageUrl = reservationData!["imageUrl"];
    final distance = reservationData!["distance"] ?? "";
    final totalPrice = (reservationData!["totalPrice"] ?? 0).toDouble();
    final durationTime = reservationData!["durationFormatted"].toString();

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DriverHomeScreen()),

            );
          },
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Active Reservation",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),


      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (status == "active") _buildTimerCard(),

            const SizedBox(height: 20),

            _buildQRCard(status),

            const SizedBox(height: 25),

            _buildDetailsCard(
              garageName: garageName,
              imageUrl: imageUrl,
              distance: distance.toString(),
              totalPrice: totalPrice,
            ),

            const SizedBox(height: 25),

            _buildBillCard(durationTime,totalPrice),

          ],
        ),
      ),
    );
  }
  Widget _buildTimerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Time Elapsed",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            timeFormatted,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.red,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildQRCard(String status) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          QrImageView(
            data: widget.reservationId,
            size: 220,
          ),
          const SizedBox(height: 12),
          Text(
            status == "completed"
                ? "Reservation Completed"
                : "Show this QR at the parking entrance",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildDetailsCard({
    required String garageName,
    required String imageUrl,
    required String distance,
    required double totalPrice,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: _buildReservationImage(imageUrl),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  garageName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  distance,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 12),
                Text(
                  "Price/hour: $totalPrice JOD",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildBillCard(String durationTime, double totalPrice) {

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.timelapse_sharp, color: Colors.green, size: 30),
          const SizedBox(width: 12),

          // TEXTS STACKED VERTICALLY
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your duration: $durationTime",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade800,
                ),

              ),
              const SizedBox(height: 6),
              Text(
                "Your total Price: $totalPrice",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade800,

                ),
              ),
            ],
          ),
        ],
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
