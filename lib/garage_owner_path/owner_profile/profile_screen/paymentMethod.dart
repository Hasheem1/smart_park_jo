import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddPaymentMethodScreen extends StatefulWidget {
  const AddPaymentMethodScreen({super.key});

  @override
  State<AddPaymentMethodScreen> createState() => _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState extends State<AddPaymentMethodScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  String selectedPayment = "Visa";
  final List<String> paymentTypes = ["Visa", "MasterCard", "PayPal"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // 🔵 Fullscreen gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey, Color(0xFF36D1DC),Colors.grey,],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // 🌫️ Scrollable content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
              child: Column(
                children: [
                  // 🔹 Custom AppBar (taller)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white, size: 28),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Add Payment Method",
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

                  // 🌫️ Frosted glass form container
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            "Select Payment Type",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                          const SizedBox(height: 12),

                          // 🔹 Payment Type Chips
                          Wrap(
                            spacing: 12,
                            children: paymentTypes.map((type) {
                              bool isSelected = selectedPayment == type;
                              return ChoiceChip(
                                label: Text(type,
                                    style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Color(0xFF36D1DC),
                                        fontWeight: FontWeight.w600)),
                                selected: isSelected,
                                selectedColor: const Color(0xFF36D1DC),
                                backgroundColor: Colors.blue.shade50,
                                onSelected: (_) {
                                  setState(() {
                                    selectedPayment = type;
                                  });
                                },
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 25),

                          _buildInputField(
                            controller: nameController,
                            label: "Cardholder Name",
                            icon: Icons.person_outline,
                          ),
                          _buildInputField(
                            controller: cardNumberController,
                            label: "Card Number",
                            icon: Icons.credit_card_outlined,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(16)
                            ],
                          ),

                          Row(
                            children: [
                              Expanded(
                                child: _buildInputField(
                                  controller: expiryController,
                                  label: "Expiry (MM/YY)",
                                  icon: Icons.date_range_outlined,
                                  keyboardType: TextInputType.datetime,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(5)
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildInputField(
                                  controller: cvvController,
                                  label: "CVV",
                                  icon: Icons.lock_outline,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(3)
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 35),

                          // 💾 Add Button
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: double.infinity,
                            height: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: LinearGradient(
                                colors: [ Color(0xFF36D1DC),Colors.grey,],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueAccent.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final user = FirebaseAuth.instance.currentUser;

                                  if (user == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("No user logged in!"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  final userDocRef =
                                  FirebaseFirestore.instance.collection('users').doc(user.uid);

                                  // Get the current user data
                                  final snapshot = await userDocRef.get();
                                  Map<String, dynamic>? data =
                                      snapshot.data() as Map<String, dynamic>? ?? {};

                                  // Check if a card already exists
                                  if (data.containsKey('card') && data['card'] != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("You already have a card! Remove it first to add a new one."),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  // Store the card data
                                  Map<String, dynamic> cardData = {
                                    'type': selectedPayment,
                                    'name': nameController.text.trim(),
                                    'number': cardNumberController.text.trim(),
                                    'expiry': expiryController.text.trim(),
                                    'cvv': cvvController.text.trim(),
                                  };

                                  // Add money only if adding a card for the first time
                                  double currentMoney = (data['money'] ?? 0).toDouble();
                                  double moneyToAdd = 10.0;

                                  await userDocRef.set({
                                    'card': cardData,
                                    'money': currentMoney + moneyToAdd,
                                  }, SetOptions(merge: true));

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "$selectedPayment added successfully! Balance: ${(currentMoney + moneyToAdd).toStringAsFixed(2)} JD"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );

                                  // Clear the form
                                  nameController.clear();
                                  cardNumberController.clear();
                                  expiryController.clear();
                                  cvvController.clear();
                                }
                              },




                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                "Add Payment Method",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final user = FirebaseAuth.instance.currentUser;
                              if (user == null) return;

                              final userDocRef =
                              FirebaseFirestore.instance.collection('users').doc(user.uid);

                              await userDocRef.set({
                                'card': null,
                              }, SetOptions(merge: true));

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Card removed. You can add a new one now."),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            },
                            child: const Text("Remove Card"),

                          )

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Reusable Input Field Widget
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: (value) =>
        (value == null || value.isEmpty) ? "Please enter $label" : null,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF36D1DC)),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black54),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
            const BorderSide(color: Color(0xFF36D1DC), width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
            const BorderSide(color: Color(0xFF36D1DC), width: 1.5),
          ),
        ),
      ),
    );
  }
}
