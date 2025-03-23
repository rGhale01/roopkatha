import 'package:flutter/material.dart';
import 'package:roopkatha/UI/pages/customer/bottomtab.dart';

class CusProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Welcome to the Profile Page!')),
      bottomNavigationBar: CusBottomTabs(
        currentIndex: 3,
      ),
    );
  }
}