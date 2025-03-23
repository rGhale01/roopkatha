import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:roopkatha/UI/pages/artist/artist_shared_preferences.dart';

class AddAvailability extends StatefulWidget {
  @override
  _AddAvailabilityState createState() => _AddAvailabilityState();
}

class _AddAvailabilityState extends State<AddAvailability> {
  Future<List<Service>>? _servicesFuture;

  @override
  void initState() {
    super.initState();
    _servicesFuture = fetchServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Availability')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: FutureBuilder<List<Service>>(
                future: _servicesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error fetching services'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No services available'));
                  } else {
                    return ListView(
                      children: snapshot.data!.map((service) {
                        return ListTile(
                          title: Text(service.name),
                          subtitle: Text('Price: ${service.price}, Duration: ${service.duration} min'),
                          onTap: () {
                            _showAvailabilityOptionsDialog(service);
                          },
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Service>> fetchServices() async {
    String? artistID = await ArtistSharedPreferences.getArtistID();
    if (artistID == null) {
      throw Exception('Artist ID not found');
    }

    final response = await http.get(Uri.parse('http://10.0.2.2:8000/service/artist/$artistID'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Service.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

  void _showAvailabilityOptionsDialog(Service service) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Manage Availability for ${service.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showAddAvailabilityDialog(service);
                },
                child: Text('Add Availability'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _viewAvailability(service);
                },
                child: Text('View Availability'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            ),
          ],
        );
      },
    );
  }

  void _showAddAvailabilityDialog(Service service) {
    final TextEditingController dateController = TextEditingController();
    final TextEditingController startTimeController = TextEditingController();
    final TextEditingController endTimeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Availability for ${service.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDatePicker(dateController),
              _buildTimePicker(startTimeController, 'Start Time'),
              _buildTimePicker(endTimeController, 'End Time'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _addAvailability(service.id, dateController.text, startTimeController.text, endTimeController.text);
              },
              child: Text('Add'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDatePicker(TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Date',
        border: OutlineInputBorder(),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          setState(() {
            controller.text = pickedDate.toLocal().toString().split(' ')[0]; // Only date part
          });
        }
      },
    );
  }

  Widget _buildTimePicker(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          setState(() {
            controller.text = pickedTime.format(context);
          });
        }
      },
    );
  }

  Future<void> _addAvailability(String serviceID, String date, String startTime, String endTime) async {
    String? artistID = await ArtistSharedPreferences.getArtistID();
    if (artistID == null) {
      throw Exception('Artist ID not found');
    }

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/availability/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'artistID': artistID,
        'serviceID': serviceID,
        'date': date,
        'startTime': startTime,
        'endTime': endTime,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Availability added successfully')));
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add availability: ${response.reasonPhrase}')));
    }
  }

  void _viewAvailability(Service service) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/availability/service/${service.id}'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Availability> availabilityList = body.map((json) => Availability.fromJson(json)).toList();
      _showAvailabilityListDialog(service, availabilityList);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load availability: ${response.reasonPhrase}')));
    }
  }

  void _showAvailabilityListDialog(Service service, List<Availability> availabilityList) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Availability for ${service.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: availabilityList.map((availability) {
              return ListTile(
                title: Text('${availability.date} - ${availability.startTime} to ${availability.endTime}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showEditAvailabilityDialog(availability);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteAvailability(availability.id);
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            ),
          ],
        );
      },
    );
  }

  void _showEditAvailabilityDialog(Availability availability) {
    final TextEditingController dateController = TextEditingController(text: availability.date);
    final TextEditingController startTimeController = TextEditingController(text: availability.startTime);
    final TextEditingController endTimeController = TextEditingController(text: availability.endTime);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Availability'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDatePicker(dateController),
              _buildTimePicker(startTimeController, 'Start Time'),
              _buildTimePicker(endTimeController, 'End Time'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _updateAvailability(availability.id, dateController.text, startTimeController.text, endTimeController.text);
              },
              child: Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateAvailability(String id, String date, String startTime, String endTime) async {
    final response = await http.patch(
      Uri.parse('http://10.0.2.2:8000/availability/update/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'date': date,
        'startTime': startTime,
        'endTime': endTime,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Availability updated successfully')));
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update availability: ${response.reasonPhrase}')));
    }
  }

  Future<void> _deleteAvailability(String id) async {
    final response = await http.delete(Uri.parse('http://10.0.2.2:8000/availability/delete/$id'));

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Availability deleted successfully')));
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete availability: ${response.reasonPhrase}')));
    }
  }
}

class Service {
  final String id;
  final String name;
  final String description;
  final double price;
  final int duration;

  Service({required this.id, required this.name, required this.description, required this.price, required this.duration});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(), // Ensure price is treated as double
      duration: json['duration'],
    );
  }
}

class Availability {
  final String id;
  final String serviceID;
  final String date;
  final String startTime;
  final String endTime;

  Availability({required this.id, required this.serviceID, required this.date, required this.startTime, required this.endTime});

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      id: json['_id'],
      serviceID: json['serviceID'],
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }
}