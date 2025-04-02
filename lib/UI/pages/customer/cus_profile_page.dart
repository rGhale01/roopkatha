import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roopkatha/UI/pages/customer/login_page.dart';
import 'package:roopkatha/UI/pages/service/auth_service.dart';

import 'bottomtab.dart';

class CustomerProfile extends StatefulWidget {
  const CustomerProfile({super.key});

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
    });

    final response = await _authService.logoutCustomer();

    setState(() {
      _isLoading = false;
    });

    if (response.containsKey('error')) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['error'])));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logout successful!')));
      Get.offAll(() => CustomerLoginPage()); // Redirect to login page after logout
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
      bottomNavigationBar: CusBottomTabs(
        currentIndex: 3,
      ),
    );
  }
}