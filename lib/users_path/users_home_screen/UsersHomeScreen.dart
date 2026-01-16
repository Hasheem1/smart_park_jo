import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_park_jo/users_path/bookings/bookingsScreen.dart';
import 'package:smart_park_jo/users_path/users%20profile/usersProfileScreen.dart';
import '../../ai_chat_bot/chatBot.dart';
import 'letsPark.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  final Color primaryBlue = const Color(0XFF2F66F5);
  final Color background = const Color(0xFFF9FAFB);

  GoogleMapController? _mapController;
  LatLng? _userLocation;
  bool _cameraMoved = false;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  // ===================== BUILD =====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🔵 FULL SCREEN MAP
          _buildHomeTab(),

          /// 🔵 FLOATING HEADER
          Positioned(
            top: MediaQuery.of(context).padding.top + 18,
            left: 16,
            right: 16,
            child: _modernHeader(context),
          ),

          /// 🔵 FLOATING BOTTOM BUTTONS
          Positioned(
            bottom: 60,
            left: 16,
            right: 16,
            child: _modernActions(context),
          ),
        ],
      ),
    );
  }

  // ===================== HEADER =====================

  Widget _modernHeader(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 70,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final double money = (data['money'] ?? 0).toDouble();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  "Park with a Smile 😊",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.smart_toy_outlined,
                            color: Colors.white),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ChatScreen()),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.account_circle,
                            color: Colors.white),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const UserProfileScreen()),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "$money JD",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  // ===================== BOTTOM ACTIONS =====================

  Widget _modernActions(BuildContext context) {
    return Row(
      children: [
        _actionCard(
          context,
          "Let’s Park!",
          Icons.car_crash_outlined,
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const letspark()),
          ),
        ),
        const SizedBox(width: 15),
        _actionCard(
          context,
          "My Reservation",
          Icons.calendar_month,
              () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MyBookingsScreen()),
          ),
        ),
      ],
    );
  }

  Widget _actionCard(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: onTap,
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: primaryBlue,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===================== MAP =====================

  Widget _buildHomeTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collectionGroup('Owners Parking')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        Set<Marker> markers = {};
        Set<Circle> circles = {};
        LatLng? center;

        for (var doc in snapshot.data!.docs) {
          final data = doc.data() as Map<String, dynamic>;
          final location = data['location'];

          if (location == null) continue;

          final lat = (location['latitude'] ?? 0).toDouble();
          final lng = (location['longitude'] ?? 0).toDouble();
          if (lat == 0 && lng == 0) continue;

          final pos = LatLng(lat, lng);
          center ??= pos;

          markers.add(
            Marker(
              markerId: MarkerId(doc.id),
              position: pos,
              infoWindow: InfoWindow(
                title: data['Parking name'] ?? 'Parking',
                snippet: "${data['Parking Capacity'] ?? 0} spots",
              ),
            ),
          );

          circles.add(
            Circle(
              circleId: CircleId(doc.id),
              center: pos,
              radius: 60,
              fillColor: Colors.red.withOpacity(0.25),
              strokeColor: Colors.redAccent,
              strokeWidth: 2,
            ),
          );
        }

        if (_mapController != null && !_cameraMoved) {
          final target = _userLocation ?? center;
          if (target != null) {
            _mapController!
                .animateCamera(CameraUpdate.newLatLngZoom(target, 15.5));
            _cameraMoved = true;
          }
        }

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _userLocation ?? const LatLng(31.9539, 35.9106),
            zoom: 15.5,
          ),
          markers: markers,
          circles: circles,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: (controller) => _mapController = controller,
        );
      },
    );
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:smart_park_jo/users_path/bookings/bookingsScreen.dart';
// import 'package:smart_park_jo/users_path/users%20profile/usersProfileScreen.dart';
// import '../../ai_chat_bot/chatBot.dart';
// import 'letsPark.dart';
//
// class DriverHomeScreen extends StatefulWidget {
//   const DriverHomeScreen({super.key});
//
//   @override
//   State<DriverHomeScreen> createState() => _DriverHomeScreenState();
// }
//
// class _DriverHomeScreenState extends State<DriverHomeScreen> {
//   final Color primaryBlue = const Color(0XFF2F66F5);
//   final Color background = const Color(0xFFF9FAFB);
//   int _selectedIndex = 0;
//   final TextEditingController _searchController = TextEditingController();
//   String searchQuery = "";
//
//   GoogleMapController? _mapController;
//   LatLng? _userLocation;
//   bool _cameraMoved = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _getUserLocation();
//   }
//
//   void _getUserLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) return;
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) return;
//     }
//     if (permission == LocationPermission.deniedForever) return;
//
//     final position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//
//     setState(() {
//       _userLocation = LatLng(position.latitude, position.longitude);
//     });
//   }
//
//   double _calculateDistanceKm(LatLng start, LatLng end) {
//     return Geolocator.distanceBetween(
//         start.latitude, start.longitude, end.latitude, end.longitude) /
//         1000;
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     _mapController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: background,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // 🌟 Modern Header
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               child: _modernHeader(context),
//             ),
//
//             // 🌟 Map and Home Tab
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: background,
//                 ),
//                 child: _buildHomeTab(),
//               ),
//             ),
//
//             // 🌟 Bottom Actions
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               child: _modernActions(context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // 🌟 Modern header with gradient & shadow
//   Widget _modernHeader(BuildContext context) {
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('users')
//           .doc(FirebaseAuth.instance.currentUser?.uid)
//           .snapshots(), // <-- NOW STREAM
//       builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return const Center(
//             child: Text(
//               "Something went wrong",
//               style: TextStyle(color: Colors.red, fontSize: 18),
//             ),
//           );
//         }
//
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(color: Colors.orange),
//           );
//         }
//
//         if (!snapshot.hasData || !snapshot.data!.exists) {
//           return const Center(
//             child: Text(
//               "No data found",
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//           );
//         }
//
//         Map<String, dynamic> data =
//         snapshot.data!.data() as Map<String, dynamic>;
//         double money = data['money']??0.0;
//
//         return Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(24),
//             gradient: const LinearGradient(
//               colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.15),
//                 blurRadius: 20,
//                 offset: const Offset(0, 10),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               // Left section: Title
//               Expanded(
//                 child: Text(
//                   "Park with a Smile 😊",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 25,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//
//               // Right section: Actions
//               Column(
//                 children: [
//                   Row(
//                     children: [
//                       // Chat button
//
//                       IconButton(
//                         icon: const Icon(Icons.smart_toy_outlined, color: Colors.white),
//                         onPressed: () => Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (_) => const ChatScreen()),
//                         ),
//                       ),
//
//                       // Profile button
//                       IconButton(
//                         icon: const Icon(Icons.account_circle, color: Colors.white),
//                         onPressed: () => Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (_) => const UserProfileScreen()),
//                         ),
//                       ),
//
//                       // Money display
//
//                     ],
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       "$money JD",
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//
//
//       },
//     );
//
//   }
//
//   // Bottom action buttons
//   Widget _modernActions(BuildContext context) {
//     return Row(
//       children: [
//         _actionCard(
//           context,
//           "Let’s Park!",
//           Icons.car_crash_outlined,
//               () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const letspark()),
//           ),
//         ),
//         const SizedBox(width: 15),
//         _actionCard(
//           context,
//           "My Reservation",
//           Icons.calendar_month,
//               () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const MyBookingsScreen()),
//           ),
//         ),
//       ],
//     );
//   }
//
//   //  Action card style
//   Widget _actionCard(
//       BuildContext context, String title, IconData icon, VoidCallback onTap) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 4.0),
//         child: InkWell(
//           borderRadius: BorderRadius.circular(25),
//           onTap: onTap,
//           child: Container(
//             height: 80,
//             padding: const EdgeInsets.symmetric(vertical: 12),
//             decoration: BoxDecoration(
//               // gradient: const LinearGradient(
//               //   colors: [Color(0xFF36D1DC), Color(0xFF5B86E5)],
//               //   begin: Alignment.topLeft,
//               //   end: Alignment.bottomRight,
//               // ),
//                 color: Color(0XFF2F66F5),
//               borderRadius: BorderRadius.circular(25),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.15),
//                   blurRadius: 10,
//                   offset: const Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(icon, color: Colors.white, size: 28),
//                 const SizedBox(height: 6),
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   //  Home tab with map
//   Widget _buildHomeTab() {
//     return Column(
//       children: [
//         // Google Map
//         Expanded(
//           child: StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance
//                 .collectionGroup('Owners Parking')
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (!snapshot.hasData) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//
//               Set<Marker> markers = {};
//               Set<Circle> circles = {};
//               LatLng? center;
//
//               for (var doc in snapshot.data!.docs) {
//                 final data = doc.data() as Map<String, dynamic>;
//                 final locationMap = data['location'] as Map<String, dynamic>?;
//                 if (locationMap == null) continue;
//
//                 final lat = (locationMap['latitude'] ?? 0.0).toDouble();
//                 final lng = (locationMap['longitude'] ?? 0.0).toDouble();
//                 if (lat == 0.0 && lng == 0.0) continue;
//
//                 final position = LatLng(lat, lng);
//                 center ??= position;
//
//                 markers.add(Marker(
//                   markerId: MarkerId(doc.id),
//                   position: position,
//                   infoWindow: InfoWindow(
//                     title: data['Parking name'] ?? 'Parking',
//                     snippet: "${data['Parking Capacity'] ?? 0} spots",
//                   ),
//                 ));
//
//                 circles.add(Circle(
//                   circleId: CircleId(doc.id),
//                   center: position,
//                   radius: 60,
//                   fillColor: Colors.red.withOpacity(0.25),
//                   strokeColor: Colors.redAccent,
//                   strokeWidth: 2,
//                 ));
//               }
//
//
//
//               // make the map center is user location
//               if (_mapController != null && !_cameraMoved) {
//                 final target = _userLocation ?? center;
//
//                 if (target != null) {
//                   _mapController!.animateCamera(
//                     CameraUpdate.newLatLngZoom(target, 15.5),
//                   );
//                   _cameraMoved = true;
//                 }
//               }
//
//
//               return GoogleMap(
//                 initialCameraPosition: CameraPosition(
//                   target: _userLocation ?? LatLng(0, 0),
//                   zoom: 15.5,
//                 ),
//                 markers: markers,
//                 circles: circles,
//                 myLocationEnabled: true,
//                 myLocationButtonEnabled: true,
//                 onMapCreated: (controller) => _mapController = controller,
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
