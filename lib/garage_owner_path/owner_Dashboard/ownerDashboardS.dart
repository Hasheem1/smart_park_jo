import 'package:flutter/material.dart';
import '../add_lot/addLotScreen.dart';
import '../manage_spots/manageSpotsS.dart';
import '../owner_Earnings/ownerEarnings.dart';
import '../owner_profile/ownerProfile.dart';

class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2E5BFF),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Dashboard",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OwnerProfileScreen(),
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.person_outline,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Occupancy and Today cards
                    Row(
                      children: [
                        Expanded(
                          child: _smallInfoCard(
                            title: "Occupancy",
                            value: "75%",
                            subtitle: "60/80 spots",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _smallInfoCard(
                            title: "Today",
                            value: "450 JD",
                            subtitle: "+12%",
                            subtitleColor: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddParkingLotScreen(),
                        ),
                      );
                    },
                    child: _actionButton(Icons.add, "Add Lot"),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EarningsScreen(),
                        ),
                      );
                    },
                    child: _actionButton(Icons.bar_chart_rounded, "Earnings"),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // My Lots section
              const Text(
                "My Lots",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              // Example lot cards
              _lotCard(
                context: context,
                imageUrl:
                "https://scontent.famm11-1.fna.fbcdn.net/v/t39.30808-6/510798250_9897478867046860_3176114765940016402_n.jpg?stp=dst-jpg_p843x403_tt6&_nc_cat=102&ccb=1-7&_nc_sid=127cfc&_nc_ohc=J12B0aEyKk4Q7kNvwFmUIoz&_nc_oc=AdnKBda1SUyfHsxFsfjmR9GSUWUMH5OYZSGyNOhfZHoW90F4xcrlf6IpdmXUHOn-SDsyGEzjyNVW8iB7ys9YoOtl&_nc_zt=23&_nc_ht=scontent.famm11-1.fna&_nc_gid=YIeg4odDFMGd-vfU_9Z0PA&oh=00_AfcQ6BomaxvjLmNfQnYA0mvmmJhEMiRKgbyXRkunIn2HEg&oe=6909854A",
                title: "Irbid City Center Mall",
                occupied: "38/50",
                rate: "76%",
                today: "285 JD",
              ),

              const SizedBox(height: 12),

              _lotCard(
                context: context,
                imageUrl:
                "https://i0.wp.com/www.touristjordan.com/wp-content/uploads/2023/02/shutterstock_1347742772.jpg?resize=800%2C533&ssl=1",
                title: "Amman Downtown",
                occupied: "22/40",
                rate: "55%",
                today: "160 JD",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  static Widget _smallInfoCard({
    required String title,
    required String value,
    required String subtitle,
    Color subtitleColor = Colors.white70,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF3C6FFF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(color: subtitleColor, fontSize: 14),
          ),
        ],
      ),
    );
  }

  static Widget _actionButton(IconData icon, String label) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.black87),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  static Widget _lotCard({
    required BuildContext context, // ✅ fixed here
    required String imageUrl,
    required String title,
    required String occupied,
    required String rate,
    required String today,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoText("Occupied", occupied),
                    _infoText("Rate", rate),
                    _infoText("Today", today, color: Colors.green),
                  ],
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: 0.76,
                  color: const Color(0xFF2E5BFF),
                  backgroundColor: Colors.grey.shade200,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManageSpotsScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Manage Spots",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  static Widget _infoText(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.black54, fontSize: 13)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: color ?? Colors.black,
          ),
        ),
      ],
    );
  }
}
