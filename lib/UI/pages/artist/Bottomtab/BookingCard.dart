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
            onPressed: onCancel,
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