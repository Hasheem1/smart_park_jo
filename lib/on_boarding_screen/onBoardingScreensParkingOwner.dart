import 'package:flutter/material.dart';

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
      "desc": "Discover available parking spots in real-time on an interactive map.",
      "image": "https://cdn-icons-png.flaticon.com/512/684/684908.png",
    },
    {
      "title": "Reserve in Seconds",
      "desc": "Book your parking spot instantly and avoid the hassle of searching.",
      "image": "https://cdn-icons-png.flaticon.com/512/2921/2921222.png",
    },
    {
      "title": "Save Time & Money",
      "desc": "Get the best rates and never waste time looking for parking again.",
      "image": "https://cdn-icons-png.flaticon.com/512/158/158271.png",
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 4,
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
                          // 🌐 Network Image
                          Expanded(
                            child: Image.network(
                              onboardingData[index]["image"]!,
                              fit: BoxFit.contain,
                              height: 260,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image_not_supported,
                                    color: Colors.white54, size: 120);
                              },
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            onboardingData[index]["title"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            onboardingData[index]["desc"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
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

              const SizedBox(height: 20),

              // 🔘 Page Indicator Dots
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
                          ? Colors.white
                          : Colors.white54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 🎯 Next / Get Started Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1E3C72),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 55),
                  ),
                  onPressed: () {
                    if (_currentPage == onboardingData.length - 1) {
                      // ✅ Navigate to RoleSelectionScreen or main app
                      // Navigator.pushReplacementNamed(context, '/roleSelection');
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
