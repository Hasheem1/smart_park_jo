import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class InfoBox extends StatelessWidget {
  final String title;
  final String? parkingName; // Pass parking name for dynamic rating
  final dynamic value;

  const InfoBox({super.key, required this.title, this.value, this.parkingName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical:5,horizontal: 10 ) ,
            child: Text(title,
                style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ),
          const SizedBox(height: 5),

          // Show price normally
          if (title == "💰 Price/hour")
            Text("${value ?? 0} JD",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15))

          // Show average rating dynamically
          else if (title == "⭐ Rating" && parkingName != null)
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('AllRatings')
                  .doc(parkingName)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Text("N/A",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15));
                }

                final data = snapshot.data!.data() as Map<String, dynamic>;
                final double averageRating =
                (data['averageRating'] ?? 0).toDouble();

                return Text(
                  "${averageRating.toStringAsFixed(1)} ",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.orange),
                );
              },
            )

          // Default fallback
          else
            Text("${value ?? ''}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15)),
        ],
      )

    );
  }
}

