import 'package:flutter/material.dart';

class BusinessInfoScreen extends StatefulWidget {
  const BusinessInfoScreen({super.key});

  @override
  State<BusinessInfoScreen> createState() => _BusinessInfoScreenState();
}

class _BusinessInfoScreenState extends State<BusinessInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController =
  TextEditingController(text: "Mohammad Jamal");
  final TextEditingController usernameController =
  TextEditingController(text: "mjamal_97");
  final TextEditingController phoneController =
  TextEditingController(text: "+962 79 123 4567");
  final TextEditingController emailController =
  TextEditingController(text: "mohammad.j@email.com");
  final TextEditingController passwordController =
  TextEditingController(text: "********");

  bool isPasswordVisible = false;

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

          // 🌫️ SafeArea + scrollable content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Column(
                children: [
                  // 🔹 Custom AppBar
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white),
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
                        children: [
                          const SizedBox(height: 10),

                          _buildInputField(
                            controller: fullNameController,
                            label: "Full Name",
                            icon: Icons.person_outline,
                          ),
                          _buildInputField(
                            controller: usernameController,
                            label: "Username",
                            icon: Icons.alternate_email,
                          ),
                          _buildInputField(
                            controller: phoneController,
                            label: "Phone Number",
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                          ),
                          _buildInputField(
                            controller: emailController,
                            label: "Email",
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          _buildInputField(
                            controller: passwordController,
                            label: "Password",
                            icon: Icons.lock_outline,
                            isPassword: true,
                          ),

                          const SizedBox(height: 35),

                          // 💾 Save Button
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
                                    const SnackBar(
                                      content: Text(
                                          "Business information updated successfully"),
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
                                "Save Changes",
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

  // 🔹 Reusable input field
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword && !isPasswordVisible,
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
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              isPasswordVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.blueGrey,
            ),
            onPressed: () {
              setState(() => isPasswordVisible = !isPasswordVisible);
            },
          )
              : null,
        ),
        validator: (value) =>
        (value == null || value.isEmpty) ? "Please enter $label" : null,
      ),
    );
  }
}
