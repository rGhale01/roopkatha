import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:roopkatha/UI/pages/welcome_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
      publicKey: 'test_public_key_0f28c5bbbfc745d1809260a72e6a1db0', // ✅ Replace with your actual test public key
      builder: (context, navigatorKey) {
        return GetMaterialApp(
          navigatorKey: navigatorKey,
          title: 'RoopKatha',
          theme: ThemeData(
            primarySwatch: Colors.pink,
            fontFamily: GoogleFonts.lato().fontFamily,
          ),
          debugShowCheckedModeBanner: false,
          home: const WelcomeScreen(),
          localizationsDelegates: const [
            KhaltiLocalizations.delegate, // ✅ Add Khalti localization
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ne', 'NP'),
          ],
        );
      },
    );
  }
}
