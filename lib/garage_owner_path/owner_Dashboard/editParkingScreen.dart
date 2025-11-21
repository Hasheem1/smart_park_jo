import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'mapPickerScreen.dart';

class EditParkingScreen extends StatefulWidget {
  final Map<String, dynamic> parkingData;
  final String parkingId;

  const EditParkingScreen({required this.parkingData, required this.parkingId, super.key});

  @override
  State<EditParkingScreen> createState() => _EditParkingScreenState();
}

class _EditParkingScreenState extends State<EditParkingScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _capacityController;
  late TextEditingController _priceController;
  late TextEditingController _locationController;

  bool access24 = false;
  bool cctv = false;
  bool evCharging = false;
  bool disabledAccess = false;

  File? _image;
  final ImagePicker _picker = ImagePicker();
  LatLng? _pickedLocation;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.parkingData['Parking name']);
    _descController = TextEditingController(text: widget.parkingData['Parking Description']);
    _capacityController =
        TextEditingController(text: widget.parkingData['Parking Capacity'].toString());
    _priceController =
        TextEditingController(text: widget.parkingData['Parking Pricing (per hour)'].toString());
    _locationController = TextEditingController(
      text: widget.parkingData['location'] != null
          ? "Lat: ${widget.parkingData['location']['latitude']}, Lng: ${widget.parkingData['location']['longitude']}"
          : "",
    );

    access24 = widget.parkingData["24/7 Access"] ?? false;
    cctv = widget.parkingData["CCTV"] ?? false;
    evCharging = widget.parkingData["EV Charging"] ?? false;
    disabledAccess = widget.parkingData["Disabled Access"] ?? false;

    if (widget.parkingData['location'] != null) {
      _pickedLocation = LatLng(widget.parkingData['location']['latitude'],
          widget.parkingData['location']['longitude']);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) setState(() => _image = File(pickedFile.path));
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final email = FirebaseAuth.instance.currentUser!.email!;
      final ref = FirebaseStorage.instance
          .ref()
          .child("owners/$email/parking_images/${widget.parkingId}.jpg");
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

  Future<void> updateParking() async {
    if (_nameController.text.isEmpty ||
        _capacityController.text.isEmpty ||
        _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please fill all required fields")));
      return;
    }


    String? imageUrl = widget.parkingData['image_url'];
    if (_image != null) {
      String? uploadedUrl = await _uploadImage(_image!);
      if (uploadedUrl != null) imageUrl = uploadedUrl;
    }

    final email = FirebaseAuth.instance.currentUser!.email!;
    final docRef = FirebaseFirestore.instance
        .collection('owners')
        .doc(email)
        .collection('Owners Parking')
        .doc(widget.parkingId);

    try {
      await docRef.update({
        'Parking name': _nameController.text,
        'Parking description': _descController.text,
        'Parking Pricing (per hour)': double.parse(_priceController.text),
        'Parking Capacity': int.parse(_capacityController.text),


        'Access': access24,
        'cctv': cctv,
        'EV Charging': evCharging,
        'Disabled Access': disabledAccess,
        'image_url': imageUrl,
        'location': _pickedLocation != null
            ? {'latitude': _pickedLocation!.latitude, 'longitude': _pickedLocation!.longitude}
            : widget.parkingData['location'],
      });


      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Parking updated successfully!")));

      Navigator.pop(context, true); // Return true to refresh dashboard
    } catch (e) {
      print("Update failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Update failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Parking")),
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
                  image: _image != null
                      ? DecorationImage(image: FileImage(_image!), fit: BoxFit.cover)
                      : widget.parkingData['image_url'] != null
                      ? DecorationImage(
                      image: NetworkImage(widget.parkingData['image_url']),
                      fit: BoxFit.cover)
                      : null,
                ),
                child: _image == null && widget.parkingData['image_url'] == null
                    ? const Center(child: Icon(Icons.add_a_photo_outlined, size: 50, color: Colors.white))
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(_nameController, "Parking Name", Icons.local_parking_rounded),
            _buildTextField(_descController, "Description", Icons.text_fields_outlined),
            _buildTextField(_locationController, "Location", Icons.location_on_outlined,
                readOnly: true, onTap: _pickLocationOnMap),
            _buildTextField(_capacityController, "Capacity", Icons.people_outline,
                inputType: TextInputType.number),
            _buildTextField(_priceController, "Price per hour", Icons.attach_money_outlined,
                inputType: TextInputType.numberWithOptions(decimal: true)),
            const SizedBox(height: 20),
            _buildCheckbox("24/7 Access", access24, (v) => setState(() => access24 = v!)),
            _buildCheckbox("CCTV", cctv, (v) => setState(() => cctv = v!)),
            _buildCheckbox("EV Charging", evCharging, (v) => setState(() => evCharging = v!)),
            _buildCheckbox("Disabled Access", disabledAccess, (v) => setState(() => disabledAccess = v!)),
            const SizedBox(height: 25),
            ElevatedButton(onPressed: updateParking, child: const Text("Save Changes")),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {TextInputType inputType = TextInputType.text, bool readOnly = false, VoidCallback? onTap}) {
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

  Widget _buildCheckbox(String title, bool value, ValueChanged<bool?> onChanged) {
    return CheckboxListTile(title: Text(title), value: value, onChanged: onChanged);
  }
}
