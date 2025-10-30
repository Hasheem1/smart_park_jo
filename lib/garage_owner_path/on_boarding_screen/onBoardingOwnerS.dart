import 'package:flutter/material.dart';
import '../owner_Login_Screen/ownerLoginScreen.dart';

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
      "title": "Find Parking Near You",
      "desc":
      "Discover available parking spots in real-time on an interactive map.",
      "image": "https://cdn-icons-png.flaticon.com/512/684/684908.png",
    },
    {
      "title": "Reserve in Seconds",
      "desc":
      "Book your parking spot instantly and avoid the hassle of searching.",
      "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT4R-815HourAb5Llr-mFS3hFMgXCs6VcUZCA&s",
    },
    {
      "title": "Save Time & Money",
      "desc":
      "Get the best rates and never waste time looking for parking again.",
      "image": "https://cdn-icons-png.flaticon.com/512/7630/7630510.png",
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
              // 🖼️ PageView section (with smaller images)
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

                            // 🖼️ Smaller fixed-size image
                            SizedBox(
                              height: 80, // 👈 reduced image height
                              child: Image.network(
                                onboardingData[index]["image"]!,
                                fit: BoxFit.contain,
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

              // 🎯 Next / Get Started button
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
