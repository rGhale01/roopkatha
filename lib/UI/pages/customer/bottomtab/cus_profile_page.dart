import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../service/auth_service.dart';
import '../customer_shared_preferences.dart';

import '../login_page.dart';
import '../profile/editProfile.dart';
import 'bottomtab.dart';

class CustomerProfile extends StatefulWidget {
  const CustomerProfile({Key? key}) : super(key: key);

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String _customerName = '';
  String _customerPhone = '';
  String _profilePictureUrl = ''; // Default image

  @override
  void initState() {
    super.initState();
    _fetchCustomerData();
  }

  Future<void> _fetchCustomerData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _customerName = await CustomerSharedPreferences.getCustomerName() ?? '';
      _customerPhone = await CustomerSharedPreferences.getCustomerNumber() ?? '';
      _profilePictureUrl = await CustomerSharedPreferences.getProfilePictureUrl() ?? '';

      // Debug statements to print fetched values
      print('Fetched customer name: $_customerName');
      print('Fetched customer phone: $_customerPhone');
      print('Fetched profile image URL: $_profilePictureUrl');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load customer data')),
      );
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

    final response = await _authService.logoutCustomer();

    setState(() {
      _isLoading = false;
    });

    if (response.containsKey('error')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['error'])),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout successful!')),
      );
      await CustomerSharedPreferences.clearCustomerPreferences();
      Get.offAll(() => const CustomerLoginPage());
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
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 25),
            Stack(
              children: [
                CircleAvatar(
                  radius: 65,
                  backgroundImage: _profilePictureUrl.startsWith('http')
                      ? NetworkImage(_profilePictureUrl)
                      : AssetImage(_profilePictureUrl) as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => const EditProfilePage());
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
              _customerName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _customerPhone,
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
                      Get.to(() => const EditProfilePage());
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
      bottomNavigationBar: CusBottomTabs(currentIndex: 4),
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