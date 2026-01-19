
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Userdetails extends StatefulWidget {
  const Userdetails({super.key});

  @override
  State<Userdetails> createState() => _UserdetailsState();
}

class _UserdetailsState extends State<Userdetails> {
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user;
  Map<String, dynamic> userData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user!.uid).get();
      if (doc.exists) {
        userData = doc.data()!;
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> updateField(String field, String newValue) async {
    if (user == null) return;

    try {
      // 1️⃣ Update Firestore
      await _firestore.collection('users').doc(user!.uid).update({
        field: newValue,
      });

      // 2️⃣ Update Firebase Auth password if needed
      if (field == "password") {
        await user!.updatePassword(newValue);
      }

      // 3️⃣ Update local state AFTER everything is done
      setState(() {
        userData[field] = newValue; // Now password shows immediately too
      });

      // ✅ Show elegant snackbar (success)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text("Updated successfully!")),
            ],
          ),
          backgroundColor: const Color(0xFF4CAF50),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // ❌ Error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text("Failed to update, try again.")),
            ],
          ),
          backgroundColor: const Color(0xFFF44336),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }



  void showEditDialog(String field, String oldValue) {
    final TextEditingController controller =
    TextEditingController(text: oldValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Update $field",
          style: const TextStyle(
            color: Color(0XFF2F66F5),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: controller,
          keyboardType:
          field == "phoneNumber" ? TextInputType.number : TextInputType.text,
          obscureText: field == "password",
          cursorColor: const Color(0XFF2F66F5),
          maxLength: field == "phoneNumber" ? 10 : null,
          decoration: InputDecoration(
            counterText: "",
            labelText: "Enter new $field",
            labelStyle: const TextStyle(color: Color(0XFF2F66F5)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              const BorderSide(color: Color(0XFF2F66F5), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              BorderSide(color: const Color(0XFF2F66F5).withOpacity(0.5)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final newValue = controller.text.trim();

              // 🔴 VALIDATION
              if (field == "phoneNumber") {
                if (!RegExp(r'^\d{10}$').hasMatch(newValue)) {
                  _showError("Phone number must be exactly 10 digits");
                  return;
                }
              }

              if (field == "password") {
                if (newValue.length < 6) {
                  _showError("Password must be at least 6 characters");
                  return;
                }
              }

              updateField(field, newValue);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0XFF2F66F5),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Update"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0XFF2F66F5),
            ),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }


  Widget buildInfoTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0XFF2F66F5), width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$label :",
              style: const TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.grey, fontSize: 20),
              textAlign: TextAlign.right,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.mode_edit, color: Color(0XFF2F66F5)),
            onPressed: () => showEditDialog(label, value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.orange)),
      );
    }

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("No user logged in", style: TextStyle(color: Colors.black, fontSize: 18))),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background
          Container(color: Colors.white),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Column(
                children: [
                  // Custom AppBar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "User Information",
                          style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Info Card
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            buildInfoTile("phoneNumber", userData["phoneNumber"] ?? ""),
                            buildInfoTile("password", userData["password"] ?? ""),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          "https://i.pinimg.com/1200x/24/17/85/2417854e56cdab795d8abf85998e86f8.jpg",
                          height: 150,
                          width: 150,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
