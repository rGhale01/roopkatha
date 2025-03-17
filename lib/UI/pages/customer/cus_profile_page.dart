import 'package:flutter/material.dart';
import '../../main_screen.dart';
import '../bottomtab.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(child: Text('Welcome to the Profile Page!')),
      bottomNavigationBar: BottomTabs(
        currentIndex: 4,
        onItemTapped: (index) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen(index: index)),
          );
        },
      ),
    );
  }
}