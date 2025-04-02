import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Admin Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () {
              Get.toNamed('/admin');
            },
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Verify KYC'),
            onTap: () {
              Get.toNamed('/admin/verify-kyc');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sign Out'),
            onTap: () {
              // Handle sign out
            },
          ),
        ],
      ),
    );
  }
}