import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roopkatha/UI/pages/customer/login_page.dart';
import 'package:roopkatha/UI/pages/customer/profile/notification.dart';
import 'package:roopkatha/UI/pages/service/auth_service.dart';
import '../customer_shared_preferences.dart';
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
  String _customerNumber = '';

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
      // If you have separate getter for customer number, get it here separately
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
                color: Color(0xFF2C2C2C),
              ),
            ),
            const SizedBox(height: 25),
            Stack(
              children: [
                const CircleAvatar(
                  radius: 65,
                  backgroundImage: AssetImage('assets/welcome.png'),
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
                        color: Color(0xFF2C2C2C),
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
              _customerName,   // Corrected
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF2C2C2C),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _customerPhone,   // Corrected
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF7E7E7E),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _customerNumber,   // Corrected
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF7E7E7E),
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
                    Icons.notifications_none,
                    'Notifications',
                        () {
                      Get.to(() => NotificationsPage());  // Corrected navigation
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