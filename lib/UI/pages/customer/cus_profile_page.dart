import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roopkatha/UI/pages/customer/login_page.dart';
import 'package:roopkatha/UI/pages/customer/profile/editProfile.dart';
import 'package:roopkatha/UI/pages/customer/profile/favoutite.dart';
import 'package:roopkatha/UI/pages/customer/profile/notification.dart';
import 'package:roopkatha/UI/pages/service/auth_service.dart';
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
      final customerData = await _authService.fetchCustomerDetails();
      setState(() {
        _customerName = customerData['name'];
        _customerPhone = customerData['phoneNo'];
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to load customer data')));
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response['error'])));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Logout successful!')));
      Get.offAll(() => CustomerLoginPage());
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
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/welcome.png'), // your image here
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: Container(
                    decoration: BoxDecoration(
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
              _customerName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _customerPhone,
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
                    Get.to(() => EditProfilePage());
                  }),
                  _buildProfileOption(Icons.notifications_none, 'Notifications', () {
                    Get.to(() => NotificationsPage());
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
      bottomNavigationBar: CusBottomTabs(currentIndex: 4),
    );
  }

  Widget _buildProfileOption(IconData icon, String text, VoidCallback? onTap) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.black),
          title: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
        const Divider(indent: 16, endIndent: 16),
      ],
    );
  }
}