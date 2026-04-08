import 'package:smart_park_jo/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      extendBodyBehindAppBar:true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // 🔵 Fullscreen gradient background
          Container(
            color: Colors.white,
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
                              color: Colors.black, size: 28),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.of(context)!.addPaymentMethod,
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
                          Text(AppLocalizations.of(context)!.selectPaymentType,
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
                                            ?Colors.white

                                        : Colors.black,
                                        fontWeight: FontWeight.w600)),
                                selected: isSelected,
                                selectedColor: const Color(0XFF2F66F5),
                                backgroundColor:Colors.white,

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
                            label: l10n.cardHolderName,
                            fieldName: l10n.cardHolderName,
                            icon: Icons.person_outline,
                          ),
                          _buildInputField(
                            controller: cardNumberController,
                            label: l10n.cardNumber,
                            fieldName: l10n.cardNumber,
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
                                  label: l10n.expiryDate,
                                  fieldName: l10n.expiryDate,
                                  icon: Icons.date_range_outlined,
                                  keyboardType: TextInputType.datetime,
                                  inputFormatters: [LengthLimitingTextInputFormatter(5)],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildInputField(
                                  controller: cvvController,
                                  label: l10n.cvv,
                                  fieldName: l10n.cvv,
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
                                colors: [ Color(0XFF2F66F5),Color(0XFF2F66F5)],

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
                                      SnackBar(
                                        content: Text(AppLocalizations.of(context)!.noUserLoggedInError),
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
                                      SnackBar(
                                        content: Text(AppLocalizations.of(context)!.alreadyHaveCard),
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
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.white,
                                      elevation: 6,
                                      margin: const EdgeInsets.all(16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      content: Row(
                                        children: [
                                          const Icon(
                                            Icons.check_circle_rounded,
                                            color: Colors.green,
                                            size: 26,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: RichText(
                                              text: TextSpan(
                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                children: [
                                                  // This span now handles the entire "Visa added successfully" sentence
                                                  TextSpan(
                                                    text: "${l10n.paymentAddedSuccess(selectedPayment)}\n",
                                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  TextSpan(
                                                    text: "${l10n.balanceLabel}: ${(currentMoney + moneyToAdd).toStringAsFixed(2)} JD",
                                                    style: const TextStyle(
                                                      color: Colors.green,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      duration: const Duration(seconds: 3),
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
                              child: Text(AppLocalizations.of(context)!.addPaymentMethod,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),

                            onPressed: () async {
                              final user = FirebaseAuth.instance.currentUser;
                              if (user == null) return;

                              final userDocRef =
                              FirebaseFirestore.instance.collection('users').doc(user.uid);

                              await userDocRef.set({
                                'card': null,
                              }, SetOptions(merge: true));

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.white,
                                  elevation: 6,
                                  margin: const EdgeInsets.all(16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  content: Row(
                                    children: [
                                      Icon(
                                        Icons.credit_card_off_rounded,
                                        color: Colors.green,
                                        size: 26,
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Text(AppLocalizations.of(context)!.cardRemovedSuccessfully,
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  duration: Duration(seconds: 3),
                                ),
                              );

                            },
                            child: Text(AppLocalizations.of(context)!.removeCard,style: TextStyle(color: Colors.white),),

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
    required String fieldName,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        // Localized validation message
        validator: (value) =>
        (value == null || value.isEmpty) ? "${AppLocalizations.of(context)!.pleaseEnter} $fieldName" : null,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0XFF2F66F5)),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black54),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0XFF2F66F5), width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0XFF2F66F5), width: 1.5),
          ),
          // ... border styles stay the same
        ),
      ),
    );
  }
}
