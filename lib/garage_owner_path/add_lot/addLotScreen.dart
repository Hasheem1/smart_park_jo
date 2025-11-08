import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddParkingLotScreen extends StatefulWidget {
  const AddParkingLotScreen({super.key});

  @override
  State<AddParkingLotScreen> createState() => _AddParkingLotScreenState();
}

class _AddParkingLotScreenState extends State<AddParkingLotScreen>
    with SingleTickerProviderStateMixin {
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

  AnimationController? _animationController;
  Animation<double>? _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim =
        CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut);
    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF2F66F5);
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
              // 📸 Image Picker with gradient border
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 190,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: _image == null ? gradient : null,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
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

              // 🧾 Info Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildTextField(
                        _nameController,
                        "Parking Lot Name",
                        Icons.local_parking_rounded,
                      ),
                      _buildTextField(
                        _descController,
                        "Description",
                        Icons.text_fields_outlined,
                      ),
                      _buildTextField(
                        _locationController,
                        "Location Address",
                        Icons.location_on_outlined,
                      ),
                      _buildTextField(
                        _capacityController,
                        "Capacity",
                        Icons.people_outline,
                        inputType: TextInputType.number,
                      ),
                      _buildTextField(
                        _priceController,
                        "Pricing (per hour)",
                        Icons.attach_money_outlined,
                        inputType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ⚙️ Features Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(14),
                      child: Text(
                        "Features",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    _buildCheckbox("24/7 Access - متاح 24/7",
                        Icons.access_time_rounded, access24, (v) => access24 = v!),
                    _buildCheckbox("CCTV Security - كاميرات مراقبة",
                        Icons.videocam_outlined, cctv, (v) => cctv = v!),
                    _buildCheckbox("EV Charging - شحن كهربائي",
                        Icons.ev_station_outlined, evCharging, (v) => evCharging = v!),
                    _buildCheckbox("Disabled Access - مواقف ذوي الإعاقة",
                        Icons.accessible_rounded, disabledAccess, (v) => disabledAccess = v!),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // 🚀 Modern Submit Button with gradient
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    print("Parking Added:");
                    print("Name: ${_nameController.text}");
                    print("Desc: ${_descController.text}");
                    print("Location: ${_locationController.text}");
                    print("Capacity: ${_capacityController.text}");
                    print("Price: ${_priceController.text}");
                  },
                  icon: const Icon(Icons.add_location_alt_outlined, size: 22),
                  label: const Text(
                    "Add Parking",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5),
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
      {TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF2F66F5)),
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          filled: true,
          fillColor: const Color(0xFFF7F9FC),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF2F66F5), width: 1.8),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(
      String title, IconData icon, bool value, ValueChanged<bool?> onChanged) {
    return CheckboxListTile(
      title: Text(title, style: const TextStyle(fontSize: 15.5)),
      secondary: Icon(icon, color: const Color(0xFF2F66F5)),
      value: value,
      onChanged: (v) => setState(() => onChanged(v)),
      activeColor: const Color(0xFF2F66F5),
      checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14),
    );
  }
}
