import 'package:flutter/material.dart';

import '../garage_owner_path/on_boarding/onBoardingOwnerS.dart';
import '../users_path/on_boarding_users/onBoardingUsers.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2F66F5), Color(0xFF2F66F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),

                    ClipRRect(borderRadius: BorderRadius.circular(10)
                        ,child: Image(image: NetworkImage("https://i.pinimg.com/1200x/24/17/85/2417854e56cdab795d8abf85998e86f8.jpg"),height: 100,width: 100,)),
                    const SizedBox(height: 30,),
                    const Text(
                      "SmartPark JORDAN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Find. Reserve. Park Smart.",
                      style: TextStyle(color: Colors.white70, fontSize: 20),
                    ),
                    const Text(
                      "ابحث. احجز. أوقف بذكاء.",
                      style: TextStyle(color: Colors.white70, fontSize: 20),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),

              // Driver Card
              Expanded(
                child: Column(mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // ElevatedButton(onPressed: (){}, child: Text("klkjkj,"),
                    // style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),),
                    _buildRoleCard(
                      backGroundColor: Colors.white,
                      context,
                      title: "Continue as Driver",
                      icon: Icons.directions_car_rounded,
                      textColor: Colors.blueAccent,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => onBoardingUsers(),
                          ),
                        );
                        // Navigate to Driver screen
                      },
                    ),
                    const SizedBox(height: 20),

                    // Parking Owner Card
                    _buildRoleCard(
                      backGroundColor:Colors.green,
                      context,
                      title: "Continue as Parking Owner",
                      icon: Icons.business_rounded,
                      textColor: Colors.white,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OnboardingScreenParkingOwner(),
                          ),
                        );
                        // Navigate to Owner screen
                      },
                    ),
                    SizedBox(height: 40,)
                  ],
                ),
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
    required Color textColor,
    required Color backGroundColor,

    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backGroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
