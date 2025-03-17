import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../main_screen.dart';
import '../pages/bottomtab.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  List<dynamic> bookings = [];

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    final url = Uri.parse('http://localhost:8000/bookings');
    final response = await http.get(url, headers: {
      'Authorization': 'your_jwt_token_here'  // Replace with actual token
    });

    if (response.statusCode == 200) {
      setState(() {
        bookings = json.decode(response.body)['Bookings'];
      });
    } else {
      print('Failed to fetch bookings: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booking')),
      body: bookings.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return ListTile(
            title: Text('Booking ID: ${booking['_id']}'),
            subtitle: Text('Date: ${booking['date']}'),
          );
        },
      ),
      bottomNavigationBar: BottomTabs(
        currentIndex: 2,
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
