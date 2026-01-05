import 'package:flutter/material.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🌈 Gradient Background
      body: Container(
        decoration: const BoxDecoration(
          // gradient: LinearGradient(
          //   colors: [Colors.grey, Color(0xFF36D1DC),Colors.grey,],
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          // ),
          color: Colors.white
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 AppBar replacement
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Privacy & Security",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // 📜 Content (Glass effect card)
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // gradient: LinearGradient(
                      //   colors: [
                      //     Colors.blue.shade50.withOpacity(0.5),
                      //     Colors.blue.shade100.withOpacity(0.3),
                      //   ],
                      //   begin: Alignment.topLeft,
                      //   end: Alignment.bottomRight,
                      // ),                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your Privacy Matters",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2F66F5),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "We are committed to protecting your personal information and ensuring transparency about how we collect, use, and store it. "
                              "Your account data such as name, phone, and email are securely encrypted and never shared with third parties without your consent.",
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          "Security Practices",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2F66F5)
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "• All passwords are stored using industry-standard encryption.\n"
                              "• We use secure HTTPS connections for all communications.\n"
                              "• Two-step authentication is available for additional protection.\n"
                              "• Regular system checks and audits are performed to detect vulnerabilities.",
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          "Your Control",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2F66F5),
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "You can update or delete your personal information at any time from your profile settings. "
                              "We will always notify you before any significant changes to our privacy policy.",
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          "For more details, contact our support team or review our full privacy policy in the app settings.",
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),
                      ],
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
}
