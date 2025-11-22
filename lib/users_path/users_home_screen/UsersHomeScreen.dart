
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';

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
Set<Marker> _markers = {};

@override
void initState() {
super.initState();
_getUserLocation();
}

// ✅ SAFE & STABLE LOCATION FETCH
Future<void> _getUserLocation() async {
Location location = Location();

bool serviceEnabled = await location.serviceEnabled();
if (!serviceEnabled) {
serviceEnabled = await location.requestService();
if (!serviceEnabled) return;
}

PermissionStatus permissionGranted = await location.hasPermission();
if (permissionGranted == PermissionStatus.denied) {
permissionGranted = await location.requestPermission();
if (permissionGranted != PermissionStatus.granted) return;
}

final locData = await location.getLocation();

if (locData.latitude == null || locData.longitude == null) return;

final position = LatLng(locData.latitude!, locData.longitude!);

setState(() {
_userLocation = position;
});

_mapController?.animateCamera(
CameraUpdate.newLatLngZoom(position, 16),
);

_loadNearbyGarages();
}

// ✅ LOAD PARKING MARKERS
void _loadNearbyGarages() async {
final snapshot = await FirebaseFirestore.instance
    .collectionGroup('Owners Parking')
    .get();

final filteredMarkers = snapshot.docs.map((doc) {
final data = doc.data();

final String name = (data['Parking name'] ?? '').toString().toLowerCase();
final String locationName = (data['location'] ?? '').toString().toLowerCase();

if (searchQuery.isNotEmpty &&
!name.contains(searchQuery) &&
!locationName.contains(searchQuery)) {
return null;
}

final double lat = double.tryParse(data['latitude']?.toString() ?? '') ?? 0.0;
final double lng = double.tryParse(data['longitude']?.toString() ?? '') ?? 0.0;

return Marker(
markerId: MarkerId(doc.id),
position: LatLng(lat, lng),
infoWindow: InfoWindow(
title: data['Parking name'] ?? 'Unknown',
snippet: '${data['Parking Capacity'] ?? 0} spots',
),
);
}).whereType<Marker>().toSet();

setState(() {
_markers = filteredMarkers;
});
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
// 🔍 SEARCH BAR
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
_loadNearbyGarages();
},
),
),

// 🗺️ GOOGLE MAP (NO MORE SPINNING)
Expanded(
flex: 2,
child: GoogleMap(
initialCameraPosition: CameraPosition(
target: _userLocation ?? const LatLng(31.9539, 35.9106), // Amman fallback
zoom: 15,
),
myLocationEnabled: true,
myLocationButtonEnabled: true,
markers: _markers,
onMapCreated: (controller) {
_mapController = controller;
if (_userLocation != null) {
controller.animateCamera(
CameraUpdate.newLatLngZoom(_userLocation!, 16),
);
}
},
gestureRecognizers: {
Factory<OneSequenceGestureRecognizer>(
() => EagerGestureRecognizer()),
},
),
),

// 📍 PARKING LIST
Expanded(
flex: 3,
child: StreamBuilder<QuerySnapshot>(
stream: FirebaseFirestore.instance
    .collectionGroup('Owners Parking')
    .snapshots(),
builder: (context, snapshot) {
if (!snapshot.hasData) {
return const Center(child: CircularProgressIndicator());
}

final docs = snapshot.data!.docs.where((doc) {
final data = doc.data() as Map<String, dynamic>;
final name = (data['Parking name'] ?? '')
    .toString()
    .toLowerCase();
return name.contains(searchQuery);
}).toList();

if (docs.isEmpty) {
return const Center(child: Text("No parking lots found"));
}

return ListView.builder(
padding: const EdgeInsets.all(16),
itemCount: docs.length,
itemBuilder: (context, index) {
final data = docs[index].data() as Map<String, dynamic>;

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
distance: "N/A",
spots:
"${data['Parking Capacity'] ?? 0} spots",
description:
data['Parking Description'] ?? '',
access24: data['Access'] ?? false,
cctv: data['CCTV'] ?? false,
evCharging: data['EV Charging'] ?? false,
disabledAccess:
data['Disabled Access'] ?? false,
),
),
);
},
child: ParkingCard(
imageUrl: data['image_url'] ?? '',
title: data['Parking name'] ?? '',
price:
"${data['Parking Pricing (per hour)'] ?? 0} JD",
distance: "Nearby",
rating: "4.5",
spots:
"${data['Parking Capacity'] ?? 0} spots",
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

// ✅ PARKING CARD
class ParkingCard extends StatelessWidget {
final String imageUrl, title, price, distance, rating, spots;

const ParkingCard({
super.key,
required this.imageUrl,
required this.title,
required this.price,
required this.distance,
required this.rating,
required this.spots,
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
Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
const SizedBox(height: 6),
Text("$price • $spots"),
],
),
),
],
),
);
}
}

