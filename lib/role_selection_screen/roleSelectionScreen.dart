import 'package:flutter/material.dart';
import 'package:smart_park_jo/l10n/app_localizations.dart';

import '../garage_owner_path/on_boarding/onBoardingOwnerS.dart';
import '../main.dart';
import '../qr code app/login/login_screen.dart';
import '../users_path/on_boarding_users/onBoardingUsers.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // gradient: LinearGradient(
          //   colors: [Color(0xFF2F66F5), Color(0xFF1B3FAE)],
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          // ),
          gradient: LinearGradient(
            colors: [Color(0xFF2F66F5), Color(0xFF2F66F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              /// HEADER
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.language, color: Colors.white),
                  onPressed: () => _showLanguageDialog(context),
                ),
              ),

              const SizedBox(height: 20),

              /// TITLE
              ///
              Transform.scale(
                scale: 1.3, // increase this for more zoom
                child: const CircleAvatar(
                  radius: 65,
                  backgroundColor: Colors.white24,
                  backgroundImage: AssetImage("assets/icon/app_icon.png"),
                ),
              ),

              const SizedBox(height: 40),

              Text(
                AppLocalizations.of(context)!.smartParkJordan,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                AppLocalizations.of(context)!.findReserveParkSmart,
                style: const TextStyle(color: Colors.white70),
              ),

              const Spacer(),

              /// BUTTONS SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    /// DRIVER BUTTON
                    _modernButton(
                      context,
                      icon: Icons.directions_car,
                      title: AppLocalizations.of(context)!.continueAsDriver,
                      color: Colors.white,
                      textColor: Colors.blue,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const onBoardingUsers(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 15),

                    /// OWNER BUTTON (COMBINED)
                    _modernButton(
                      context,
                      icon: Icons.business,
                      title: AppLocalizations.of(context)!.continueAsOwner,
                      color: Colors.green,
                      textColor: Colors.white,
                      onTap: () {
                        _showOwnerOptions(context);
                      },
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// MODERN BUTTON UI
  Widget _modernButton(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Color color,
        required Color textColor,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        decoration: BoxDecoration(
          color: color.withOpacity(0.95),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// OWNER OPTIONS BOTTOM SHEET
  void _showOwnerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.ownerOptions,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              ListTile(
                leading: const Icon(Icons.dashboard),
                title:  Text(AppLocalizations.of(context)!.continueAsOwner),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OnboardingScreenParkingOwner(),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.qr_code_scanner),
                title:  Text(AppLocalizations.of(context)!.parkingOwnerScanner),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final l10n = AppLocalizations.of(dialogContext)!;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            l10n.language,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("English"),
                trailing: Localizations.localeOf(dialogContext).languageCode == 'en'
                    ? const Icon(Icons.check, color: Color(0xFF2F66F5))
                    : null,
                onTap: () {
                  MyApp.setLocale(context, const Locale('en'));
                  Navigator.pop(dialogContext);
                },
              ),
              ListTile(
                title: const Text("العربية"),
                trailing: Localizations.localeOf(dialogContext).languageCode == 'ar'
                    ? const Icon(Icons.check, color: Color(0xFF2F66F5))
                    : null,
                onTap: () {
                  MyApp.setLocale(context, const Locale('ar'));
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}