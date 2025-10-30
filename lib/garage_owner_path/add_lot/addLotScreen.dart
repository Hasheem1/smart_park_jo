import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddParkingLotScreen extends StatefulWidget {
  const AddParkingLotScreen({super.key});

  @override
  State<AddParkingLotScreen> createState() => _AddParkingLotScreenState();
}

class _AddParkingLotScreenState extends State<AddParkingLotScreen> {
  File? _image;
  final picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  bool access24 = false;
  bool cctv = false;
  bool evCharging = false;
  bool disabledAccess = false;

  Future<void> _pickImage() async {
    final pickedFile =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Parking Lot"),
        backgroundColor: const Color(0xFF2F66F5),

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼 Parking Image
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade400),
                  image: _image != null
                      ? DecorationImage(
                    image: FileImage(_image!),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: _image == null
                    ? const Center(
                  child: Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                )
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            // 🏷 Name
            _buildTextField(_nameController, "Parking Lot Name"),
            _buildTextField(_descController, "Description"),
            _buildTextField(_locationController, "Location Address"),
            _buildTextField(_capacityController, "Capacity", inputType: TextInputType.number),
            _buildTextField(_priceController, "Pricing (per hour)", inputType: TextInputType.number),

            const SizedBox(height: 20),
            const Text("Features", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            CheckboxListTile(
              title: const Text("24/7 Access - متاح 24/7"),
              value: access24,
              onChanged: (v) => setState(() => access24 = v!),
            ),
            CheckboxListTile(
              title: const Text("CCTV Security - كاميرات مراقبة"),
              value: cctv,
              onChanged: (v) => setState(() => cctv = v!),
            ),
            CheckboxListTile(
              title: const Text("EV Charging - شحن كهربائي"),
              value: evCharging,
              onChanged: (v) => setState(() => evCharging = v!),
            ),
            CheckboxListTile(
              title: const Text("Disabled Access - مواقف ذوي الإعاقة"),
              value: disabledAccess,
              onChanged: (v) => setState(() => disabledAccess = v!),
            ),

            const SizedBox(height: 20),

            // 🔘 Add Parking Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F66F5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  // You can handle saving data here (locally or print to console)
                  print("Parking Added:");
                  print("Name: ${_nameController.text}");
                  print("Desc: ${_descController.text}");
                  print("Location: ${_locationController.text}");
                  print("Capacity: ${_capacityController.text}");
                  print("Price: ${_priceController.text}");
                },
                child: const Text(
                  "Add Parking",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
