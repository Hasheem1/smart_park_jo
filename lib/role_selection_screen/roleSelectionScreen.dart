import 'package:smart_park_jo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../garage_owner_path/on_boarding/onBoardingOwnerS.dart';
import '../main.dart';
import '../users_path/on_boarding_users/onBoardingUsers.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2F66F5), Color(0xFF2F66F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, top: 10),
                  child: IconButton(
                    icon: const Icon(Icons.language, color: Colors.white),
                    onPressed: () => _showLanguageDialog(context),
                  ),
                ),
              ),
              Expanded(
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),

                    ClipRRect(borderRadius: BorderRadius.circular(10)
                        ,child: Image(image: NetworkImage("https://i.pinimg.com/1200x/24/17/85/2417854e56cdab795d8abf85998e86f8.jpg"),height: 100,width: 100,)),
                    const SizedBox(height: 30,),
                    Text(AppLocalizations.of(context)!.smartParkJordan,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(AppLocalizations.of(context)!.findReserveParkSmart,
                      style: TextStyle(color: Colors.white70, fontSize: 20),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),

              // Driver Card
              Expanded(
                child: Column(mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // ElevatedButton(onPressed: (){}, child: Text("klkjkj,"),
                    // style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),),
                    _buildRoleCard(
                      backGroundColor: Colors.white,
                      context,
                      title: AppLocalizations.of(context)!.continueAsDriver,
                      icon: Icons.directions_car_rounded,
                      textColor: Colors.blueAccent,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => onBoardingUsers(),
                          ),
                        );
                        // Navigate to Driver screen
                      },
                    ),
                    const SizedBox(height: 20),

                    // Parking Owner Card
                    _buildRoleCard(
                      backGroundColor:Colors.green,
                      context,
                      title: AppLocalizations.of(context)!.continueAsOwner,
                      icon: Icons.business_rounded,
                      textColor: Colors.white,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OnboardingScreenParkingOwner(),
                          ),
                        );
                        // Navigate to Owner screen
                      },
                    ),
                    SizedBox(height: 40,)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color textColor,
    required Color backGroundColor,

    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backGroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
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
