import 'package:flutter/material.dart';
import '../bottomtab/artist_bottomtab.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../artist_shared_preferences.dart';
import 'BookingCard.dart';
import 'BookingDetailPage.dart';

void main() {
  runApp(ArtistBookingsApp());
}

class ArtistBookingsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white,
      ),
      home: ArtistDashboardPage(),
    );
  }
}

class ArtistDashboardPage extends StatefulWidget {
  @override
  _ArtistDashboardPage createState() => _ArtistDashboardPage();
}

class _ArtistDashboardPage extends State<ArtistDashboardPage> {
  List<dynamic> bookings = [];
  String? artistId;

  @override
  void initState() {
    super.initState();
    _loadArtistID();
  }

  Future<void> _loadArtistID() async {
    artistId = await ArtistSharedPreferences.getArtistID();
    if (artistId != null) {
      fetchBookings();
    } else {
      showErrorDialog('Artist ID not found. Please log in again.');
    }
  }

  Future<void> fetchBookings() async {
    print('Fetching bookings for artist ID: $artistId'); // Log artist ID

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/bookings/artist/$artistId?status=active'),
      );

      print('Response status: ${response.statusCode}'); // Log response status
      print('Response body: ${response.body}'); // Log response body

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          bookings = jsonData['Bookings'];
        });
        print('Bookings fetched successfully: $bookings'); // Log fetched bookings
      } else {
        print('Failed to load bookings: ${response.reasonPhrase}');
        showErrorDialog('Failed to load bookings: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
      showErrorDialog('An error occurred while fetching bookings: $e');
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void cancelBooking(String bookingId) async {
    try {
      final response = await http.patch(
        Uri.parse('http://10.0.2.2:8000/api/bookings/delete/$bookingId'),
      );

      if (response.statusCode == 200) {
        setState(() {
          bookings.removeWhere((booking) => booking['_id'] == bookingId);
        });
        print('Booking canceled successfully');
      } else {
        print('Failed to cancel booking: ${response.reasonPhrase}');
        showErrorDialog('Failed to cancel booking: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
      showErrorDialog('An error occurred while canceling the booking: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: bookings.isEmpty
            ? Center(child: Text('No bookings found.'))
            : ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingDetailPage(booking: booking),
                  ),
                );
              },
              child: ArtistBookingCard(
                booking: booking,
                onCancel: () => cancelBooking(booking['_id']),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: ArtistBottomtab(currentIndex: 0),
    );
  }
}