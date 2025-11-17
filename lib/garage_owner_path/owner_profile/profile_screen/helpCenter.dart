import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String? userEmail = FirebaseAuth.instance.currentUser?.email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🌈 Gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 🔙 AppBar-style header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Help Center",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // ✉️ Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Need Help?",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1565C0),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Tell us what’s going on, and we’ll get back to you as soon as possible.",
                            style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.6),
                          ),
                          const SizedBox(height: 25),

                          // 🧾 Message TextField
                          TextFormField(
                            controller: _messageController,
                            minLines: 5,
                            maxLines: 10,
                            decoration: InputDecoration(
                              labelText: "Your Message",
                              labelStyle: const TextStyle(color: Colors.black54),
                              alignLabelWithHint: true,
                              prefixIcon: const Icon(Icons.chat_bubble_outline, color: Color(0xFF1565C0)),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: Colors.blueAccent, width: 1.2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: Color(0xFF1565C0), width: 1.5),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please enter your message";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 30),

                          // 🚀 Send Button
                          SizedBox(
                            width: double.infinity,
                            height: 100,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  addMesseage();

                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 24), // Increased from 14 to 24
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Send Message",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> addMesseage() async {
    if ( emailController == null || _messageController == null) return;



    Map<String, dynamic> joinUsMessage = {
      'Message ':_messageController.text,
      'cuurent user email':userEmail,
      'message time':DateTime.now()
    };

    try {

      final reservationCollection = firestore
          // .collection('owners')
          // .doc(userEmail)
          .collection('Help Center Messages');

      final snapshot = await reservationCollection.get();
      int reservationCountMessage = snapshot.docs.length;

      String newDocName = 'Help Center message ${reservationCountMessage + 1}';
      await reservationCollection.doc(newDocName).set(joinUsMessage);
      print('Reservation added as $newDocName');
      _submitForm();
    } catch (error) {
      print('Failed to add reservation: $error');
    }
  }
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Thank you for reaching out!", style: TextStyle(color: Colors.green))),
      // );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Your message has been sent to the Help Center!"),
          backgroundColor: Colors.green,
        ),
      );
      emailController.clear();
      _messageController.clear();
    }
  }
}
