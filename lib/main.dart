import 'package:flutter/material.dart'; // Flutter UI framework
import 'package:get/get.dart'; // State management and navigation
import 'package:google_fonts/google_fonts.dart'; // Custom Google Fonts
import 'package:khalti_flutter/khalti_flutter.dart'; // Khalti payment integration
import 'package:flutter_localizations/flutter_localizations.dart'; // Flutter localization
// Customer home page
import 'package:roopkatha/UI/pages/welcome_page.dart'; // Welcome page

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter bindings are initialized before running the app
  runApp(const MyApp()); // Run the app
}

// Main Application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return KhaltiScope( // Wrap app with Khalti payment scope
      publicKey: '690968f6fa104a4888d7a3f9212fad6f', // Replace with actual Khalti public key
      enabledDebugging: false, // Disable debugging in production
      builder: (context, navigatorKey) {
        return GetMaterialApp( // Use GetMaterialApp for navigation and state management
          navigatorKey: navigatorKey, // Assign Khalti navigator key
          title: 'RoopKatha', // App title
          theme: ThemeData(
            primarySwatch: Colors.blue, // Set primary theme color
            fontFamily: GoogleFonts.lato().fontFamily, // Apply Google Fonts
          ),
          localizationsDelegates: [
            KhaltiLocalizations.delegate, // Add Khalti localization
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ne', 'NP'), // Support for Nepali language
          ],
          home: const WelcomeScreen(), // Default to welcome screen
        );
      },
    );
  }
}
