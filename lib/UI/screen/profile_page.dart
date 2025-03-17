import 'package:flutter/material.dart';
import 'package:get/get.dart'; // ✅ Import GetX for navigation
import 'package:http/http.dart' as http;
import 'package:roopkatha/UI/pages/welcome_page.dart';
import '../main_screen.dart';
import '../pages/bottomtab.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to the Profile Page!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await logout();
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomTabs(
        currentIndex: 4,
        onItemTapped: (index) {
          Get.offAll(() => MainScreen(index: index)); // ✅ Optimized GetX navigation
        },
      ),
    );
  }

  // Function to handle logout
  Future<void> logout() async {
    final String baseUrl = 'http://10.0.2.2:8000'; // Localhost for Android Emulator
    final String logoutUrl = '$baseUrl/logout';

    try {
      final response = await http.post(Uri.parse(logoutUrl), headers: {
        'Authorization': 'Bearer your_token_here', // ✅ Replace with actual token storage
      });

      if (response.statusCode == 200) {
        Get.offAll(() => WelcomeScreen()); // ✅ Navigate to WelcomeScreen after logout
      } else {
        Get.defaultDialog(
          title: 'Logout Failed',
          middleText: 'Please try again.',
          textConfirm: 'OK',
          onConfirm: () => Get.back(),
        );
      }
    } catch (e) {
      Get.defaultDialog(
        title: 'Network Error',
        middleText: 'Please check your internet connection and try again.',
        textConfirm: 'OK',
        onConfirm: () => Get.back(),
      );
    }
  }
}
