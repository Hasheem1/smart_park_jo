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
    switch (index) {
      case 0:
        setState(() => _selectedIndex = index);
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const MyBookingsScreen()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const UserProfileScreen()));
        break;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose(); // Dispose map controller safely
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Find Parking",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
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
                    fillColor: Colors.red.withOpacity(0.3),
                    strokeColor: Colors.red,
                    strokeWidth: 2,
                  ));
                }

                // Animate camera safely only once
                if (_mapController != null && center != null && !_cameraMoved) {
                  try {
                    _mapController!.animateCamera(
                      CameraUpdate.newLatLngZoom(center, 16),
                    );
                    _cameraMoved = true;
                  } catch (e) {
                    debugPrint('Map controller disposed: $e');
                  }
                }

                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: center ?? LatLng(0, 0), zoom: 16),
                  markers: markers,
                  circles: circles,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onMapCreated: (controller) => _mapController = controller,
                  gestureRecognizers: {
                    Factory<OneSequenceGestureRecognizer>(
                            () => EagerGestureRecognizer())
                  },
                );
              },
            ),
          ),

          // Parking List sorted by distance
          Expanded(
            flex: 1,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collectionGroup('Owners Parking')
                  .snapshots(),
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

                  final name =
                  (data['Parking name'] ?? '').toString().toLowerCase();
                  if (!name.contains(searchQuery)) continue;

                  parkingList.add({
                    'doc': doc,
                    'data': data,
                    'distanceKm': distanceKm,
                  });
                }

                parkingList.sort(
                        (a, b) => a['distanceKm'].compareTo(b['distanceKm']));

                if (parkingList.isEmpty) {
                  return const Center(child: Text("No parking lots found"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: parkingList.length,
                  itemBuilder: (context, index) {
                    final data = parkingList[index]['data'] as Map<String, dynamic>;
                    final distanceKm =
                    parkingList[index]['distanceKm'] as double?;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ParkingDetailsScreen(
                              imageUrl: data['image_url'] ?? '',
                              title: data['Parking name'] ?? '',
                              price:
                              "${data['Parking Pricing (per hour)'] ?? 0} JD",
                              rating: "4.5",
                              distance: distanceKm != null
                                  ? "${distanceKm.toStringAsFixed(2)} km"
                                  : "N/A",
                              spots: "${data['Parking Capacity'] ?? 0} spots",
                              description:
                              data['Parking Description'] ?? '',
                              access24: data['Access'] ?? false,
                              cctv: data['CCTV'] ?? false,
                              evCharging: data['EV Charging'] ?? false,
                              disabledAccess: data['Disabled Access'] ?? false,
                            ),
                          ),
                        );
                      },
                      child: ParkingCard(
                        imageUrl: data['image_url'] ?? '',
                        title: data['Parking name'] ?? '',
                        price: "${data['Parking Pricing (per hour)'] ?? 0} JD",
                        spots: "${data['Parking Capacity'] ?? 0} spots",
                        distanceKm: distanceKm,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: primaryBlue,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Bookings"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
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
