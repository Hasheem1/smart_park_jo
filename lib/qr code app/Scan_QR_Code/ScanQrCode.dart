import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../l10n/app_localizations.dart';
import '../../role_selection_screen/roleSelectionScreen.dart';
import '../services/localization_service.dart';

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

  /// SIGN OUT FUNCTION
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
            (route) => false,
      );
    } catch (e) {
      showMessage("Sign out failed: $e");
    }
  }

  /// RELEASE PARKING SPOT
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

  Future<void> processQRCode(String reservationId) async {
    if (isProcessing) return;
    setState(() => isProcessing = true);

    try {
      final ownerEmail = FirebaseAuth.instance.currentUser?.email;
      if (ownerEmail == null) {
        showMessage(AppLocalizations.of(context)!.not_logged_in);
        return;
      }

      final docRef = FirebaseFirestore.instance
          .collection("reservations")
          .doc(reservationId);

      final doc = await docRef.get();

      if (!doc.exists) {
        showMessage(AppLocalizations.of(context)!.not_found);
        return;
      }

      final data = doc.data()!;
      final reservationOwnerEmail = data["ownerId"];
      final status = data["status"];

      if (reservationOwnerEmail != ownerEmail) {
        showMessage(AppLocalizations.of(context)!.not_owner);
        return;
      }

      /// START
      if (status == null || status == "pending") {
        await docRef.update({
          "status": "active",
          "startTime": Timestamp.now(),
        });

        showMessage(AppLocalizations.of(context)!.checked_in);
        return;
      }

      /// END
      if (status == "active") {
        final startTime = (data["startTime"] as Timestamp).toDate();
        final endTime = DateTime.now();

        final secondsSpent = endTime.difference(startTime).inSeconds;
        final readable = formatDurationReadable(secondsSpent);

        await docRef.update({
          "status": "completed",
          "endTime": Timestamp.fromDate(endTime),
          "totalDuration": secondsSpent,
          "durationFormatted": readable,
        });

        await releaseSpot(
          ownerEmail: data['ownerId'],
          parkingId: data['parkingId'],
          spotId: data['spotId'],
        );

        showMessage(
          '${AppLocalizations.of(context)!.checked_out}$readable',
        );
        return;
      }

      if (status == "completed") {
        showMessage(AppLocalizations.of(context)!.already_completed);
        return;
      }

      showMessage(AppLocalizations.of(context)!.unknown_status);
    } catch (e) {
      showMessage('${AppLocalizations.of(context)!.error}$e');
    } finally {
      await Future.delayed(const Duration(seconds: 3));
      controller.start();
      setState(() => isProcessing = false);
    }
  }

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
        title: Text(AppLocalizations.of(context)!.title),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,

        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: signOut,
          ),
        ],
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