import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import '../owner_Dashboard/ownerDashboardS.dart';

class OwnerLoginScreen extends StatefulWidget {
  const OwnerLoginScreen({Key? key}) : super(key: key);

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2F66F5),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome Owner",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "مرحباً أيها المالك",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Toggle tabs
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isLogin = true),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isLogin ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isLogin ? Colors.black : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isLogin = false),
                          child: Container(
                            decoration: BoxDecoration(
                              color: !isLogin ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: !isLogin ? Colors.black : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                if (!isLogin) ...[
                  buildTextFormField(
                    label: "Full Name",
                    controller: fullNameController,
                    icon: Icons.person,
                    validator: (value) =>
                    value!.isEmpty ? "Enter your full name" : null,
                  ),
                  const SizedBox(height: 20),
                  buildTextFormField(
                    label: "Phone",
                    controller: phoneController,
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                    value!.isEmpty ? "Enter your phone number" : null,
                  ),
                  const SizedBox(height: 20),
                ],

                buildTextFormField(
                  label: "Email",
                  controller: emailController,
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                  value!.isEmpty ? "Enter your email" : null,
                ),
                const SizedBox(height: 20),

                buildTextFormField(
                  label: "Password",
                  controller: passwordController,
                  icon: Icons.lock_outline,
                  obscureText: true,
                  validator: (value) =>
                  value!.length < 6 || value.length==0 ? " Enter valid Password  " : null,
                ),
                const SizedBox(height: 20),

                if (!isLogin)
                  buildTextFormField(
                    label: "Confirm Password",
                    controller: confirmPasswordController,
                    icon: Icons.lock,
                    obscureText: true,
                    validator: (value) => value != passwordController.text
                        ? "Passwords do not match"
                        : null,
                  ),

                const SizedBox(height: 30),

                // Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                       // Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) =>  OwnerDashboardScreen()));
                      if (!_formKey.currentState!.validate()) return;

                      if (isLogin) {
                        final success = await signInFunction(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                        if (success && mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const OwnerDashboardScreen(),
                            ),
                          );
                        }
                      } else {
                        await signUpFunction(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F66F5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isLogin ? "Login" : "Register",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper: Text field builder
  Widget buildTextFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool obscureText = false,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: Colors.grey.shade100,
            hintText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> signUpFunction(String email, String pass) async {
    try {
      final credential = await auth.FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);

      await FirebaseFirestore.instance
          .collection('owners')
          .doc(credential.user!.email)
          .set({
        'name': fullNameController.text.trim(),
        'phone number': phoneController.text.trim(),
        'email': email,
        'uid': credential.user!.uid,
        'password':passwordController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OwnerDashboardScreen()),
      );
    } on auth.FirebaseAuthException catch (e) {
      String errorMsg;
      if (e.code == 'weak-password') {
        errorMsg = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMsg = 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        errorMsg = 'Invalid email address.';
      } else {
        errorMsg = 'Something went wrong. Please try again.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }


  Future<bool> signInFunction(String email, String password) async {
    try {
      await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on auth.FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      } else {
        errorMessage = 'Login failed. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
      return false;
    }
  }
}
