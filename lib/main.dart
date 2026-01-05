import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_park_jo/role_selection_screen/roleSelectionScreen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(

        // primaryColor: Colors.blue
      ),
      debugShowCheckedModeBanner: false,
      home: const RoleSelectionScreen(),
    );
  }
}
// searchbar
// Padding( padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Material( elevation: 5, borderRadius: BorderRadius.circular(20), child: TextField( controller: _searchController, decoration: InputDecoration( hintText: 'Search by location or name...', prefixIcon: const Icon(Icons.search), filled: true, fillColor: Colors.white12, border: OutlineInputBorder( borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none, ), contentPadding: const EdgeInsets.symmetric( vertical: 0, horizontal: 16), ), onChanged: (value) { setState(() { searchQuery = value.toLowerCase(); }); }, ), ), ),


// gradient: LinearGradient(
// colors: [
// Colors.blue.shade50.withOpacity(0.5),
// Colors.blue.shade100.withOpacity(0.3),
// ],
// begin: Alignment.topLeft,
// end: Alignment.bottomRight,
// ),
//

// class EntrystateMain extends StatelessWidget {
//   const EntrystateMain({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         // Checking the auth state
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
//
//         if (snapshot.hasData) {
//           // User is signed in
//           return const Homescreen(); // <-- Your home screen
//         } else {
//           // User is NOT signed in
//           return  RoleSelectionScreen(); // <-- Your login screen
//         }
//       },
//     );
//   }
// }
