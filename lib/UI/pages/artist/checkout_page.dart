import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../customer/customer_shared_preferences.dart';
import 'availability.dart';

class CheckoutPage extends StatelessWidget {
  final Availability availability;
  final String serviceId;
  final String serviceName;
  final double serviceCharge;
  final String artistId;
  final String artistService;

  const CheckoutPage({
    super.key,
    required this.availability,
    required this.serviceId,
    required this.serviceName,
    required this.serviceCharge,
    required this.artistId,
    required this.artistService,
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
                        '${availability.startTime} - ${availability.endTime}',
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
                onPressed: () async {
                  String? customerId = await CustomerSharedPreferences.getCustomerID();
                  print('Customer ID: $customerId');
                  if (customerId == null || customerId.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Booking Failed"),
                          content: const Text("Customer ID cannot be empty."),
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
                  } else {
                    createBooking(context, customerId);
                  }
                },
                child: Text('CheckOut', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createBooking(BuildContext context, String customerId) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/booking/newBooking'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'customerID': customerId,
          'availabilityID': availability.id, // Ensure this is the correct availability ID
          'serviceID': serviceId,
          'price': serviceCharge, // Ensure the price is correct
          'paymentMethod': 'Khalti',
          'totalPrice': serviceCharge,
          'website_url': 'http://localhost:8000', // Ensure the URL is correct
        }),
      );

      if (response.statusCode == 201) {
        final bookingData = jsonDecode(response.body);
        print('Booking ID: ${bookingData['bookingID']}');
        payWithKhaltiInApp(
          context,
          bookingData['bookingID'],
          customerId,
          availability.id,
          serviceId,
        );
      } else {
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

  void payWithKhaltiInApp(
      BuildContext context,
      String bookingID,
      String customerID,
      String availabilityID,
      String serviceID,
      ) {
    print('Initiating Khalti payment with booking ID: $bookingID');
    print('Passing values to Khalti app:');
    print('Service ID: $serviceID');
    print('Availability ID: $availabilityID');
    print('Customer ID: $customerID');
    print('Total Price: ${serviceCharge * 100}');
    print('Website URL: http://localhost:8000');

    KhaltiScope.of(context).pay(
      config: PaymentConfig(
        productIdentity: serviceID,
        amount: (serviceCharge * 100).toInt(),
        productName: serviceName,
      ),
      preferences: [
        PaymentPreference.khalti,
        PaymentPreference.sct,
      ],
      onSuccess: (success) {
        print('Khalti payment successful: ${success.idx}');
        onSuccess(context, success, customerID, availabilityID, bookingID, serviceID);
      },
      onFailure: (failure) {
        print('Khalti payment failed: ${failure.message}');
        onFailure(context, failure);
      },
    );
  }

  void onSuccess(
      BuildContext context,
      PaymentSuccessModel success,
      String customerID,
      String availabilityID,
      String bookingID,
      String serviceID,
      ) {
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

    // Optionally, you can send additional information to your backend if needed
    // for further processing or record keeping.
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