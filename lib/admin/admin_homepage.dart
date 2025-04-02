import 'package:flutter/material.dart';
import 'package:roopkatha/admin/sidebar.dart';

class AdminHomepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Home Page'),
      ),
      drawer: AdminSidebar(),
      body: Center(
        child: Text('Welcome to the Admin Home Page'),
      ),
    );
  }
}