

// import 'package:flutter/material.dart';
// import 'package:smart_park_jo/users_path/parking_details_screen/theme/app_colors.dart';
// import '../reservation/reservation_main.dart';
//
// class ParkingDetailsScreen extends StatefulWidget {
//   final String imageUrl;
//   final String title;
//   final String price;
//   final String rating;
//   final String distance;
//   final String spots;
//   final String description;
//
//   final bool access24;
//   final bool cctv;
//   final bool evCharging;
//   final bool disabledAccess;
//
//   const ParkingDetailsScreen({
//     super.key,
//     required this.imageUrl,
//     required this.title,
//     required this.price,
//     required this.rating,
//     required this.distance,
//     required this.spots,
//     required this.description,
//     required this.access24,
//     required this.cctv,
//     required this.evCharging,
//     required this.disabledAccess,
//   });
//
//   @override
//   State<ParkingDetailsScreen> createState() => _ParkingDetailsScreenState();
// }
//
// class _ParkingDetailsScreenState extends State<ParkingDetailsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundGray,
//       body: Stack(
//         children: [
//
//           // 🔹 Header Image
//           SizedBox(
//             height: 260,
//             width: double.infinity,
//             child: Stack(
//               children: [
//                 Hero(
//                   tag: widget.title,
//                   child: Image.network(
//                     widget.imageUrl,
//                     fit: BoxFit.cover,
//                     width: double.infinity,
//                     height: 260,
//                   ),
//                 ),
//                 Container(
//                   height: 260,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.bottomCenter,
//                       end: Alignment.topCenter,
//                       colors: [
//                         Colors.black.withOpacity(0.45),
//                         Colors.transparent
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//
//           // 🔹 Back Button
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: CircleAvatar(
//                 backgroundColor: Colors.white.withOpacity(0.9),
//                 child: IconButton(
//                   icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ),
//             ),
//           ),
//
//           // 🔹 Content Sheet
//           DraggableScrollableSheet(
//             initialChildSize: 0.75,
//             minChildSize: 0.75,
//             maxChildSize: 0.95,
//             builder: (context, scrollController) {
//               return Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 10,
//                       offset: Offset(0, -2),
//                     ),
//                   ],
//                 ),
//                 child: SingleChildScrollView(
//                   controller: scrollController,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//
//                       // Handle Indicator
//                       Center(
//                         child: Container(
//                           width: 45,
//                           height: 5,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[300],
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                       ),
//
//                       const SizedBox(height: 20),
//
//                       // 🔹 Title + Spots
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               widget.title,
//                               style: const TextStyle(
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 12, vertical: 6),
//                             decoration: BoxDecoration(
//                               color: Colors.green.withOpacity(0.12),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Text(
//                               "${widget.spots}",
//                               style: const TextStyle(
//                                 color: Colors.green,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       const SizedBox(height: 20),
//
//                       // 🔹 Info Boxes Row (Modern Style)
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           _infoCard("💰 /hour", widget.price),
//                           _infoCard("⭐ Rating", widget.rating),
//                           _infoCard("📍 Distance", widget.distance),
//                         ],
//                       ),
//
//                       const SizedBox(height: 28),
//
//                       // 🔹 FEATURES (Dynamic Showing ONLY Selected)
//                       const Text(
//                         "Features",
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 10),
//
//                       _buildFeatureList(),
//
//                       const SizedBox(height: 28),
//
//                       // 🔹 About Section
//                       const Text(
//                         "About",
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         widget.description,
//                         style: const TextStyle(
//                             fontSize: 16, height: 1.5, color: Colors.black87),
//                       ),
//
//                       const SizedBox(height: 120),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//
//           // 🔹 Bottom Reservation Bar
//           _bottomBar(context),
//         ],
//       ),
//     );
//   }
//
//   // ----------------------------------
//   // ⭐ MODERN WIDGETS
//   // ----------------------------------
//
//   Widget _infoCard(String label, String value) {
//     return Container(
//       width: 100,
//       padding: const EdgeInsets.symmetric(vertical: 14),
//       decoration: BoxDecoration(
//         color: AppColors.backgroundGray,
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Column(
//         children: [
//           Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
//           const SizedBox(height: 4),
//           Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
//         ],
//       ),
//     );
//   }
//
//   // 🔥 Only show features that are TRUE
//   Widget _buildFeatureList() {
//     final List<Map<String, dynamic>> features = [];
//
//     if (widget.access24) features.add({"icon": Icons.lock_clock, "text": "24/7 Access"});
//     if (widget.cctv) features.add({"icon": Icons.videocam_outlined, "text": "CCTV Security"});
//     if (widget.evCharging) features.add({"icon": Icons.ev_station_outlined, "text": "EV Charging"});
//     if (widget.disabledAccess) features.add({"icon": Icons.accessible, "text": "Disabled Access"});
//
//     return Column(
//       children: features
//           .map(
//             (f) => Padding(
//           padding: const EdgeInsets.symmetric(vertical: 6),
//           child: Row(
//             children: [
//               Icon(f["icon"], color: AppColors.primaryBlue, size: 26),
//               const SizedBox(width: 12),
//               Text(
//                 f["text"],
//                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//               ),
//             ],
//           ),
//         ),
//       )
//           .toList(),
//     );
//   }
//
//   // 🔹 Bottom Bar
//   Widget _bottomBar(BuildContext context) {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Container(
//         height: 85,
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, -2)),
//           ],
//         ),
//         child: Row(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text("Price per hour",
//                     style: TextStyle(color: Colors.grey, fontSize: 14)),
//                 Text(
//                   widget.price,
//                   style: const TextStyle(
//                       fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             const Spacer(),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (_) => const ReserveSpotScreen()));
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primaryBlue,
//                 minimumSize: const Size(160, 50),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//               ),
//               child: const Text(
//                 "Reserve Spot",
//                 style: TextStyle(
//                     fontSize: 17,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:smart_park_jo/users_path/parking_details_screen/theme/app_colors.dart';
import 'package:smart_park_jo/users_path/parking_details_screen/widgets/feature_item.dart';
import 'package:smart_park_jo/users_path/parking_details_screen/widgets/info_box.dart';
import 'package:smart_park_jo/users_path/parking_details_screen/widgets/section_box.dart';

import '../reservation/reservation_main.dart';

class ParkingDetailsScreen extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String price;
  final String rating;
  final String distance;
  final String spots;
  final String description;

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
                          builder: (context) => const ReserveSpotScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
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
