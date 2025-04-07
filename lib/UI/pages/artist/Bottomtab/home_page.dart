import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:roopkatha/UI/pages/artist/Bottomtab/artist_bottomtab.dart';

import '../artist_shared_preferences.dart';

class ArtistDashboardPage extends StatefulWidget {
  const ArtistDashboardPage({super.key});

  @override
  _ArtistDashboardPageState createState() => _ArtistDashboardPageState();
}

class _ArtistDashboardPageState extends State<ArtistDashboardPage> {
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
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/bookings/artist/$artistId'),
      );

      if (response.statusCode == 200) {
        setState(() {
          bookings = jsonDecode(response.body)['Bookings'];
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Comming Appointment',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF2F3967),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return BookingCard(booking: booking);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ArtistBottomtab(currentIndex: 0),
    );
  }
}

class BookingCard extends StatelessWidget {
  final dynamic booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final user = booking['customerID'];
    final availability = booking['availabilityID'];

    final date = DateTime.parse(availability['date']);
    final formattedDate = DateFormat('EEEE, MMMM d').format(date); // Thursday, October 17
    final formattedTime = DateFormat.jm().format(DateFormat('HH:mm').parse(availability['startTime']));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              user['profileImage'] ?? 'https://example.com/user_avatar.png',
            ),
            radius: 25,
          ),
          title: Text(
            user['name'],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                '$formattedDate\n$formattedTime',
                style: const TextStyle(height: 1.4),
              ),
            ],
          ),
          trailing: OutlinedButton(
            onPressed: () {
              // Implement cancel logic
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
            child: const Text('Cancel'),
          ),
        ),
      ),
    );
  }
}