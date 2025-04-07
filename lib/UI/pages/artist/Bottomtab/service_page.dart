import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:roopkatha/UI/pages/artist/Bottomtab/artist_bottomtab.dart';
import 'dart:convert';

import '../add_availability.dart';
import '../add_service_page.dart';
import '../artist_shared_preferences.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  Future<List<Service>>? _servicesFuture;
  String artistName = "";
  String profileImageUrl = "";

  @override
  void initState() {
    super.initState();
    _servicesFuture = fetchServices();
    fetchArtistDetails();
  }

  Future<void> fetchArtistDetails() async {
    String? artistID = await ArtistSharedPreferences.getArtistID();
    if (artistID != null) {
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/artist/$artistID'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          artistName = data['name'];
          profileImageUrl = data['profileImage'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: profileImageUrl.isNotEmpty
                        ? NetworkImage(profileImageUrl)
                        : AssetImage('assets/default_profile.png') as ImageProvider,
                  ),
                  SizedBox(height: 8),
                  Text(artistName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(height: 20),
            _buildStyledButton('Add Service', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddService()),
              );
            }),
            SizedBox(height: 16),
            _buildStyledButton('Add Availability', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddAvailability()),
              );
            }),
            SizedBox(height: 32),
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
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final service = snapshot.data![index];
                        return _buildServiceCard(service);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ArtistBottomtab(currentIndex: 2),
    );
  }

  Widget _buildStyledButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Colors.pinkAccent,
        elevation: 5,
      ),
      child: Text(text, style: TextStyle(fontSize: 18, color: Colors.white)),
    );
  }

  Widget _buildServiceCard(Service service) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: Icon(Icons.brush, color: Colors.pinkAccent),
        title: Text(service.name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${service.description}\nRs. ${service.price}'),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: Colors.grey),
          onPressed: () {
            _showEditDialog(service);
          },
        ),
      ),
    );
  }

  Future<List<Service>> fetchServices() async {
    String? artistID = await ArtistSharedPreferences.getArtistID();
    if (artistID == null) {
      throw Exception('Artist ID not found');
    }

    final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/service/artist/$artistID'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Service.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

  void _showEditDialog(Service service) {
    TextEditingController nameController = TextEditingController(text: service.name);
    TextEditingController descriptionController = TextEditingController(text: service.description);
    TextEditingController priceController = TextEditingController(text: service.price.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Service'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Service Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateService(service.id, nameController.text, descriptionController.text, double.parse(priceController.text));
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateService(String serviceId, String name, String description, double price) async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:8000/api/service/$serviceId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'description': description, 'price': price}),
    );

    if (response.statusCode == 200) {
      setState(() {
        _servicesFuture = fetchServices();
      });
    } else {
      print('Failed to update service');
    }
  }
}

class Service {
  final String id;
  final String name;
  final String description;
  final double price;

  Service({required this.id, required this.name, required this.description, required this.price});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
    );
  }
}
