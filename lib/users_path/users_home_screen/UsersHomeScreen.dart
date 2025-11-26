import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

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
  final Color background = const Color(0xFFF9FAFB);
  final List<Color> appGradientColors = [
    Color(0xFF0F2027),
    Color(0xFF203A43),
    // Color(0xFF2C5364),
    // Color(0xFF36D1DC),
    // Color(0xFF5B86E5),
  ];

  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  GoogleMapController? _mapController;
  LatLng? _userLocation;
  bool _cameraMoved = false; // New flag to prevent controller errors

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  // Get user's current location
  void _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
    });
  }

  // Calculate distance in km between two LatLng points
  double _calculateDistanceKm(LatLng start, LatLng end) {
    return Geolocator.distanceBetween(
        start.latitude, start.longitude, end.latitude, end.longitude) /
        1000; // meters to km
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // just switch tabs, no navigation
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose(); // Dispose map controller safely
    super.dispose();
  }

  // Build the Home tab content
  Widget _buildHomeTab() {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search by location or name...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value.toLowerCase();
              });
            },
          ),
        ),

        // Google Map with real-time updates
        Expanded(
          flex: 1,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collectionGroup('Owners Parking').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              Set<Marker> markers = {};
              Set<Circle> circles = {};
              LatLng? center;

              for (var doc in snapshot.data!.docs) {
                final data = doc.data() as Map<String, dynamic>;
                final locationMap = data['location'] as Map<String, dynamic>?;
                if (locationMap == null) continue;

                final lat = (locationMap['latitude'] ?? 0.0).toDouble();
                final lng = (locationMap['longitude'] ?? 0.0).toDouble();
                if (lat == 0.0 && lng == 0.0) continue;

                final position = LatLng(lat, lng);
                center ??= position;

                markers.add(Marker(
                  markerId: MarkerId(doc.id),
                  position: position,
                  infoWindow: InfoWindow(
                    title: data['Parking name'] ?? 'Parking',
                    snippet: "${data['Parking Capacity'] ?? 0} spots",
                  ),
                ));

                circles.add(Circle(
                  circleId: CircleId(doc.id),
                  center: position,
                  radius: 50,
                  fillColor: Colors.red.withOpacity(0.25),
                  strokeColor: Colors.redAccent,
                  strokeWidth: 2,
                ));
              }

              if (_mapController != null && center != null && !_cameraMoved) {
                try {
                  _mapController!.animateCamera(
                    CameraUpdate.newLatLngZoom(center, 15.5), // slightly zoomed out
                  );
                  _cameraMoved = true;
                } catch (e) {
                  debugPrint('Map controller disposed: $e');
                }
              }

              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _userLocation ?? LatLng(0, 0),
                  zoom: 15.5,
                ),
                markers: markers,
                circles: circles,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onMapCreated: (controller) => _mapController = controller,
                gestureRecognizers: {
                  Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())
                },
              );
            },
          ),
        ),

// Parking List sorted by distance
        Expanded(
          flex: 2,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collectionGroup('Owners Parking').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              List<Map<String, dynamic>> parkingList = [];
              for (var doc in snapshot.data!.docs) {
                final data = doc.data() as Map<String, dynamic>;
                final locationMap = data['location'] as Map<String, dynamic>?;
                if (locationMap == null) continue;

                double distanceKm = 0;
                if (_userLocation != null) {
                  distanceKm = _calculateDistanceKm(
                    _userLocation!,
                    LatLng(
                      (locationMap['latitude'] ?? 0).toDouble(),
                      (locationMap['longitude'] ?? 0).toDouble(),
                    ),
                  );
                }

                final name = (data['Parking name'] ?? '').toString().toLowerCase();
                if (!name.contains(searchQuery)) continue;

                parkingList.add({
                  'doc': doc,
                  'data': data,
                  'distanceKm': distanceKm,
                });
              }

              parkingList.sort((a, b) => a['distanceKm'].compareTo(b['distanceKm']));

              if (parkingList.isEmpty) {
                return const Center(
                  child: Text(
                    "No parking lots found",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: parkingList.length,
                itemBuilder: (context, index) {
                  final data = parkingList[index]['data'] as Map<String, dynamic>;
                  final distanceKm = parkingList[index]['distanceKm'] as double?;

                  return GestureDetector(
                    onTap: () {

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ParkingDetailsScreen(
                            imageUrl: data['image_url'] ?? '',
                            title: data['Parking name'] ?? '',
                            price: "${data['Parking Pricing (per hour)'] ?? 0}",
                            rating: "4.5",
                            distance: distanceKm != null
                                ? "${distanceKm.toStringAsFixed(2)} km"
                                : "N/A",
                            spots: "${data['Parking Capacity'] ?? 0} spots",
                            description: data['Parking Description'] ?? '',
                            access24: data['Access'] ?? false,
                            cctv: data['CCTV'] ?? false,
                            evCharging: data['EV Charging'] ?? false,
                            disabledAccess: data['Disabled Access'] ?? false,
                            owneremail:data['owner email']??"hahsha@gm.com",
                            parkinguid: data['parking uid'] ,


                          ),

                        ),

                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: ParkingCard(
                        imageUrl: data['image_url'] ?? '',
                        title: data['Parking name'] ?? '',
                        price: "${data['Parking Pricing (per hour)'] ?? 0} JD",
                        spots: "${data['Parking Capacity'] ?? 0} spots",
                        distanceKm: distanceKm,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),

      ],
    );
  }

  // Screens for each tab
  late final List<Widget> _screens = [
    _buildHomeTab(),
    const MyBookingsScreen(),
    const UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor:Colors.white70 ,
      // Remove backgroundColor and use a gradient container
      body: Container(
        decoration: BoxDecoration(color: Colors.white10,
          // gradient: LinearGradient(
          //   colors: Colors.white70,
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
        ),
        child: Column(
          children: [
            // Custom AppBar with gradient
            AppBar(
              elevation: 0,
              backgroundColor:  Color(0xFF36D1DC),
              title: Text(
                _selectedIndex == 0
                    ? "Parking is waiting for you"
                    : _selectedIndex == 1
                    ? "My Bookings"
                    : "Profile",
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: appGradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              actions: [
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    double money = 0.0;

                    if (snapshot.hasData && snapshot.data!.exists) {
                      // Convert snapshot to map safely
                      Map<String, dynamic>? data =
                      snapshot.data!.data() as Map<String, dynamic>?;

                      if (data != null && data.containsKey('money')) {
                        money = (data['money'] ?? 0).toDouble();
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Center(
                        child: Row(
                          children: [
                            const Icon(Icons.account_balance_wallet, color: Colors.white),
                            const SizedBox(width: 6),
                            Text(
                              "${money.toStringAsFixed(2)} JD",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16,color:Colors.white),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),


              ],
            ),

            // Display the correct screen
            Expanded(child: _screens[_selectedIndex]),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white70,
          gradient: LinearGradient(
            colors: appGradientColors, // same as Scaffold/AppBar
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent, // transparent to show gradient
          currentIndex: _selectedIndex,
          selectedItemColor:Color(0xFF36D1DC),
          unselectedItemColor: Colors.white,

          onTap: _onItemTapped,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: "Bookings"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),

    );
  }

}

// Parking Card Widget
class ParkingCard extends StatelessWidget {
  final String imageUrl, title, price, spots;
  final double? distanceKm;

  const ParkingCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.spots,
    this.distanceKm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.network(imageUrl,
                height: 120, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(
                    "$price • $spots • ${distanceKm != null ? distanceKm!.toStringAsFixed(2) + ' km' : '...'}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
