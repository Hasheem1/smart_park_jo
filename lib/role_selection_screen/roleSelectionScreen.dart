import 'package:flutter/material.dart';

import '../driver_path/on_boarding_screen/onBoardingScreenParkingOwner.dart';


class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome to SmartPark JO",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Choose your role to continue",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 40),

              // Driver Card
              _buildRoleCard(
                context,
                title: "Driver",
                icon: Icons.directions_car_rounded,
                color: Colors.blueAccent,
                onTap: () {
                  // Navigate to Driver screen
                },
              ),
              const SizedBox(height: 20),

              // Parking Owner Card
              _buildRoleCard(
                context,
                title: "Parking Owner",
                icon: Icons.business_rounded,
                color: Colors.orangeAccent,
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnboardingScreenParkingOwner(),));
                  // Navigate to Owner screen
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
