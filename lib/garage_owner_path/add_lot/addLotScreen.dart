import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';

class AddParkingLotScreen extends StatefulWidget {
  const AddParkingLotScreen({super.key});

  @override
  State<AddParkingLotScreen> createState() => _AddParkingLotScreenState();
}

class _AddParkingLotScreenState extends State<AddParkingLotScreen>
    with SingleTickerProviderStateMixin {
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  // Firebase
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String? userEmail = FirebaseAuth.instance.currentUser?.email;

  // Features
  bool access24 = false;
  bool cctv = false;
  bool evCharging = false;
  bool disabledAccess = false;

  // Animation
  AnimationController? _animationController;
  Animation<double>? _fadeAnim;

  // Image
  File? _image;
  final picker = ImagePicker();

  // Location
  LatLng? _pickedLocation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim = CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut);
    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  // Pick Image
  Future<void> _pickImage() async {
    final pickedFile =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Upload Image
  Future<String?> uploadImage(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("parking_images")
          .child("${DateTime.now().millisecondsSinceEpoch}.jpg");

      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Image upload failed: $e");
      return null;
    }
  }

  // Add Parking to Firestore
  Future<void> addParking() async {
    try {
      String? imageUrl;
      if (_image != null) {
        imageUrl = await uploadImage(_image!);
      }

      Map<String, dynamic> parkingData = {
        'Parking name': _nameController.text,
        'Parking Description': _descController.text,
        'Parking Capacity': _capacityController.text,
        'Parking Pricing (per hour)': _priceController.text,
        "24/7 Access": access24,
        "CCTV": cctv,
        "EV Charging": evCharging,
        "Disabled Access": disabledAccess,
        "image_url": imageUrl,
        "location": _pickedLocation != null
            ? {
          "latitude": _pickedLocation!.latitude,
          "longitude": _pickedLocation!.longitude
        }
            : null,
        'created_at': DateTime.now(),
      };

      final parkingCollection = firestore
          .collection('owners')
          .doc(userEmail)
          .collection('Owners Parking');

      final snapshot = await parkingCollection.get();
      int count = snapshot.docs.length;

      await parkingCollection.doc("Parking ${count + 1}").set(parkingData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Parking Added Successfully")),
      );

      // Clear fields
      _nameController.clear();
      _descController.clear();
      _locationController.clear();
      _capacityController.clear();
      _priceController.clear();
      setState(() {
        _image = null;
        _pickedLocation = null;
      });
    } catch (e) {
      print("Error adding parking: $e");
    }
  }

  // Open Map Picker
  Future<void> _pickLocationOnMap() async {
    final selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapPickerScreen(
          initialLocation: _pickedLocation,
          initialPlaceName: _locationController.text,
        ),
      ),
    );
    if (selectedLocation != null) {
      setState(() {
        _pickedLocation = selectedLocation;
        _locationController.text =
        "Lat: ${selectedLocation.latitude}, Lng: ${selectedLocation.longitude}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      colors: [Color(0xFF2F66F5), Color(0xFF00A6FF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text(
          "Add Parking Lot",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnim ?? AlwaysStoppedAnimation(1.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // IMAGE PICKER
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 190,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: _image == null ? gradient : null,
                    borderRadius: BorderRadius.circular(20),
                    image: _image != null
                        ? DecorationImage(
                      image: FileImage(_image!),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: _image == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add_a_photo_outlined,
                          size: 50, color: Colors.white),
                      SizedBox(height: 10),
                      Text("Upload Parking Image",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                    ],
                  )
                      : Stack(
                    children: [
                      Positioned(
                        right: 10,
                        top: 10,
                        child: CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: IconButton(
                            icon: const Icon(Icons.edit,
                                color: Colors.white, size: 20),
                            onPressed: _pickImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // INFO SECTION
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    _buildTextField(_nameController, "Parking Lot Name",
                        Icons.local_parking_rounded),
                    _buildTextField(
                        _descController, "Description", Icons.text_fields_outlined),
                    _buildTextField(
                      _locationController,
                      "Place Name / Location",
                      Icons.location_on_outlined,
                      readOnly: true,
                      onTap: _pickLocationOnMap,
                    ),
                    _buildTextField(_capacityController, "Capacity",
                        Icons.people_outline,
                        inputType: TextInputType.number),
                    _buildTextField(_priceController, "Pricing (per hour)",
                        Icons.attach_money_outlined,
                        inputType: TextInputType.number),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // FEATURES SECTION
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(14),
                      child: Text(
                        "Features",
                        style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                    ),
                    _buildCheckbox(
                        "24/7 Access", Icons.access_time_rounded, access24,
                            (v) => access24 = v!),
                    _buildCheckbox(
                        "CCTV Security", Icons.videocam_outlined, cctv,
                            (v) => cctv = v!),
                    _buildCheckbox(
                        "EV Charging", Icons.ev_station_outlined, evCharging,
                            (v) => evCharging = v!),
                    _buildCheckbox(
                        "Disabled Access", Icons.accessible_rounded, disabledAccess,
                            (v) => disabledAccess = v!),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // SUBMIT BUTTON
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent),
                  onPressed: addParking,
                  icon: const Icon(Icons.add_location_alt_outlined, size: 22),
                  label: const Text(
                    "Add Parking",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {TextInputType inputType = TextInputType.text,
        bool readOnly = false,
        VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF2F66F5)),
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFF7F9FC),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget _buildCheckbox(
      String title, IconData icon, bool value, ValueChanged<bool?> onChanged) {
    return CheckboxListTile(
      title: Text(title),
      secondary: Icon(icon, color: const Color(0xFF2F66F5)),
      value: value,
      onChanged: (v) => setState(() => onChanged(v)),
    );
  }
}

// MAP PICKER SCREEN
class MapPickerScreen extends StatefulWidget {
  final LatLng? initialLocation;
  final String? initialPlaceName;
  const MapPickerScreen({super.key, this.initialLocation, this.initialPlaceName});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng? pickedLocation;
  LatLng? currentLocation;
  bool loading = true;
  GoogleMapController? _controller;

  @override
  void initState() {
    super.initState();
    pickedLocation = widget.initialLocation;
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled')));
      setState(() => loading = false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied')));
        setState(() => loading = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are permanently denied')));
      setState(() => loading = false);
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
      if (pickedLocation == null) pickedLocation = currentLocation;
      loading = false;
    });

    // Move pin if place name is provided
    if (widget.initialPlaceName != null && widget.initialPlaceName!.isNotEmpty) {
      await movePinToAddress(widget.initialPlaceName!);
    }
  }

  Future<void> movePinToAddress(String placeName) async {
    try {
      List<Location> locations = await locationFromAddress(placeName);
      if (locations.isNotEmpty) {
        LatLng target = LatLng(locations[0].latitude, locations[0].longitude);
        setState(() {
          pickedLocation = target;
        });
        if (_controller != null) {
          _controller!.animateCamera(CameraUpdate.newLatLng(target));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not find location: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick Parking Location"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (pickedLocation != null) {
                Navigator.pop(context, pickedLocation);
              }
            },
          )
        ],
      ),
      body: GoogleMap(
        onMapCreated: (controller) => _controller = controller,
        initialCameraPosition: CameraPosition(
            target: pickedLocation ?? currentLocation!, zoom: 16),
        onTap: (LatLng latLng) {
          setState(() {
            pickedLocation = latLng;
          });
        },
        markers: pickedLocation != null
            ? {Marker(markerId: const MarkerId("picked"), position: pickedLocation!)}
            : {},
      ),
    );
  }
}
