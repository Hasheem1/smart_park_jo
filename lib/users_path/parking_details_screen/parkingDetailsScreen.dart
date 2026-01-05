
import 'package:flutter/material.dart';
import 'package:smart_park_jo/users_path/parking_details_screen/theme/app_colors.dart';
import 'package:smart_park_jo/users_path/parking_details_screen/widgets/feature_item.dart';
import 'package:smart_park_jo/users_path/parking_details_screen/widgets/info_box.dart';
import 'package:smart_park_jo/users_path/parking_details_screen/widgets/section_box.dart';
import 'package:smart_park_jo/garage_owner_path/add_lot/addLotScreen.dart';

import '../reservation/reservation_main.dart';

class ParkingDetailsScreen extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String price;
  final String rating;
  final String distance;
  final String spots;
  final String description;
  final String owneremail;
  final String parkinguid;

  final bool access24;
  final bool cctv;
  final bool evCharging;
  final bool disabledAccess;

  const ParkingDetailsScreen({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.rating,
    required this.distance,
    required this.spots,
    required this.description,
    required this.access24,
    required this.cctv,
    required this.evCharging,
    required this.disabledAccess,
    required this.owneremail,
    required this.parkinguid
  });

  @override
  State<ParkingDetailsScreen> createState() => _ParkingDetailsScreenState();
}

class _ParkingDetailsScreenState extends State<ParkingDetailsScreen> {
  double scrollOffset = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: Stack(
        children: [
          // 🔥 Animated Header Image
          SizedBox(
            height: 260,
            width: double.infinity,
            child: Stack(
              children: [
                AnimatedBuilder(
                  animation: Listenable.merge([]),
                  builder: (_, __) {
                    return Transform.translate(
                      offset: Offset(0, scrollOffset * 0.15), // Parallax effect
                      child: Transform.scale(
                        scale: 1 + (scrollOffset * 0.0004), // Zoom on drag
                        child: Hero(
                          tag: widget.title,
                          child: Image.network(
                            widget.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 260,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Gradient Overlay
                Container(
                  height: 260,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.35),
                        Colors.transparent
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Back Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.9),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.black87),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),

          // 🔥 Animated Scrollable Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.75,
            minChildSize: 0.75,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              scrollController.addListener(() {
                setState(() {
                  scrollOffset = scrollController.offset;
                });
              });

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),

                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Handle bar
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Title + Spots
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.successGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            child: Text(
                              widget.spots,
                              style: const TextStyle(
                                  color: AppColors.successGreen,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Info Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InfoBox(title: "💰 Price/hour", value: widget.price),
                          InfoBox(title: "⭐ Rating", value: widget.rating),
                          InfoBox(title: "📍 Distance", value: widget.distance),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // 🔥 Dynamic Features
                      SectionBox(title: "Features", children: [
                        if (widget.access24)
                          const FeatureItem(
                              icon: Icons.lock_clock, text: "24/7 Access"),

                        if (widget.cctv)
                          const FeatureItem(
                              icon: Icons.videocam_outlined,
                              text: "CCTV Security"),

                        if (widget.evCharging)
                          const FeatureItem(
                              icon: Icons.ev_station_outlined,
                              text: "EV Charging"),

                        if (widget.disabledAccess)
                          const FeatureItem(
                              icon: Icons.accessible,
                              text: "Disabled Access"),
                      ]),

                      const SizedBox(height: 16),

                      // About Section
                      SectionBox(title: "About ", children: [
                        Text(
                          widget.description,
                          style: const TextStyle(
                              color: Colors.black87,
                              height: 1.5,
                              fontSize: 15),
                        ),
                      ]),

                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              );
            },
          ),

          // Bottom Reservation Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 85,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Price per hour",
                          style: TextStyle(color: Colors.grey, fontSize: 13)),
                      Text(widget.price,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReservationScreen(
                            garageName: widget.title,
                            imageUrl: widget.imageUrl,
                            distance: widget.distance,
                            owneremail: widget.owneremail,
                            parkinguid: widget.parkinguid,
                            parkingPrice: widget.price,



                          ),
                        ),
                      );
                    },


                    style: ElevatedButton.styleFrom(
                      backgroundColor:  Color(0XFF2F66F5),
                      minimumSize: const Size(160, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Reserve Spot",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
