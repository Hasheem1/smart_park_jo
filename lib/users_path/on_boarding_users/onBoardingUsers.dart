import 'package:flutter/material.dart';
import '../users_login_reg/usersLogIn.dart';

class onBoardingUsers extends StatefulWidget {
  const onBoardingUsers({super.key});

  @override
  State<onBoardingUsers> createState() =>
      _onBoardingUsersState();
}

class _onBoardingUsersState
    extends State<onBoardingUsers> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Find Parking Near You",
      "desc":
      "Discover available parking spots in real-time on an interactive map.",
      "image": "https://i.pinimg.com/736x/c3/d5/46/c3d546e24f48b489e3a1a85b43a37e59.jpg",
    },
    {
      "title": "Reserve in Seconds",
      "desc":
      "Book your parking spot instantly and avoid the hassle of searching.",
      "image": "https://i.pinimg.com/736x/37/49/cd/3749cddbfbd6398d326936f60fceec27.jpg",
    },
    {
      "title": "Save Time & Money",
      "desc":
      "Get the best rates and never waste time looking for parking again.",
      "image": "https://i.pinimg.com/1200x/f3/54/8f/f3548ff58fc60fea162847c24e8b7796.jpg",
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
                              height: 250, // 👈 reduced image height
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
                          builder: (context) => const UsersLogIn(),
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
