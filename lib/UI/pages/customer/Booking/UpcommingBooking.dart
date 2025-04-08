import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../bottomtab/explore_page.dart';

class UpcomingBookingsPage extends StatefulWidget {
  final Function(dynamic booking) onCancelBooking;

  UpcomingBookingsPage({required this.onCancelBooking});

  @override
  _UpcomingBookingsPageState createState() => _UpcomingBookingsPageState();
}

class _UpcomingBookingsPageState extends State<UpcomingBookingsPage> {
  List<dynamic> bookings = [];
  String customerId = '';

  @override
  void initState() {
    super.initState();
    fetchCustomerId();
  }

  Future<void> fetchCustomerId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      customerId = prefs.getString('customerID') ?? 'YOUR_CUSTOMER_ID';
    });
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    final String baseUrl = 'http://10.0.2.2:8000'; // Adjust the base URL as needed
    final String url = '$baseUrl/api/bookings/customer/$customerId'; // Adjust the endpoint as needed

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          bookings = json.decode(response.body)['Bookings'];
        });
      } else {
        throw Exception('Failed to load bookings');
      }
    } catch (e) {
      print('Error fetching bookings: $e');
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    final String baseUrl = 'http://10.0.2.2:8000'; // Adjust the base URL as needed
    final String url = '$baseUrl/api/bookings/delete/$bookingId'; // Adjust the endpoint as needed

    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          final canceledBooking = bookings.firstWhere((booking) => booking['_id'] == bookingId);
          bookings.removeWhere((booking) => booking['_id'] == bookingId);
          widget.onCancelBooking(canceledBooking);
        });
      } else {
        throw Exception('Failed to cancel booking');
      }
    } catch (e) {
      print('Error canceling booking: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bookings.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "No Upcoming Bookings Yet.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Get.to(() => ExplorePage());
              },
              child: Text(
                "Book your first makeup appointment now!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.pink,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
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
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      cancelBooking(booking['_id']);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.red,
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}