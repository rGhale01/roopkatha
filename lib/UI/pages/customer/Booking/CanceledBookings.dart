import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CanceledBookingsPage extends StatefulWidget {
  final List<dynamic> canceledBookings;

  CanceledBookingsPage({required this.canceledBookings});

  @override
  _CanceledBookingsPageState createState() => _CanceledBookingsPageState();
}

class _CanceledBookingsPageState extends State<CanceledBookingsPage> {
  List<dynamic> canceledBookings = [];
  String customerId = '';

  @override
  void initState() {
    super.initState();
    fetchCustomerId();
  }

  Future<void> fetchCustomerId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('customerID');
    if (id != null && id.isNotEmpty) {
      setState(() {
        customerId = id;
      });
      fetchCanceledBookings();
    } else {
      print('Customer ID not found in shared preferences');
    }
  }

  Future<void> fetchCanceledBookings() async {
    final String baseUrl = 'http://10.0.2.2:8000'; // Adjust the base URL as needed
    final String url = '$baseUrl/api/bookings/customer/$customerId/canceled'; // Endpoint for canceled bookings

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          canceledBookings = json.decode(response.body)['Bookings'];
        });
      } else {
        throw Exception('Failed to load canceled bookings');
      }
    } catch (e) {
      print('Error fetching canceled bookings: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Canceled Bookings'),
      ),
      body: canceledBookings.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/booking.png', // <-- Replace with your canceled image
                height: 150,
              ),
              const SizedBox(height: 30),
              const Text(
                "No Canceled Bookings Yet.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      )
          : ListView.builder(
        itemCount: canceledBookings.length,
        itemBuilder: (context, index) {
          final booking = canceledBookings[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(booking['artistID']['profilePictureUrl'] ?? 'https://via.placeholder.com/150'),
              ),
              title: Text('${booking['artistID']['name']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${booking['availabilityID']['date']}'),
                  Text('${booking['availabilityID']['time']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}