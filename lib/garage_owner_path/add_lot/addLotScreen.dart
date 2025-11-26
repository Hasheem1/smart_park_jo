import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../owner_Dashboard/mapPickerScreen.dart';

class AddParkingLotScreen extends StatefulWidget {
  const AddParkingLotScreen({super.key});

  @override
  State<AddParkingLotScreen> createState() => _AddParkingLotScreenState();
}

class _AddParkingLotScreenState extends State<AddParkingLotScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  bool access24 = false;
  bool cctv = false;
  bool evCharging = false;
  bool disabledAccess = false;
  bool washCar = false;


  File? _image;
  final ImagePicker _picker = ImagePicker();
  LatLng? _pickedLocation;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String? userEmail = FirebaseAuth.instance.currentUser?.email;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) setState(() => _image = File(pickedFile.path));
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(
        "owners/$userEmail/parking_images/${DateTime.now().millisecondsSinceEpoch}.jpg",
      );
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Image upload failed: $e");
      return null;
    }
  }

  Future<void> _pickLocationOnMap() async {
    final selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => MapPickerScreen(
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

  Future<void> addParking() async {
    if (_nameController.text.isEmpty ||
        _capacityController.text.isEmpty ||
        _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    String? imageUrl;
    if (_image != null) imageUrl = await _uploadImage(_image!);

    final parkingCollection = firestore
        .collection('owners')
        .doc(userEmail)
        .collection('Owners Parking');

    final parkingDoc = parkingCollection.doc();
    int capacity = int.parse(_capacityController.text);

    List<Map<String, dynamic>> spots = List.generate(capacity, (index) {
      return {
        "id": "A${(index + 1).toString().padLeft(2, '0')}",
        "status": "Available",
      };
    });

    Map<String, dynamic> parkingData = {
      'parking uid':parkingDoc.id,
      'owner email':userEmail,
      'Parking name': _nameController.text,
      'Parking Description': _descController.text,
      'Parking Capacity': int.parse(_capacityController.text),
      'Parking Pricing (per hour)': double.parse(_priceController.text),
      'Access': access24,
      'CCTV': cctv,
      'EV Charging': evCharging,
      'Disabled Access': disabledAccess,
      'washCar':washCar,
      'image_url': imageUrl,
      'spots': spots,
      'location':
          _pickedLocation != null
              ? {
                'latitude': _pickedLocation!.latitude,
                'longitude': _pickedLocation!.longitude,
              }
              : null,
      'created_at': DateTime.now(),
    };

    await parkingDoc.set(parkingData);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Parking Added Successfully")));

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Parking Lot")
      ,        centerTitle: true, // <-- This centers the title
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(16),
                  image:
                      _image != null
                          ? DecorationImage(
                            image: FileImage(_image!),
                            fit: BoxFit.cover,
                          )
                          : null,
                ),
                child:
                    _image == null
                        ? const Center(
                          child: Icon(
                            Icons.add_a_photo_outlined,
                            size: 50,
                            color: Colors.white,
                          ),
                        )
                        : null,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              _nameController,
              "Parking Name",
              Icons.local_parking_rounded,
            ),
            _buildTextField(
              _descController,
              "Description",
              Icons.text_fields_outlined,
            ),
            _buildLocationField(), // Modern location picker with map preview
            const SizedBox(height: 16),
            _buildTextField(
              _capacityController,
              "Capacity",
              Icons.people_outline,
              inputType: TextInputType.number,
            ),
            _buildTextField(
              _priceController,
              "Price per hour",
              Icons.attach_money_outlined,
              inputType: TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 20),
            _buildCheckbox(
              "24/7 Access",
              access24,
              (v) => setState(() => access24 = v!),
            ),
            _buildCheckbox("CCTV", cctv, (v) => setState(() => cctv = v!)),
            _buildCheckbox(
              "EV Charging",
              evCharging,
              (v) => setState(() => evCharging = v!),
            ),
            _buildCheckbox(
              "Disabled Access",
              disabledAccess,
                  (v) => setState(() => disabledAccess = v!),
            ),
            _buildCheckbox(
              "Car Washing",
              washCar,
                  (v) => setState(() => washCar = v!),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: addParking,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                elevation: 8,
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.add_location_alt_outlined),
                  SizedBox(width: 8),
                  Text("Add Parking"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Widgets ----------------

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType inputType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget _buildCheckbox(
    String title,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildLocationField() {
    return GestureDetector(
      onTap: _pickLocationOnMap,
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blueAccent, width: 1.5),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on, size: 36, color: Colors.blueAccent),
            const SizedBox(width: 12),
            Expanded(
              child:
                  _pickedLocation == null
                      ? const Text(
                        "Pick parking location",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueAccent,
                        ),
                      )
                      : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          height: 100,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: _pickedLocation!,
                              zoom: 15,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId('picked'),
                                position: _pickedLocation!,
                              ),
                            },
                            zoomControlsEnabled: false,
                            scrollGesturesEnabled: false,
                            tiltGesturesEnabled: false,
                            rotateGesturesEnabled: false,
                          ),
                        ),
                      ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: const Text(
                "Pick",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
