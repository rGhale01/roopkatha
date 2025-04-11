import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roopkatha/UI/pages/service/auth_service.dart';
import 'package:roopkatha/UI/pages/welcome_page.dart';

import '../artist_shared_preferences.dart';
import '../profile/edit_profiel_ariist.dart';

class ArtistProfile extends StatefulWidget {
  const ArtistProfile({Key? key}) : super(key: key);

  @override
  State<ArtistProfile> createState() => _ArtistProfileState();
}

class _ArtistProfileState extends State<ArtistProfile> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String _artistName = '';
  String _artistPhone = '';
  String _artistEmail = '';
  String _profilePictureUrl = ''; // Default image

  @override
  void initState() {
    super.initState();
    _fetchArtistData();
  }

  Future<void> _fetchArtistData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch all relevant artist data from shared preferences
      _artistName = await ArtistSharedPreferences.getArtistName() ?? '';
      _artistPhone = await ArtistSharedPreferences.getArtistPhoneNo() ?? '';
      _artistEmail = await ArtistSharedPreferences.getArtistEmail() ?? '';
      _profilePictureUrl = await ArtistSharedPreferences.getProfilePictureUrl() ?? '';

      // Debug statements to print fetched values
      print('Fetched artist name: $_artistName');
      print('Fetched artist phone: $_artistPhone');
      print('Fetched artist email: $_artistEmail');
      print('Fetched profile image URL: $_profilePictureUrl');

      // Alternative way using fetchArtistDetails method
      /*
      final artistData = await ArtistSharedPreferences.fetchArtistDetails();
      setState(() {
        _artistName = artistData['artistName'] ?? '';
        _artistPhone = artistData['artistPhoneNo'] ?? '';
        _artistEmail = artistData['artistEmail'] ?? '';
        _profilePictureUrl = artistData['profilePictureUrl'] ?? '';
      });
      */
    } catch (e) {
      print('Error fetching artist data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load artist data: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.logoutArtist();

      if (response.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['error'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logout successful!')),
        );
        // Use the correct method name for clearing preferences
        await ArtistSharedPreferences.clearArtistPreferences();
        Get.offAll(() => const WelcomeScreen());
      }
    } catch (e) {
      print('Error during logout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            const SizedBox(height: 20),
            Stack(
              children: [
                CircleAvatar(
                  radius: 65,
                  backgroundImage: _profilePictureUrl.isNotEmpty && _profilePictureUrl.startsWith('http')
                      ? NetworkImage(_profilePictureUrl)
                      : const AssetImage('assets/images/welcome.png') as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => const EditArtistProfilePage());
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.edit,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _artistName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _artistEmail, // Show email
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            Text(
              _artistPhone,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                children: [
                  _buildProfileOption(
                    Icons.person_outline,
                    'Edit Profile',
                        () {
                      Get.to(() => const EditArtistProfilePage());
                    },
                  ),
                  _buildProfileOption(
                    Icons.logout,
                    'Logout',
                    _logout,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: const TextStyle(color: Colors.black)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
      onTap: onTap,
    );
  }
}