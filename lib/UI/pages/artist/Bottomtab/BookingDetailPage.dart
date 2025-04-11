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
    final formattedStartTime = DateFormat.jm().format(DateFormat('HH:mm').parse(availability['startTime']));

    // Add end time formatting
    final String formattedEndTime = availability['endTime'] != null
        ? DateFormat.jm().format(DateFormat('HH:mm').parse(availability['endTime']))
        : 'Not specified';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Booking Details', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailCard('Customer Name:', user['name']),
              _buildDetailCard('Service:', service['name']),
              _buildDetailCard('Date:', formattedDate),
              _buildDetailCard('Start Time:', formattedStartTime),
              _buildDetailCard('End Time:', formattedEndTime),
              _buildDetailCard('Price:', '\$${booking['price']}'),
              // _buildDetailCard('Payment Method:', booking['paymentMethod']),
              // _buildDetailCard('Booking Status:', booking['bookingStatus']),
              // _buildDetailCard('Payment Status:', booking['paymentStatus']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(String label, String value) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
