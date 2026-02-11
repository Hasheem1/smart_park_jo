import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRTimerScreen extends StatefulWidget {
  final String qrValue; // QR code to monitor
  const QRTimerScreen({super.key, required this.qrValue});

  @override
  State<QRTimerScreen> createState() => _QRTimerScreenState();
}

class _QRTimerScreenState extends State<QRTimerScreen> {
  DateTime? startTime;
  Duration elapsed = Duration.zero;
  Timer? timer;
  bool timerRunning = false;
  String? sessionId;

  @override
  void initState() {
    super.initState();
    listenToScanState();
  }

  void listenToScanState() {
    // Listen continuously for any session with this QR code
    FirebaseFirestore.instance
        .collection('parking_sessions')
        .where('qrCode', isEqualTo: widget.qrValue)
        .orderBy('startTime', descending: true) // latest first
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isEmpty) {
        stopTimer();
        return;
      }

      final doc = snapshot.docs.first;
      final data = doc.data();

      final scanState = data['scanState'] ?? false; // true = scanned, false = idle
      final status = data['status'] ?? 'inactive';

      if (scanState == true && status == 'active' && !timerRunning) {
        // Start timer
        sessionId = doc.id;
        startTime = (data['startTime'] as Timestamp).toDate();
        startTimer();
      } else if (scanState == false && timerRunning) {
        // Stop timer if scan is cleared
        stopTimer();
      }
    });
  }

  void startTimer() {
    timerRunning = true;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        elapsed = DateTime.now().difference(startTime!);
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
    timerRunning = false;
    setState(() {}); // keep elapsed for display
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              "Parking session stopped ⏱ Total: ${elapsed.inMinutes} min ${elapsed.inSeconds.remainder(60)} sec")),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QR Parking Timer")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: QrImageView(
              data: widget.qrValue,
              version: QrVersions.auto,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Elapsed: ${elapsed.inMinutes.remainder(60).toString().padLeft(2, '0')}:${elapsed.inSeconds.remainder(60).toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}
