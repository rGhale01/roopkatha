import 'package:flutter/material.dart';
import '../../main_screen.dart';
import '../bottomtab.dart';

class ArtistHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('hellow')),
      body: Center(child: Text('Welcome Artist!')),
      bottomNavigationBar: BottomTabs(
        currentIndex: 0,
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