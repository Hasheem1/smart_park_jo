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
                colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
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
                                            : Colors.blueAccent,
                                        fontWeight: FontWeight.w600)),
                                selected: isSelected,
                                selectedColor: const Color(0xFF1565C0),
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
                              gradient: const LinearGradient(
                                colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
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
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "$selectedPayment added successfully!"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
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
          prefixIcon: Icon(icon, color: const Color(0xFF1565C0)),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black54),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
            const BorderSide(color: Colors.blueAccent, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
            const BorderSide(color: Color(0xFF1565C0), width: 1.5),
          ),
        ),
      ),
    );
  }
}
