import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:roopkatha/UI/pages/artist/select_availiability.dart';
import '../customer/customer_shared_preferences.dart'; // Import the shared preferences class

class Artist {
  final String name;
  final String profilePictureUrl;

  Artist({
    required this.name,
    required this.profilePictureUrl,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      name: json['name'],
      profilePictureUrl: json['profilePictureUrl'] ?? 'https://via.placeholder.com/150',
    );
  }
}

class Service {
  final String id;
  final String name;
  final String description;
  final double price;
  final int duration;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      duration: json['duration'],
    );
  }
}

class ServiceSelectionPage extends StatelessWidget {
  final String artistId;
  final String artistName;

  const ServiceSelectionPage({super.key, required this.artistId, required this.artistName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Services')),
      body: ServiceSelectionWidget(artistId: artistId, artistName: artistName),
    );
  }
}

class ServiceSelectionWidget extends StatefulWidget {
  final String artistId;
  final String artistName;

  const ServiceSelectionWidget({super.key, required this.artistId, required this.artistName});

  @override
  _ServiceSelectionWidgetState createState() => _ServiceSelectionWidgetState();
}

class _ServiceSelectionWidgetState extends State<ServiceSelectionWidget> {
  late Future<Artist> artist;
  late Future<List<Service>> services;
  String? selectedServiceId;
  String? selectedServiceName;
  double? selectedServicePrice;

  @override
  void initState() {
    super.initState();
    artist = fetchArtist(widget.artistId);
    services = fetchServices(widget.artistId);
  }

  Future<Artist> fetchArtist(String artistId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/artist/$artistId'));
    if (response.statusCode == 200) {
      return Artist.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load artist');
    }
  }

  Future<List<Service>> fetchServices(String artistId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/service/artist/$artistId'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Service.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

  void _onServiceSelected(String serviceId, String serviceName, double servicePrice) {
    setState(() {
      selectedServiceId = serviceId;
      selectedServiceName = serviceName;
      selectedServicePrice = servicePrice;
    });
  }

  void _onNextButtonPressed() async {
    if (selectedServiceId != null && selectedServiceName != null && selectedServicePrice != null) {
      String? customerId = await CustomerSharedPreferences.getCustomerID();
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectAvailability(
              serviceId: selectedServiceId!,
              serviceName: selectedServiceName!,
              servicePrice: selectedServicePrice!,
              artistId: widget.artistId,
              artistService: widget.artistName,
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a service before proceeding.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Artist>(
      future: artist,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(42),
                  child: Image.network(
                    snapshot.data!.profilePictureUrl,
                    width: double.infinity,
                    height: 218,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    snapshot.data!.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Services',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 20,
                    ),
                  ),
                ),
                FutureBuilder<List<Service>>(
                  future: services,
                  builder: (context, serviceSnapshot) {
                    if (serviceSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (serviceSnapshot.hasError) {
                      return Center(child: Text('Error: ${serviceSnapshot.error}'));
                    } else if (!serviceSnapshot.hasData || serviceSnapshot.data!.isEmpty) {
                      return Center(child: Text('No services available'));
                    } else {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: serviceSnapshot.data!.length,
                          itemBuilder: (context, index) {
                            final service = serviceSnapshot.data![index];
                            return Card(
                              color: selectedServiceId == service.id ? Colors.grey[300] : Colors.white,
                              child: ListTile(
                                title: Text(service.name),
                                subtitle: Text('${service.description}\nPrice: ${service.price}\nDuration: ${service.duration} min'),
                                onTap: () {
                                  _onServiceSelected(service.id, service.name, service.price);
                                },
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onNextButtonPressed,
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white, // Text color set to white
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent, // Background color set to pink
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }
}
