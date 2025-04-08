import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingDetailPage extends StatelessWidget {
  final dynamic booking;

  const BookingDetailPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final user = booking['customerID'];
    final availability = booking['availabilityID'];
    final service = booking['serviceID'];
    final date = DateTime.parse(availability['date']);
    final formattedDate = DateFormat('EEEE, MMMM d').format(date); // Thursday, October 17
    final formattedTime = DateFormat.jm().format(DateFormat('HH:mm').parse(availability['startTime']));

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Name: ${user['name']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Service: ${service['name']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Date: $formattedDate',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Time: $formattedTime',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Price: \$${booking['price']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Payment Method: ${booking['paymentMethod']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Booking Status: ${booking['bookingStatus']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Payment Status: ${booking['paymentStatus']}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}