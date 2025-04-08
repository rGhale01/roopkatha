import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roopkatha/UI/pages/artist/Bottomtab/artist_bottomtab.dart';
import 'package:roopkatha/UI/pages/service/auth_service.dart';
import 'package:roopkatha/UI/pages/welcome_page.dart';

import '../../customer/profile/favoutite.dart';
import '../artist_shared_preferences.dart';

class ArtistProfile extends StatefulWidget {
  const ArtistProfile({Key? key}) : super(key: key);

  @override
  State<ArtistProfile> createState() => _ArtistProfileState();
}

class _ArtistProfileState extends State<ArtistProfile> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String _artistName = '';
  String _artistEmail = '';

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
      final artistData = await ArtistSharedPreferences.fetchArtistDetails();
      setState(() {
        _artistName = artistData['artistName'] ?? '';
        _artistEmail = artistData['artistEmail'] ?? '';
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to load artist data')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
    });

    final response = await _authService.logoutArtist();

    setState(() {
      _isLoading = false;
    });

    if (response.containsKey('error')) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response['error'])));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Logout successful!')));
      Get.offAll(() => WelcomeScreen()); // <-- Redirect to WelcomePage here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Profile',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/welcome.png'),
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
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
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _artistName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _artistEmail,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                children: [
                  _buildProfileOption(Icons.person_outline, 'Edit Profile', () {
                    Get.to(() => EditArtistProfilePage());
                  }),
                  _buildProfileOption(Icons.notifications_none, 'Notifications', () {
                    Get.to(() => ArtistNotificationsPage());
                  }),
                  _buildProfileOption(Icons.settings_outlined, 'Settings', () {
                    Get.to(() => SettingsPage());
                  }),
                  _buildProfileOption(Icons.logout, 'Log Out', _isLoading ? null : _logout),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ArtistBottomtab(currentIndex: 3),
    );
  }

  Widget _buildProfileOption(IconData icon, String text, VoidCallback? onTap) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon),
          title: Text(text),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
        const Divider(),
      ],
    );
  }
}

// Assume these are placeholders for actual implementations
class ArtistNotificationsPage extends StatelessWidget {
  const ArtistNotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: Center(child: Text('Notifications Page')),
    );
  }
}

class EditArtistProfilePage extends StatelessWidget {
  const EditArtistProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: Center(child: Text('Edit Profile Page')),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(child: Text('Settings Page')),
    );
  }
}