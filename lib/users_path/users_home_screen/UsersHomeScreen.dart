import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_park_jo/users_path/bookings/bookingsScreen.dart';
import 'package:smart_park_jo/users_path/parking_details_screen/parkingDetailsScreen.dart';
import 'package:smart_park_jo/users_path/users%20profile/usersProfileScreen.dart';
import 'package:smart_park_jo/users_path/users_home_screen/UsersHomeScreen.dart';
import '../../ai_chat_bot/chatBot.dart';
import 'letsPark.dart';

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
  bool _cameraMoved = false;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

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

  double _calculateDistanceKm(LatLng start, LatLng end) {
    return Geolocator.distanceBetween(
        start.latitude, start.longitude, end.latitude, end.longitude) /
        1000;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            // 🌟 Modern Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: _modernHeader(context),
            ),

            // 🌟 Map and Home Tab
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: background,
                ),
                child: _buildHomeTab(),
              ),
            ),

            // 🌟 Bottom Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: _modernActions(context),
            ),
          ],
        ),
      ),
    );
  }

  // 🌟 Modern header with gradient & shadow
  Widget _modernHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Park with a Smile 😄",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.smart_toy_outlined, color: Colors.white),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChatScreen()),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.account_circle, color: Colors.white),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UserProfileScreen()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🌟 Bottom action buttons
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

  // 🌟 Action card style
  Widget _actionCard(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: onTap,
          child: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF36D1DC), Color(0xFF5B86E5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
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
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🌟 Home tab with map
  Widget _buildHomeTab() {
    return Column(
      children: [
        // Google Map
        Expanded(
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
                  radius: 60,
                  fillColor: Colors.red.withOpacity(0.25),
                  strokeColor: Colors.redAccent,
                  strokeWidth: 2,
                ));
              }

              if (_mapController != null && center != null && !_cameraMoved) {
                try {
                  _mapController!.animateCamera(
                    CameraUpdate.newLatLngZoom(center, 15.5),
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
              );
            },
          ),
        ),
      ],
    );
  }
}
