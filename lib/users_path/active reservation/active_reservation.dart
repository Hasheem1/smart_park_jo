import 'dart:async';
import 'package:flutter/material.dart';

class ActiveReservationScreen extends StatefulWidget {
  const ActiveReservationScreen({super.key});

  @override
  _ActiveReservationScreenState createState() =>
      _ActiveReservationScreenState();
}

class _ActiveReservationScreenState extends State<ActiveReservationScreen> {
  Duration remainingTime = const Duration(minutes: 2);
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingTime.inSeconds > 0) {
        setState(() => remainingTime -= const Duration(seconds: 1));
      } else {
        timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String get timeFormatted {
    final minutes =
    remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
    remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final totalSeconds = 120;
    final progress = remainingTime.inSeconds / totalSeconds;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Active Reservation",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Timer Section - Full Width
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10, bottom: 30),
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.blue.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Time Remaining",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Large circular timer that adapts to screen width
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: width * 0.6, // takes ~60% of screen width
                        height: width * 0.6,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 14,
                          backgroundColor: Colors.blue.withOpacity(0.1),
                          valueColor: AlwaysStoppedAnimation(
                            Colors.green.shade500,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            timeFormatted,
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "min : sec",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Parking Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue.withOpacity(0.15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.local_parking,
                          color: Colors.green.shade500, size: 26),
                      const SizedBox(width: 8),
                      const Text(
                        "City Center Parking",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.location_on,
                              color: Colors.blueAccent, size: 18),
                          SizedBox(width: 4),
                          Text(
                            "0.5 km away",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "5 JOD",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Car Plate Number: 8",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // Buttons Section
            _buildButton(
              color: Colors.blueAccent,
              label: "Get Directions",
              icon: Icons.navigation,
              textColor: Colors.white,
              onTap: () {},
            ),
            const SizedBox(height: 15),
            _buildButton(
              color: Colors.green.shade500,
              label: "Extend Time",
              icon: Icons.access_time,
              textColor: Colors.white,
              onTap: () {},
            ),
            const SizedBox(height: 15),
            _buildButton(
              color: Colors.white,
              label: "End Reservation",
              icon: Icons.stop_circle_outlined,
              textColor: Colors.redAccent,
              borderColor: Colors.redAccent,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required Color color,
    required String label,
    required IconData icon,
    required Color textColor,
    Color? borderColor,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: textColor),
      label: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 55),
        elevation: color == Colors.white ? 0 : 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: borderColor ?? Colors.transparent,
            width: borderColor != null ? 1.5 : 0,
          ),
        ),
      ),
    );
  }
}
