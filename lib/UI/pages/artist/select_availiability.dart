import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'abailability.dart';
import 'checkout_page.dart'; // Import the CheckoutPage

class SelectAvailability extends StatefulWidget {
  final String serviceId;
  final String serviceName;

  const SelectAvailability({super.key, required this.serviceId, required this.serviceName});

  @override
  _SelectAvailabilityState createState() => _SelectAvailabilityState();
}

class _SelectAvailabilityState extends State<SelectAvailability> {
  late Future<List<Availability>> _availabilityFuture;

  @override
  void initState() {
    super.initState();
    _availabilityFuture = fetchAvailability(widget.serviceId);
  }

  Future<List<Availability>> fetchAvailability(String serviceId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/availability/service/$serviceId'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Availability.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load availability');
    }
  }

  void _onAvailabilitySelected(Availability availability) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(availability: availability, serviceName: widget.serviceName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Availability for ${widget.serviceName}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Availability>>(
          future: _availabilityFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No availability slots available'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final availability = snapshot.data![index];
                  // Format the date to remove the time component
                  final formattedDate = DateTime.parse(availability.date).toLocal().toString().split(' ')[0];
                  return ListTile(
                    title: Text('$formattedDate - ${availability.startTime} to ${availability.endTime}'),
                    onTap: () {
                      _onAvailabilitySelected(availability);
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}