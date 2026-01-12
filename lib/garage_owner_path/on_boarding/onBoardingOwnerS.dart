import 'package:flutter/material.dart';
import '../owner_Login/ownerLoginS.dart';

class OnboardingScreenParkingOwner extends StatefulWidget {
  const OnboardingScreenParkingOwner({super.key});

  @override
  State<OnboardingScreenParkingOwner> createState() =>
      _OnboardingScreenParkingOwnerState();
}

class _OnboardingScreenParkingOwnerState
    extends State<OnboardingScreenParkingOwner> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Add Your Parking Lot in Minutes",
      "desc":
      "Register your garage location, set your price per hour, and make it visible to thousands of drivers instantly..",
      "image": "https://media.istockphoto.com/id/1068879782/vector/isometric-cars-in-the-car-parking-mobile-searching-looking-for-parking-flat-3d-isometric.jpg?s=612x612&w=0&k=20&c=dWEGHlqiuWQabjeO0sN102SaM9hKLewT8xUNxIbfdZI=",
    },
    {
      "title": "Earn and Manage Smartly",
      "desc":
      "Track occupancy, control spot availability, and see your daily or monthly revenue in one dashboard.",
      "image": "https://i.pinimg.com/1200x/81/38/fb/8138fbd86197f17374d4a40a4eabbcf4.jpg",
    },
    {
      "title": "Join the Smart City Movement",
      "desc":
      "Help reduce traffic congestion and make parking easier for everyone — all while growing your business.",
      "image": "https://i.pinimg.com/736x/26/88/ff/2688ff3973d4057f20801a0f9436eea2.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 20),
                  child: PageView.builder(
                    controller: _controller,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemCount: onboardingData.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            SizedBox(
                              height: 289,
                              child: Image.network(
                                onboardingData[index]["image"]!,
                                fit: BoxFit.fill,
                              ),
                            ),
                            const SizedBox(height: 30),

                            // 🧾 Title
                            Text(
                              onboardingData[index]["title"]!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 15),

                            // 🧠 Description
                            Text(
                              onboardingData[index]["desc"]!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔘 Page indicator dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingData.length,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 10,
                    width: _currentPage == index ? 25 : 10,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? const Color(0xFF2F66F5)
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F66F5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 55),
                  ),
                  onPressed: () {
                    if (_currentPage == onboardingData.length - 1) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OwnerLoginScreen(),
                        ),
                      );
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    _currentPage == onboardingData.length - 1
                        ? "Get Started"
                        : "Next",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
