import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roopkatha/admin/admin_homepage.dart';
import 'package:roopkatha/admin/verify_kyc_page.dart';

void main() {
  runApp(AdminApp());
}

class AdminApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'RoopKatha Admin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.lato().fontFamily,
      ),
      initialRoute: '/admin',
      getPages: [
        GetPage(name: '/admin', page: () => AdminHomepage()),
        GetPage(name: '/admin/verify-kyc', page: () => VerifyKycPage()),
      ],
    );
  }
}