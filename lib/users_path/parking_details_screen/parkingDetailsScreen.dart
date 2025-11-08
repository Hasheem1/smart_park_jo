// import 'package:flutter/material.dart';
// // 🚗 Parking Details Screen
// class ParkingDetailsScreen extends StatefulWidget {
//   final String imageUrl, title, price, rating, distance, spots, description;
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
//   });
//
//   @override
//   State<ParkingDetailsScreen> createState() => _ParkingDetailsScreenState();
// }
//
// class _ParkingDetailsScreenState extends State<ParkingDetailsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final Color primaryBlue = const Color(0xFF007BFF);
//     final Color successGreen = const Color(0xFF2ECC71);
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F6F8),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(14),
//               child: Image.network(widget.imageUrl,
//                   height: 180, width: double.infinity, fit: BoxFit.cover),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(widget.title,
//                       style: const TextStyle(
//                           fontSize: 20, fontWeight: FontWeight.bold)),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: successGreen.withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                   child: Text(widget.spots,
//                       style: TextStyle(
//                           color: successGreen, fontWeight: FontWeight.w600)),
//                 )
//               ],
//             ),
//             const SizedBox(height: 16),
//
//             // Info boxes
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _infoBox("Price/hour", widget.price),
//                 _infoBox("Rating", "⭐ ${widget.rating}"),
//                 _infoBox("Distance", widget.distance),
//               ],
//             ),
//             const SizedBox(height: 16),
//
//             // Features
//             _sectionBox("Features", [
//               _feature(Icons.access_time, "24/7 Access"),
//               _feature(Icons.videocam_outlined, "CCTV Security"),
//             ]),
//             const SizedBox(height: 12),
//
//             // About
//             _sectionBox("About", [
//               Text(widget.description,
//                   style: const TextStyle(color: Colors.black87, height: 1.4)),
//             ]),
//             const SizedBox(height: 80),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ElevatedButton(
//           onPressed: () {},
//           style: ElevatedButton.styleFrom(
//             backgroundColor: primaryBlue,
//             minimumSize: const Size(double.infinity, 50),
//             shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           ),
//           child: const Text("Reserve Spot",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         ),
//       ),
//     );
//   }
//
//   Widget _infoBox(String title, String value) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         margin: const EdgeInsets.symmetric(horizontal: 4),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Column(
//           children: [
//             Text(title,
//                 style: const TextStyle(color: Colors.grey, fontSize: 13)),
//             const SizedBox(height: 6),
//             Text(value,
//                 style:
//                 const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _sectionBox(String title, List<Widget> children) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(title,
//                 style:
//                 const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
//             const SizedBox(height: 8),
//             ...children,
//           ]),
//     );
//   }
//
//   Widget _feature(IconData icon, String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 4),
//       child: Row(children: [
//         Icon(icon, size: 18, color: Colors.black54),
//         const SizedBox(width: 8),
//         Text(text, style: const TextStyle(color: Colors.black87)),
//       ]),
//     );
//   }
// }
//
// import 'package:flutter/material.dart';
//
// class ParkingDetailsScreen extends StatefulWidget {
//   final String imageUrl, title, price, rating, distance, spots, description;
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
//   });
//
//   @override
//   State<ParkingDetailsScreen> createState() => _ParkingDetailsScreenState();
// }
//
// class _ParkingDetailsScreenState extends State<ParkingDetailsScreen> {
//   final Color primaryBlue = const Color(0xFF007BFF);
//   final Color successGreen = const Color(0xFF2ECC71);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F6F8),
//       body: Stack(
//         children: [
//           // ✅ Image Header
//           SizedBox(
//             height: 260,
//             width: double.infinity,
//             child: Image.network(
//               widget.imageUrl,
//               fit: BoxFit.cover,
//             ),
//           ),
//
//           // ✅ Transparent AppBar
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: CircleAvatar(
//                 backgroundColor: Colors.white.withOpacity(0.9),
//                 child: IconButton(
//                   icon: const Icon(Icons.arrow_back_ios_new,
//                       color: Colors.black87),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ),
//             ),
//           ),
//
//           // ✅ Scrollable Content
//           DraggableScrollableSheet(
//             initialChildSize: 0.65,
//             minChildSize: 0.6,
//             maxChildSize: 0.95,
//             builder: (context, scrollController) {
//               return Container(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius:
//                   BorderRadius.vertical(top: Radius.circular(24)),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
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
//                       Center(
//                         child: Container(
//                           width: 40,
//                           height: 4,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[300],
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//
//                       // Title + Spots
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               widget.title,
//                               style: const TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                           ),
//                           Container(
//                             decoration: BoxDecoration(
//                               color: successGreen.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 6),
//                             child: Text(
//                               widget.spots,
//                               style: TextStyle(
//                                   color: successGreen,
//                                   fontWeight: FontWeight.w600),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//
//                       // Info boxes
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           _infoBox("💰 Price/hour", widget.price),
//                           _infoBox("⭐ Rating", widget.rating),
//                           _infoBox("📍 Distance", widget.distance),
//                         ],
//                       ),
//                       const SizedBox(height: 24),
//
//                       // Features
//                       _sectionBox("Features", [
//                         _feature(Icons.lock_clock, "24/7 Access"),
//                         _feature(Icons.videocam_outlined, "CCTV Security"),
//                         _feature(Icons.ev_station_outlined, "EV Charging"),
//                         _feature(Icons.local_parking_outlined, "Covered Parking"),
//                       ]),
//                       const SizedBox(height: 16),
//
//                       // About section
//                       _sectionBox("About", [
//                         Text(
//                           widget.description,
//                           style: const TextStyle(
//                             color: Colors.black87,
//                             height: 1.5,
//                             fontSize: 15,
//                           ),
//                         ),
//                       ]),
//                       const SizedBox(height: 100),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//
//           // ✅ Bottom reservation bar
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               height: 85,
//               padding:
//               const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                       color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text("Price per hour",
//                           style: TextStyle(color: Colors.grey, fontSize: 13)),
//                       Text(
//                         widget.price,
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                   const Spacer(),
//                   ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: primaryBlue,
//                       minimumSize: const Size(160, 50),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(14)),
//                     ),
//                     child: const Text(
//                       "Reserve Spot",
//                       style: TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _infoBox(String title, String value) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         margin: const EdgeInsets.symmetric(horizontal: 4),
//         decoration: BoxDecoration(
//           color: const Color(0xFFF8F9FB),
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 6,
//               offset: const Offset(0, 3),
//             )
//           ],
//         ),
//         child: Column(
//           children: [
//             Text(title,
//                 style: const TextStyle(color: Colors.grey, fontSize: 13)),
//             const SizedBox(height: 5),
//             Text(value,
//                 style: const TextStyle(
//                     fontWeight: FontWeight.bold, fontSize: 15)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _sectionBox(String title, List<Widget> children) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF8F9FB),
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(title,
//                 style: const TextStyle(
//                     fontWeight: FontWeight.w700, fontSize: 16)),
//             const SizedBox(height: 8),
//             ...children,
//           ]),
//     );
//   }
//
//   Widget _feature(IconData icon, String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(children: [
//         Icon(icon, size: 20, color: Colors.blueAccent),
//         const SizedBox(width: 10),
//         Text(text, style: const TextStyle(color: Colors.black87, fontSize: 15)),
//       ]),
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
  State<ParkingDetailsScreen> createState() => _ParkingDetailsScreenState();
}

class _ParkingDetailsScreenState extends State<ParkingDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: Stack(
        children: [
          // ✅ Header image with gradient
          SizedBox(
            height: 260,
            width: double.infinity,
            child: Stack(
              children: [
                Hero(
                  tag: widget.title,
                  child: Image.network(widget.imageUrl,
                      fit: BoxFit.cover, width: double.infinity, height: 260),
                ),
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

          // ✅ Back button
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

          // ✅ Scrollable content
          DraggableScrollableSheet(
            initialChildSize: 0.75,
            minChildSize: 0.75,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        const SizedBox(height: 12),

                        // Title + spots
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(widget.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87)),
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
                        const SizedBox(height: 16),

                        // Info row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InfoBox(title: "💰 Price/hour", value: widget.price),
                            InfoBox(title: "⭐ Rating", value: widget.rating),
                            InfoBox(title: "📍 Distance", value: widget.distance),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Features
                        SectionBox(title: "Features", children: const [
                          FeatureItem(
                              icon: Icons.lock_clock, text: "24/7 Access"),
                          FeatureItem(
                              icon: Icons.videocam_outlined,
                              text: "CCTV Security"),
                          FeatureItem(
                              icon: Icons.ev_station_outlined,
                              text: "EV Charging"),
                          FeatureItem(
                              icon: Icons.local_parking_outlined,
                              text: "Covered Parking"),
                        ]),
                        const SizedBox(height: 16),

                        // About section
                        SectionBox(title: "About", children: [
                          Text(widget.description,
                              style: const TextStyle(
                                  color: Colors.black87,
                                  height: 1.5,
                                  fontSize: 15)),
                        ]),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // ✅ Bottom reservation bar
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 85,
              padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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

  void _showReservationSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: 250,
          child: Center(
            child: Text(
              "Reservation feature coming soon!",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500),
            ),
          ),
        );
      },
    );
  }
}
