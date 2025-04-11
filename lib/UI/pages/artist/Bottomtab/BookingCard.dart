import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ArtistBookingCard extends StatelessWidget {
  final dynamic booking;
  final VoidCallback onCancel;

  const ArtistBookingCard({super.key, required this.booking, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final user = booking['customerID'];
    final availability = booking['availabilityID'];

    final date = DateTime.parse(availability['date']);
    final formattedDate = DateFormat('EEEE, MMMM d').format(date); // Thursday, October 17
    final formattedStartTime = DateFormat.jm().format(DateFormat('HH:mm').parse(availability['startTime']));

    // Add end time formatting
    final String formattedEndTime = availability['endTime'] != null
        ? DateFormat.jm().format(DateFormat('HH:mm').parse(availability['endTime']))
        : 'Not specified';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    formattedDate,
                    style: const TextStyle(height: 1.4),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    'Start: $formattedStartTime',
                    style: const TextStyle(height: 1.4),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.access_time_filled, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    'End: $formattedEndTime',
                    style: const TextStyle(height: 1.4),
                  ),
                ],
              ),
            ],
          ),
          trailing: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              backgroundColor: Colors.white,
            ),
            child: const Text('Cancel'),
          ),
        ),
      ),
    );
  }
}