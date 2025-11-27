import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_park_jo/users_path/parking_details_screen/parkingDetailsScreen.dart';
import 'package:smart_park_jo/users_path/users_home_screen/UsersHomeScreen.dart';

class letspark extends StatefulWidget {
  const letspark({super.key});

  @override
  State<letspark> createState() => _letsparkState();
}

class _letsparkState extends State<letspark> {
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

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey, Color(0xFF36D1DC),Colors.grey,],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        "Let’s Park!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Floating search bar
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(20),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by location or name...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 16),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value.toLowerCase();
                        });
                      },
                    ),
                  ),
                ),

                // Map
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      height: 300,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collectionGroup('Owners Parking')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          Set<Marker> markers = {};
                          Set<Circle> circles = {};
                          LatLng? center;

                          for (var doc in snapshot.data!.docs) {
                            final data = doc.data() as Map<String, dynamic>;
                            final locationMap =
                            data['location'] as Map<String, dynamic>?;
                            if (locationMap == null) continue;

                            final lat =
                            (locationMap['latitude'] ?? 0.0).toDouble();
                            final lng =
                            (locationMap['longitude'] ?? 0.0).toDouble();
                            if (lat == 0.0 && lng == 0.0) continue;

                            final position = LatLng(lat, lng);
                            center ??= position;

                            markers.add(Marker(
                              markerId: MarkerId(doc.id),
                              position: position,
                              infoWindow: InfoWindow(
                                title: data['Parking name'] ?? 'Parking',
                                snippet:
                                "${data['Parking Capacity'] ?? 0} spots",
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

                          // make the map center is parking
                          // if (_mapController != null && center != null && !_cameraMoved) {
                          //   _mapController!.animateCamera(
                          //     CameraUpdate.newLatLngZoom(center, 15.5),
                          //   );
                          //   _cameraMoved = true;
                          // }

                          // make the map center is user location
                          if (_mapController != null && !_cameraMoved) {
                            final target = _userLocation ?? center;

                            if (target != null) {
                              _mapController!.animateCamera(
                                CameraUpdate.newLatLngZoom(target, 15.5),
                              );
                              _cameraMoved = true;
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
                            onMapCreated: (controller) =>
                            _mapController = controller,
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // Parking list
                Expanded(
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

                        final name = (data['Parking name'] ?? '').toString().toLowerCase();
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
                                    owneremail: data['owner email'] ?? "test@gm.com",
                                    parkinguid: data['parking uid'],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Parking Image
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      bottomLeft: Radius.circular(16),
                                    ),
                                    child: Image.network(
                                      data['image_url'] ?? '',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Container(
                                            color: Colors.grey[200],
                                            width: 100,
                                            height: 100,
                                            child: const Icon(Icons.local_parking, color: Colors.grey),
                                          ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Parking Info
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data['Parking name'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "${data['Parking Capacity'] ?? 0} spots • ${distanceKm?.toStringAsFixed(2) ?? 'N/A'} km away",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "${data['Parking Pricing (per hour)'] ?? 0} JD / hour",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
