import 'package:flutter/material.dart';
import 'package:roopkatha/UI/pages/bottomtab.dart'; // Import the BottomTab widget

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(userId: 'some_user_id'), // Replace with the actual user ID
    );
  }
}

class HomePage extends StatefulWidget {
  final String userId;

  HomePage({required this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = '';
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomTab(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ), // Use the BottomTab widget
    );
  }

  List<Widget> get _pages {
    return [
      Center(child: Text('Home Page')),
      Center(child: Text('Camera Page')),
      Center(child: Text('Image Page')),
      Center(child: Text('Photo Album Page')),
      Center(child: Text('Profile Page')),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}