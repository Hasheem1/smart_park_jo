import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import '../../users_path/users_login_reg/usersLogIn.dart';
import '../owner_Dashboard/ownerDashboardS.dart';

class OwnerLoginScreen extends StatefulWidget {
  const OwnerLoginScreen({super.key});

  @override
  State<OwnerLoginScreen> createState() => _OwnerLoginScreenState();
}

class _OwnerLoginScreenState extends State<OwnerLoginScreen> {
  bool isLogin = true;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // 🔵 BLUE HEADER (SAME AS USER)
              Container(
                height: 260,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF2F66F5),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Welcome Owner",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.swap_horiz,
                              size: 32, color: Colors.white),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const UsersLogIn()),
                            );
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "مرحباً أيها المالك 👋",
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  ],
                ),
              ),

              // ⚪ MAIN CARD
              Padding(
                padding: const EdgeInsets.only(top: 180),
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.1),
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
                          // 🔁 TABS (MATCH USER)
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              children: [
                                _buildTab("Login", true),
                                _buildTab("Register", false),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          if (!isLogin) ...[
                            _buildField(
                                "Full Name", Icons.person, fullNameController),
                            const SizedBox(height: 20),
                            _buildField(
                                "Phone", Icons.phone, phoneController,
                                type: TextInputType.phone),
                            const SizedBox(height: 20),
                          ],

                          _buildField(
                              "Email", Icons.email, emailController,
                              type: TextInputType.emailAddress),
                          const SizedBox(height: 20),

                          _buildField(
                              "Password", Icons.lock, passwordController,
                              obscure: true),
                          const SizedBox(height: 20),

                          if (!isLogin)
                            _buildField("Confirm Password", Icons.lock,
                                confirmPasswordController,
                                obscure: true),

                          const SizedBox(height: 30),

                          // 🔵 BUTTON
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _handleSubmit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2F66F5),
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                isLogin ? "Login" : "Register",
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
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

  // ---------------- HELPERS ----------------

  Widget _buildTab(String text, bool loginTab) {
    final active = isLogin == loginTab;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isLogin = loginTab),
        child: Container(
          decoration: BoxDecoration(
            color: active ? const Color(0xFF2F66F5) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: active ? Colors.white : Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, IconData icon,
      TextEditingController controller,
      {bool obscure = false, TextInputType? type}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: type,
          validator: (v) => v == null || v.isEmpty ? "Required" : null,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF2F66F5)),
            hintText: label,
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- AUTH LOGIC ----------------

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (isLogin) {
      final success = await signInFunction(
          emailController.text.trim(), passwordController.text.trim());
      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OwnerDashboardScreen()),
        );
      }
    } else {
      await signUpFunction(
          emailController.text.trim(), passwordController.text.trim());
    }
  }

  Future<void> signUpFunction(String email, String pass) async {
    final credential = await auth.FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: pass);

    await FirebaseFirestore.instance
        .collection('owners')
        .doc(credential.user!.uid)
        .set({
      'name': fullNameController.text.trim(),
      'phone': phoneController.text.trim(),
      'email': email,
      'uid': credential.user!.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OwnerDashboardScreen()),
    );
  }

  Future<bool> signInFunction(String email, String password) async {
    try {
      await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login failed")),
      );
      return false;
    }
  }
}
