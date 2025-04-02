import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'availability.dart';

class CheckoutPage extends StatelessWidget {
  final Availability availability;
  final String serviceId;
  final String serviceName;
  final double serviceCharge;
  final String artistId;
  final String artistService;
  final String customerId;

  const CheckoutPage({
    super.key,
    required this.availability,
    required this.serviceId,
    required this.serviceName,
    required this.serviceCharge,
    required this.artistId,
    required this.artistService,
    required this.customerId
  });

  @override
  Widget build(BuildContext context) {
    final double advancePayment = serviceCharge * 0.1;

    return Scaffold(
      appBar: AppBar(title: Text('Appointment Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 24,
                    child: Icon(Icons.person, color: Colors.pink),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        artistId,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        artistService,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text('Schedule', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.pink.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        DateFormat('dd MMMM, EEE').format(DateTime.parse(availability.date)),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text('Date', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.pink.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        availability.startTime,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text('Time', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Service', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(serviceName, style: TextStyle(fontSize: 16)),
                Text('Rs. ${serviceCharge.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 10),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Rs. ${serviceCharge.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 20),
            Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset('assets/khalti_logo.png', height: 30),
            ),
            SizedBox(height: 20),
            Text('Advance Payment (10%): Rs. ${advancePayment.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16, color: Colors.red)),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                ),
                onPressed: () {
                  createBooking(context);
                },
                child: Text('CheckOut', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createBooking(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/bookings/newBooking'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'customerID': customerId,
          'availabilityID': availability.id, // Ensure this is the correct availability ID
          'serviceID': serviceId,
          'price': serviceCharge * 100, // Convert to paisa
          'paymentMethod': 'Khalti',
        }),
      );

      if (response.statusCode == 201) {
        // If the server returns a 201 CREATED response,
        // proceed with payment
        final bookingData = jsonDecode(response.body);
        // initializeKhaltiPayment(context, bookingData['bookingID']);
        payWithKhaltiInApp(context, bookingData['bookingID']);
      } else {
        // If the server did not return a 201 CREATED response,
        // show an error message
        String responseBody = response.body;
        print('Response status: ${response.statusCode}');
        print('Response body: $responseBody');
        try {
          final errorBody = jsonDecode(responseBody);
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Booking Failed"),
                content: Text("Error: ${errorBody['error']}"),
                actions: [
                  SimpleDialogOption(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        } catch (e) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Booking Failed"),
                content: Text("An unknown error occurred: $responseBody"),
                actions: [
                  SimpleDialogOption(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Booking Failed"),
            content: Text("An error occurred: $e"),
            actions: [
              SimpleDialogOption(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  void payWithKhaltiInApp(BuildContext context, String bookingID) {
    KhaltiScope.of(context).pay(
      config: PaymentConfig(
        productIdentity: serviceId,
        amount: (serviceCharge * 100).toInt(),
        productName: serviceName,
      ),
      preferences: [
        PaymentPreference.khalti,
        PaymentPreference.sct,
      ],
      onSuccess: (success) {
        onSuccess(context, success);
      },
      onFailure: (failure) {
        onFailure(context, failure);
      },
    );
  }

  void onSuccess(BuildContext context, PaymentSuccessModel success) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Payment Successful"),
          content: Text("Payment ID: ${success.idx}"),
          actions: [
            SimpleDialogOption(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void onFailure(BuildContext context, PaymentFailureModel failure) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Payment Failed"),
          content: Text(failure.message),
          actions: [
            SimpleDialogOption(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}