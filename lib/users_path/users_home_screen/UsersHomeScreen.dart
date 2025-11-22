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
      price: "${data['Parking Pricing (per hour)']} JD",
      rating: "4.5", // Temporary until you add a rating field
      distance: "N/A", // You don't store distance yet
      spots: "${data['Parking Capacity']} spots",
      description: data["Parking Description"] ?? "No description provided",
      access24: data["Access"] ?? false,
      cctv: data["CCTV"] ?? false,
      evCharging: data["EV Charging"] ?? false,
      disabledAccess: data["Disabled Access"] ?? false,
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
