import 'package:flutter/material.dart';

class BookingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Page'),
      ),
      body: Center(
        child: Text(
          'You have reached the Booking Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}