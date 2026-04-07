import 'package:smart_park_jo/l10n/app_localizations.dart';
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
                    Text(AppLocalizations.of(context)!.privacySecurity,
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
                      //   begin: AlignmentDirectional.topStart,
                      //   end: AlignmentDirectional.bottomEnd,
                      // ),                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.privacyMatters,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2F66F5),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(AppLocalizations.of(context)!.privacyPolicy1,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),
                        // SizedBox(height: 24),
                        // Text(
                        //   "Security Practices",
                        //   style: TextStyle(
                        //     fontSize: 18,
                        //     fontWeight: FontWeight.bold,
                        //     color: Color(0xFF2F66F5)
                        //   ),
                        // ),
                        // SizedBox(height: 12),
                        // Text(
                        //   "• All passwords are stored using industry-standard encryption.\n"
                        //       "• We use secure HTTPS connections for all communications.\n"
                        //       "• Two-step authentication is available for additional protection.\n"
                        //       "• Regular system checks and audits are performed to detect vulnerabilities.",
                        //   style: TextStyle(
                        //     fontSize: 15,
                        //     height: 1.6,
                        //     color: Colors.black87,
                        //   ),
                        // ),
                        SizedBox(height: 24),
                        Text(AppLocalizations.of(context)!.yourControl,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2F66F5),
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(AppLocalizations.of(context)!.updatePrivacySettings ,

                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(AppLocalizations.of(context)!.privacyPolicy2,
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
