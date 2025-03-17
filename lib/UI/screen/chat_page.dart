import 'package:flutter/material.dart';
import '../main_screen.dart';
import '../pages/bottomtab.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Center(child: Text('Welcome to the Chat Page!')),
      bottomNavigationBar: BottomTabs(
        currentIndex: 3,
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