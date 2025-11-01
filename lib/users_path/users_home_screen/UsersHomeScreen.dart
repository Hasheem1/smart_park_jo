import 'package:flutter/material.dart';
import 'package:smart_park_jo/users_path/users_home_screen/parkingCard.dart';

import '../parking_details_screen/parkingDetailsScreen.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  final Color primaryBlue = const Color(0xFF007BFF);
  final Color background = const Color(0xFFF4F6F8);

  // 🅿️ Parking data
  final List<Map<String, String>> parkingLots = [
    {
      "image":
      "https://images.unsplash.com/photo-1506521781263-d8422e82f27a?auto=format&fit=crop&w=800&q=60",
      "title": "City Center Mall",
      "price": "2 JD/hr",
      "distance": "0.8 km",
      "rating": "4.5",
      "spots": "12 spots",
      "description":
      "Modern parking facility located in the heart of the city. Easy access to major roads and shopping areas.",
    },
    {
      "image":
      "https://images.unsplash.com/photo-1506521781263-d8422e82f27a?auto=format&fit=crop&w=800&q=60",
      "title": "irbid",
      "price": "2 JD/hr",
      "distance": "0.8 km",
      "rating": "4.5",
      "spots": "12 spots",
      "description":
      "Modern parking facility located in the heart of the city. Easy access to major roads and shopping areas.",
    },
    {
      "image":
      "https://images.unsplash.com/photo-1506521781263-d8422e82f27a?auto=format&fit=crop&w=800&q=60",
      "title": "amman",
      "price": "2 JD/hr",
      "distance": "0.8 km",
      "rating": "4.5",
      "spots": "12 spots",
      "description":
      "Modern parking facility located in the heart of the city. Easy access to major roads and shopping areas.",
    },
    {
      "image":
      "https://images.unsplash.com/photo-1506521781263-d8422e82f27a?auto=format&fit=crop&w=800&q=60",
      "title": "huson",
      "price": "2 JD/hr",
      "distance": "0.8 km",
      "rating": "4.5",
      "spots": "12 spots",
      "description":
      "Modern parking facility located in the heart of the city. Easy access to major roads and shopping areas.",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Find Parking',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Search bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search location...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Map Preview
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Map View',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Nearby header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Nearby",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "${parkingLots.length} spots",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Parking list
            Column(
              children: List.generate(
                parkingLots.length,
                    (index) {
                  final lot = parkingLots[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ParkingDetailsScreen(
                            imageUrl: lot["image"]!,
                            title: lot["title"]!,
                            price: lot["price"]!,
                            rating: lot["rating"]!,
                            distance: lot["distance"]!,
                            spots: lot["spots"]!,
                            description: lot["description"]!,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ParkingCard(
                        imageUrl: lot["image"]!,
                        title: lot["title"]!,
                        price: lot["price"]!,
                        distance: lot["distance"]!,
                        rating: lot["rating"]!,
                        spots: lot["spots"]!,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Bottom nav
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online_outlined),
            label: "Bookings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}



