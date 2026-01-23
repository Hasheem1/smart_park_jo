import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BusinessInfoScreen extends StatefulWidget {
  const BusinessInfoScreen({super.key});

  @override
  State<BusinessInfoScreen> createState() => _BusinessInfoScreenState();
}

class _BusinessInfoScreenState extends State<BusinessInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;

  final String? userEmail = FirebaseAuth.instance.currentUser?.email;
  final CollectionReference users = FirebaseFirestore.instance.collection(
    'owners',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body:
          userEmail == null
              ? const Center(
                child: Text(
                  "No user logged in",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
              : StreamBuilder<DocumentSnapshot>(
                stream: users.doc(userEmail).snapshots(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot,
                ) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        "Something went wrong",
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    );
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(
                      child: Text(
                        "No data found",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    );
                  }

                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  return Stack(
                    children: [
                      // 🔵 Fullscreen gradient background
                      Container(
                        decoration: const BoxDecoration(color: Colors.white),
                      ),

                      // 🌫️ SafeArea + scrollable content
                      SafeArea(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 0,
                          ),
                          child: Column(
                            children: [
                              // 🔹 Custom AppBar
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 10,
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        color: Colors.black,
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      "My Information",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 20,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 10),
                                          buildInfoTile(
                                            context,
                                            "email",
                                            data['email']?.toString() ?? '',
                                            userEmail!,
                                          ),
                                          buildInfoTile(
                                            context,
                                            "Name",
                                            data['name'] ?? 'rgeg',
                                            userEmail!,
                                          ),
                                          buildInfoTile(
                                            context,
                                            "phone number",
                                            data['phone number']?.toString() ??
                                                '',
                                            userEmail!,
                                          ),
                                          buildInfoTile(
                                            context,
                                            "password",
                                            data['password']?.toString() ?? '',
                                            userEmail!,
                                          ),
                                        ],
                                      ),
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
                  );
                },
              ),
    );
  }

  // 🔹 Reusable input field
  Widget buildInfoTile(
    BuildContext context,
    String label,
    String value,
    String documentId,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xFF2F66F5), width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$label : $value",
              style: TextStyle(
                color: Color(0xFF2F66F5),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          //Expanded(
          // child: Text(
          //   "$value ",
          //   style: const TextStyle(color: Colors.grey, fontSize: 20),
          //   textAlign: TextAlign.right,
          // ),
          // ),
          IconButton(
            icon: Icon(Icons.mode_edit, color: Color(0xFF2F66F5)),
            onPressed: () {
              showEditDialogInfo(context, label, value, documentId);
            },
          ),
        ],
      ),
    );
  }

  void showEditDialogInfo(
    BuildContext context,
    String field,
    String oldValue,
    String documentId,
  ) {
    final TextEditingController controller = TextEditingController(
      text: oldValue,
    );

    TextInputType inputType = TextInputType.text;
    List<TextInputFormatter> formatters = [];

    if (field.toLowerCase() == "phone number") {
      inputType = TextInputType.phone;
      formatters = [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ];
    }

    if (field.toLowerCase() == "password") {
      formatters = [LengthLimitingTextInputFormatter(6)];
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update $field"),
          content: TextField(
            controller: controller,
            keyboardType: inputType,
            obscureText: field.toLowerCase() == "password",
            inputFormatters: formatters,
            decoration: InputDecoration(
              labelText: "Enter new $field",
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String value = controller.text.trim();

                // VALIDATIONS
                if (field.toLowerCase() == "phone number" &&
                    value.length != 10) {
                  _showError(context, "Phone number must be 10 digits");
                  return;
                }

                if (field.toLowerCase() == "password" && value.length != 6) {
                  _showError(context, "Password must be exactly 6 characters");
                  return;
                }

                if (field.toLowerCase() == "email" &&
                    (!value.contains("@") || !value.contains(".com"))) {
                  _showError(context, "Enter a valid email");
                  return;
                }

                if (field.toLowerCase() == "name" &&
                    !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                  _showError(context, "Name must contain letters only");
                  return;
                }

                await FirebaseFirestore.instance
                    .collection('owners')
                    .doc(documentId)
                    .update({field.toLowerCase(): value});

                Navigator.pop(context);
              },
              child: const Text("Update"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Invalid Input"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }
}
