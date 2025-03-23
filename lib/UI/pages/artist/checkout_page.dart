import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'abailability.dart';

class CheckoutPage extends StatelessWidget {
  final Availability availability;
  final String serviceName;

  const CheckoutPage({super.key, required this.availability, required this.serviceName});

  @override
  Widget build(BuildContext context) {
    final double serviceCharge = 100.0; // Example service charge, replace with actual value
    final double advancePayment = serviceCharge * 0.1;

    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Service: $serviceName', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(availability.date))}', style: TextStyle(fontSize: 16)),
            Text('Time: ${availability.startTime} to ${availability.endTime}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text('Service Charge: \$${serviceCharge.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
            Text('Advance Payment (10%): \$${advancePayment.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, color: Colors.red)),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.info, color: Colors.red, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'The advance payment is non-refundable.',
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement payment redirection
                },
                child: Text('Proceed to Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}