// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../bookings/bookingsScreen.dart';
// import '../parking_details_screen/parkingDetailsScreen.dart';
// import '../users profile/usersProfileScreen.dart';
//
// class DriverHomeScreen extends StatefulWidget {
//   const DriverHomeScreen({super.key});
//
//   @override
//   State<DriverHomeScreen> createState() => _DriverHomeScreenState();
// }
//
// class _DriverHomeScreenState extends State<DriverHomeScreen> {
//   final Color primaryBlue = const Color(0xFF007BFF);
//   final Color accentBlue = const Color(0xFF00B4D8);
//   final Color background = const Color(0xFFF9FAFB);
//
//   int _selectedIndex = 0;
//
//   final TextEditingController _searchController = TextEditingController();
//   String searchQuery = "";
//
//   void _onItemTapped(int index) {
//     switch (index) {
//       case 0:
//         setState(() => _selectedIndex = index);
//         break;
//       case 1:
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const MyBookingsScreen()),
//         );
//         break;
//       case 2:
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const UserProfileScreen()),
//         );
//         break;
//     }
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: background,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         centerTitle: false,
//         title: const Text(
//           "Find Parking",
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.w700,
//             color: Colors.black87,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.notifications_none_rounded, color: Colors.grey.shade700),
//             onPressed: () {},
//           ),
//           const SizedBox(width: 4),
//         ],
//       ),
//       body: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           padding: const EdgeInsets.symmetric(horizontal: 18),
//           child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//               const SizedBox(height: 10),
//
//
//       // Search bar
//       Container(
//       decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(14),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.05),
//           blurRadius: 10,
//           offset: const Offset(0, 4),
//         ),
//       ],
//     ),
//     child: TextField(
//     controller: _searchController,
//     decoration: InputDecoration(
//     hintText: 'Search by location or name...',
//     hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
//     prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade700),
//     border: InputBorder.none,
//     contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//     ),
//     onChanged: (value) {
//     setState(() => searchQuery = value.toLowerCase());
//     },
//     ),
//     ),
//
//     const SizedBox(height: 20),
//
//     // Map preview
//     Container(
//     height: 180,
//     width: double.infinity,
//     decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(18),
//     gradient: LinearGradient(
//     colors: [primaryBlue.withOpacity(0.9), accentBlue],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     ),
//     boxShadow: [
//     BoxShadow(
//     color: primaryBlue.withOpacity(0.2),
//     blurRadius: 12,
//     offset: const Offset(0, 6),
//     )
//     ],
//     ),
//     child: Stack(
//     alignment: Alignment.center,
//     children: [
//     const Icon(Icons.location_on, color: Colors.white, size: 50),
//     Positioned(
//     bottom: 16,
//     child: Container(
//     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//     decoration: BoxDecoration(
//     color: Colors.white.withOpacity(0.2),
//     borderRadius: BorderRadius.circular(10),
//     ),
//     child: const Text(
//     "Map Preview",
//     style: TextStyle(color: Colors.white, fontSize: 16),
//     ),
//     ),
//     ),
//     ],
//     ),
//     ),
//
//     const SizedBox(height: 24),
//
//     // Nearby Parking Header
//     Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: const [
//     Text(
//     "Nearby Parking",
//     style: TextStyle(
//     fontSize: 20,
//     fontWeight: FontWeight.w700,
//     ),
//     ),
//     ],
//     ),
//
//     const SizedBox(height: 14),
//
//     // Stream and search filter
//     StreamBuilder(
//     stream: FirebaseFirestore.instance.collectionGroup('Owners Parking').snapshots(),
//     builder: (context, snapshot) {
//     if (snapshot.connectionState == ConnectionState.waiting) {
//     return const Center(child: CircularProgressIndicator());
//     }
//
//     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//     return const Padding(
//     padding: EdgeInsets.all(20),
//     child: Text(
//     "No parking lots available yet.",
//     style: TextStyle(fontSize: 16, color: Colors.grey),
//     ),
//     );
//     }
//
//     final docs = snapshot.data!.docs;
//
//     // Filter based on search query
//     final filteredDocs = docs.where((doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     final name = (data["Parking name"] ?? "").toString().toLowerCase();
//     final location = (data["location"] ?? "").toString().toLowerCase();
//     return name.contains(searchQuery) || location.contains(searchQuery);
//     }).toList();
//
//     if (filteredDocs.isEmpty) {
//     return const Padding(
//     padding: EdgeInsets.all(20),
//     child: Text(
//     "No parking lots match your search.",
//     style: TextStyle(fontSize: 16, color: Colors.grey),
//     ),
//     );
//     }
//
//     return Column(
//     children: filteredDocs.map((doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return GestureDetector(
//     onTap: () {
//     Navigator.push(
//     context,
//     MaterialPageRoute(
//     builder: (_) => ParkingDetailsScreen(
//     imageUrl: data["image_url"] ?? "",
//     title: data["Parking name"] ?? "",
//     price: data["price"] ?? "",
//     rating: data["rating"] ?? "",
//     distance: data["distance"] ?? "0 km",
//     spots: "${data["capacity"] ?? 0} spots",
//     description: data["description"] ?? "",
//     ),
//     ),
//     );
//     },
//     child: ParkingCard(
//     imageUrl: data["image_url"] ?? "",
//     title: data["Parking name"] ?? "",
//     price: data["price"] ?? "",
//     distance: data["distance"] ?? "0 km",
//     rating: data["rating"] ?? "",
//     spots: "${data["capacity"] ?? 0} spots",
//     ),
//     );
//     }).toList(),
//     );
//     },
//     ),
//     ],
//     ),
//     ),
//     bottomNavigationBar: ClipRRect(
//     borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
//     child: BottomNavigationBar(
//     type: BottomNavigationBarType.fixed,
//     currentIndex: _selectedIndex,
//     selectedItemColor: primaryBlue,
//     unselectedItemColor: Colors.grey.shade500,
//     backgroundColor: Colors.white,
//     onTap: _onItemTapped,
//     items: const [
//     BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
//     BottomNavigationBarItem(icon: Icon(Icons.book_online_rounded), label: "Bookings"),
//     BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Profile"),
//     ],
//     ),
//     ),
//     );
//
//
//   }
// }
//
// // Parking Card Widget
// class ParkingCard extends StatelessWidget {
//   final String imageUrl;
//   final String title;
//   final String price;
//   final String distance;
//   final String rating;
//   final String spots;
//
//   const ParkingCard({
//     super.key,
//     required this.imageUrl,
//     required this.title,
//     required this.price,
//     required this.distance,
//     required this.rating,
//     required this.spots,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
//             child: Image.network(imageUrl, height: 120, width: double.infinity, fit: BoxFit.cover),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
//                     Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF007BFF))),
//                   ],
//                 ),
//                 const SizedBox(height: 6),
//                 Row(
//                   children: [
//                     const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
//                     Text(" $distance  •  "),
//                     const Icon(Icons.star, size: 16, color: Colors.amber),
//                     Text(rating),
//                     const Spacer(),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF2ECC71).withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       child: Text(spots, style: const TextStyle(color: Color(0xFF2ECC71), fontWeight: FontWeight.w600, fontSize: 12)),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:location/location.dart';
import '../bookings/bookingsScreen.dart';
import '../parking_details_screen/parkingDetailsScreen.dart';
import '../users profile/usersProfileScreen.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  final Color primaryBlue = const Color(0xFF007BFF);
  final Color accentBlue = const Color(0xFF00B4D8);
  final Color background = const Color(0xFFF9FAFB);

  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  GoogleMapController? _mapController;
  LatLng? _userLocation;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
  //  _getUserLocation();
  }

  // Future<void> _getUserLocation() async {
  //   Location location = Location();
  //   bool serviceEnabled = await location.serviceEnabled();
  //   if (!serviceEnabled) serviceEnabled = await location.requestService();
  //   if (!serviceEnabled) return;
  //
  //
  //   PermissionStatus permissionGranted = await location.hasPermission();
  //   if (permissionGranted == PermissionStatus.denied) permissionGranted = await location.requestPermission();
  //   if (permissionGranted != PermissionStatus.granted) return;
  //
  //   final loc = await location.getLocation();
  //   setState(() => _userLocation = LatLng(loc.latitude!, loc.longitude!));
  //   _loadNearbyGarages();
  //
  //
  // }

  void _loadNearbyGarages() async {
    final snapshot = await FirebaseFirestore.instance.collectionGroup('Owners Parking').get();


    final filteredMarkers = snapshot.docs.map((doc) {
    final data = doc.data();
    final name = (data["Parking name"] ?? "").toString().toLowerCase();
    final locationName = (data["location"] ?? "").toString().toLowerCase();

    // Filter based on search
    if (searchQuery.isNotEmpty && !name.contains(searchQuery) && !locationName.contains(searchQuery)) {
    return null;
    }

    final lat = double.tryParse(data["latitude"].toString()) ?? 0.0;
    final lng = double.tryParse(data["longitude"].toString()) ?? 0.0;

    return Marker(
    markerId: MarkerId(doc.id),
    position: LatLng(lat, lng),
    infoWindow: InfoWindow(
    title: data["Parking name"],
    snippet: "${data["distance"] ?? ""} • ${data["capacity"] ?? 0} spots",
    ),
    );
    }).where((m) => m != null).cast<Marker>().toSet();

    setState(() => _markers = filteredMarkers);


  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        setState(() => _selectedIndex = index);
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MyBookingsScreen()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const UserProfileScreen()));
        break;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
          "Find Parking",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black87),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none_rounded, color: Colors.grey.shade700),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
          children: [
// Search Bar
      Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search by location or name...',
          prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade700),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        ),
        onChanged: (value) {
          setState(() {
            searchQuery = value.toLowerCase();
            _loadNearbyGarages();
          });
        },
      ),
    ),


    // Google Map
    Expanded(
    flex: 2,
    child: _userLocation == null
    ? const Center(child: CircularProgressIndicator())
        : GoogleMap(
    initialCameraPosition: CameraPosition(target: _userLocation!, zoom: 14),
    myLocationEnabled: true,
    myLocationButtonEnabled: true,
    markers: _markers,
    onMapCreated: (controller) => _mapController = controller,
    ),
    ),

    // Nearby garages list
    Expanded(
    flex: 3,
    child: StreamBuilder(
    stream: FirebaseFirestore.instance.collectionGroup('Owners Parking').snapshots(),
    builder: (context, snapshot) {
    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

    final docs = snapshot.data!.docs;
    final filteredDocs = docs.where((doc) {
    final data = doc.data();
    final name = (data["Parking name"] ?? "").toString().toLowerCase();
    final locationName = (data["location"] ?? "").toString().toLowerCase();
    return name.contains(searchQuery) || locationName.contains(searchQuery);
    }).toList();

    if (filteredDocs.isEmpty) {
    return const Center(child: Text("No parking lots match your search."));
    }

    return ListView(
    padding: const EdgeInsets.all(16),
    children: filteredDocs.map((doc) {
    final data = doc.data();
    return GestureDetector(
    onTap: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (_) => ParkingDetailsScreen(
    imageUrl: data["image_url"] ?? "",
    title: data["Parking name"] ?? "",
    price: data["price"] ?? "",
    rating: data["rating"] ?? "",
    distance: data["distance"] ?? "0 km",
    spots: "${data["capacity"] ?? 0} spots",
    description: data["description"] ?? "",
    ),
    ),
    );
    },
    child: ParkingCard(
    imageUrl: data["image_url"] ?? "",
    title: data["Parking name"] ?? "",
    price: data["price"] ?? "",
    distance: data["distance"] ?? "0 km",
    rating: data["rating"] ?? "",
    spots: "${data["capacity"] ?? 0} spots",
    ),
    );
    }).toList(),
    );
    },
    ),
    ),
    ],
    ),
    bottomNavigationBar: BottomNavigationBar(
    currentIndex: _selectedIndex,
    selectedItemColor: primaryBlue,
    unselectedItemColor: Colors.grey.shade500,
    onTap: _onItemTapped,
    items: const [
    BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
    BottomNavigationBarItem(icon: Icon(Icons.book_online_rounded), label: "Bookings"),
    BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Profile"),
    ],
    ),
    );


  }
}

// Parking Card Widget (same as your original)
class ParkingCard extends StatelessWidget {
  final String imageUrl, title, price, distance, rating, spots;
  const ParkingCard({super.key, required this.imageUrl, required this.title, required this.price, required this.distance, required this.rating, required this.spots});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.network(imageUrl, height: 120, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF007BFF))),
                ]),
                const SizedBox(height: 6),
                Row(children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                  Text(" $distance  •  "),
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  Text(rating),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2ECC71).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(spots, style: const TextStyle(color: Color(0xFF2ECC71), fontWeight: FontWeight.w600, fontSize: 12)),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
