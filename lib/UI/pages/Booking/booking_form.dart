import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookingForm extends StatefulWidget {
  final String artistId;
  final String artistName;

  const BookingForm({super.key, required this.artistId, required this.artistName});

  @override
  State<BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  List<String> availableSlots = [];
  String? selectedTimeSlot;

  Future<void> _fetchAvailableSlots(String date) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/available-slots?artistId=${widget.artistId}&date=$date'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        availableSlots = List<String>.from(data['availableSlots']);
        selectedTimeSlot = availableSlots.isNotEmpty ? availableSlots.first : null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch available slots.")),
      );
    }
  }

  Future<void> _submitBooking() async {
    if (selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a time slot")),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/newBooking'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'artistId': widget.artistId,
        'date': _dateController.text,
        'startTime': selectedTimeSlot,
        'customerId': "customer123", // Replace with actual customer ID
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Booking submitted successfully!")),
      );
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit booking. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book ${widget.artistName}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Fill in your details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Full Name", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "Please enter your name" : null,
              ),
              SizedBox(height: 12),

              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Phone Number", border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? "Please enter your phone number" : null,
              ),
              SizedBox(height: 12),

              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: "Preferred Date", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "Please enter a date" : null,
                onChanged: (value) {
                  _fetchAvailableSlots(value);
                },
              ),
              SizedBox(height: 12),

              if (availableSlots.isNotEmpty)
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "Available Time Slots", border: OutlineInputBorder()),
                  value: selectedTimeSlot,
                  items: availableSlots.map((slot) {
                    return DropdownMenuItem<String>(
                      value: slot,
                      child: Text(slot),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTimeSlot = value;
                    });
                  },
                ),
              SizedBox(height: 16),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submitBooking();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: Text("Submit Booking", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
