import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'availability.dart';
import 'checkout_page.dart';

class SelectAvailability extends StatefulWidget {
  final String serviceId;
  final String serviceName;
  final double servicePrice;
  final String artistId;
  final String artistService; // Add artistService parameter
  final String customerId;

  const SelectAvailability({
    super.key,
    required this.serviceId,
    required this.serviceName,
    required this.servicePrice,
    required this.artistId,
    required this.artistService, // Add artistService parameter
    required this.customerId,
  });

  @override
  _SelectAvailabilityState createState() => _SelectAvailabilityState();
}

class _SelectAvailabilityState extends State<SelectAvailability> {
  DateTime _selectedDay = DateTime.now();
  List<Availability> _selectedDayAvailability = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchAvailabilityForSelectedDay();
  }

  Future<void> _fetchAvailabilityForSelectedDay() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final dateStr = _selectedDay.toIso8601String().split('T').first; // Format date as YYYY-MM-DD
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/availability/service/${widget.serviceId}?date=$dateStr'));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Availability> availabilityList = body.map((json) => Availability.fromJson(json)).toList();
        setState(() {
          _selectedDayAvailability = availabilityList;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load availability: ${response.reasonPhrase}';
        });
      }
    } catch (err) {
      setState(() {
        _errorMessage = 'Error fetching availability: $err';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _onAvailabilitySelected(Availability availability) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(
          availability: availability,
          serviceId: widget.serviceId,
          serviceName: widget.serviceName,
          serviceCharge: widget.servicePrice,
          artistId: widget.artistId, // Pass artistId
          artistService: widget.artistService, // Pass artistService
          customerId: widget.customerId, // Pass customerId
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Availability for ${widget.serviceName}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              focusedDay: _selectedDay,
              firstDay: DateTime.now(),
              lastDay: DateTime(2100),
              calendarFormat: CalendarFormat.month,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                });
                _fetchAvailabilityForSelectedDay();
              },
              eventLoader: (day) {
                DateTime onlyDate = DateTime(day.year, day.month, day.day);
                return _selectedDayAvailability.where((availability) => DateTime.parse(availability.date).isAtSameMomentAs(onlyDate)).toList();
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(color: Colors.pink, shape: BoxShape.circle),
                selectedDecoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                markerDecoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else if (_errorMessage.isNotEmpty)
              Center(child: Text(_errorMessage))
            else if (_selectedDayAvailability.isEmpty)
                Center(child: Text('No available slots for the selected day'))
              else ...[
                  Text(
                    'Select Hours',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _selectedDayAvailability.length,
                      itemBuilder: (context, index) {
                        final availability = _selectedDayAvailability[index];
                        return Card(
                          color: Colors.pinkAccent,
                          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                          child: ListTile(
                            title: Text('${availability.startTime} - ${availability.endTime}',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            onTap: () => _onAvailabilitySelected(availability),
                          ),
                        );
                      },
                    ),
                  ),
                ],
          ],
        ),
      ),
    );
  }
}