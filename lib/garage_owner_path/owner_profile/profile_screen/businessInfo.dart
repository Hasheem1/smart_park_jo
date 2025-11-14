import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BusinessInfoScreen extends StatefulWidget {
  const BusinessInfoScreen({super.key});

  @override
  State<BusinessInfoScreen> createState() => _BusinessInfoScreenState();
}

class _BusinessInfoScreenState extends State<BusinessInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController(
    text: "Mohammad Jamal",
  );
  final TextEditingController usernameController = TextEditingController(
    text: "mjamal_97",
  );
  final TextEditingController phoneController = TextEditingController(
    text: "+962 79 123 4567",
  );
  final TextEditingController emailController = TextEditingController(
    text: "mohammad.j@email.com",
  );
  final TextEditingController passwordController = TextEditingController(
    text: "********",
  );

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
              : FutureBuilder<DocumentSnapshot>(
                future: users.doc(userEmail).get(),
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
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
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
                                        color: Colors.white,
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      "Business Information",
                                      style: TextStyle(
                                        color: Colors.white,
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
                                            "fullName",
                                            data['name'] ?? 'rgeg',
                                            userEmail!,
                                          ),
                                          buildInfoTile(
                                            context,
                                            "phone number",
                                            data['phone number']?.toString() ?? '',
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
              "$label :",
              style: TextStyle(
                color: Color(0xFF2F66F5),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              "$value ",
              style: const TextStyle(color: Color(0xFF2F66F5), fontSize: 20),
              textAlign: TextAlign.right,
            ),
          ),
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

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Update $field"),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Enter new $field",
                border: const OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  String newValue = controller.text.trim();
                  if (newValue.isNotEmpty) {
                    await FirebaseFirestore.instance
                        .collection('owners')
                        .doc(documentId)
                        .update({
                          field.toLowerCase(): _castValue(field, newValue),
                        });
                    setState(() {
                      Navigator.pop(context);
                    });
                  }
                },
                child: const Text("Update"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
            ],
          ),
    );
  }

  dynamic _castValue(String field, String value) {
    if (field.toLowerCase() == "email" ||
        field.toLowerCase() == "fullName" ||
        field.toLowerCase() == "phone number" ||
        field.toLowerCase() == "password") {
      return int.tryParse(value) ?? value;
    }
    return value;
  }
}
