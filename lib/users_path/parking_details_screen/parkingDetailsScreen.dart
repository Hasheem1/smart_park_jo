import 'package:flutter/material.dart';
// 🚗 Parking Details Screen
class ParkingDetailsScreen extends StatelessWidget {
  final String imageUrl, title, price, rating, distance, spots, description;

  const ParkingDetailsScreen({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.rating,
    required this.distance,
    required this.spots,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = const Color(0xFF007BFF);
    final Color successGreen = const Color(0xFF2ECC71);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(imageUrl,
                  height: 180, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: successGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(spots,
                      style: TextStyle(
                          color: successGreen, fontWeight: FontWeight.w600)),
                )
              ],
            ),
            const SizedBox(height: 16),

            // Info boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoBox("Price/hour", price),
                _infoBox("Rating", "⭐ $rating"),
                _infoBox("Distance", distance),
              ],
            ),
            const SizedBox(height: 16),

            // Features
            _sectionBox("Features", [
              _feature(Icons.access_time, "24/7 Access"),
              _feature(Icons.videocam_outlined, "CCTV Security"),
            ]),
            const SizedBox(height: 12),

            // About
            _sectionBox("About", [
              Text(description,
                  style: const TextStyle(color: Colors.black87, height: 1.4)),
            ]),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            minimumSize: const Size(double.infinity, 50),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text("Reserve Spot",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _infoBox(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(title,
                style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 6),
            Text(value,
                style:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget _sectionBox(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 8),
            ...children,
          ]),
    );
  }

  Widget _feature(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.black87)),
      ]),
    );
  }
}