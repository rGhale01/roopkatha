import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roopkatha/UI/pages/artist/Bottomtab/artist_bottomtab.dart';
import 'package:roopkatha/UI/pages/artist/Login/arrtist_login.dart';
import 'package:roopkatha/UI/pages/service/auth_service.dart';

class ArtistProfile extends StatefulWidget {
  const ArtistProfile({super.key});

  @override
  State<ArtistProfile> createState() => _ArtistProfileState();
}

class _ArtistProfileState extends State<ArtistProfile> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
    });

    final response = await _authService.logoutArtist();

    setState(() {
      _isLoading = false;
    });

    if (response.containsKey('error')) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['error'])));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logout successful!')));
      Get.offAll(() => ArtistLoginPage()); // Redirect to login page after logout
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: _isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : Icon(Icons.logout),
            onPressed: _isLoading ? null : _logout,
          ),
        ],
      ),
      body: const Center(child: Text('Welcome to the Profile Page')),
      bottomNavigationBar: ArtistBottomtab(
        currentIndex: 3,
      ),
    );
  }
}