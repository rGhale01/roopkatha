import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roopkatha/UI/pages/customer/signup_page.dart';
import 'package:roopkatha/UI/pages/artist/artist_signup_page.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/welcome.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content Overlay
          Container(
            color: Colors.black.withOpacity(0.3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const Text(
                  "RoopKatha",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Book Beauty Service in seconds",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          Get.to(() => SignupPage());
                        },
                        child: const Text("I am Customer",
                            style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          minimumSize: const Size(double.infinity, 50),
                          side: const BorderSide(color: Colors.white),
                        ),
                        onPressed: () {
                          Get.to(() => ArtistSignupPage());
                        },
                        child: const Text("I am Artist",
                            style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
