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
          return SizedBox(
            width: 393,
            height: 852,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: 393,
                    height: 852,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(54),
                        topRight: Radius.circular(54),
                        bottomLeft: Radius.circular(54),
                        bottomRight: Radius.circular(54),
                      ),
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 98,
                          left: 18,
                          child: Container(
                            width: 357,
                            height: 218,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(42),
                                topRight: Radius.circular(42),
                                bottomLeft: Radius.circular(42),
                                bottomRight: Radius.circular(42),
                              ),
                            ),
                            child: Image.network(
                              snapshot.data!.profilePictureUrl,
                              fit: BoxFit.fitWidth,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/logo.png',
                                  fit: BoxFit.fitWidth,
                                );
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          top: 63.5971565246582,
                          left: 25.19230842590332,
                          child: Transform.rotate(
                            angle: -90 * (math.pi / 180),
                            child: SvgPicture.asset(
                              'assets/images/back.svg',
                              semanticsLabel: 'back',
                            ),
                          ),
                        ),
                        Positioned(
                          top: 120,
                          left: 324,
                          child: SizedBox(
                            width: 37,
                            height: 37,
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                    width: 37,
                                    height: 37,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 252, 252, 1),
                                      borderRadius: BorderRadius.all(Radius.elliptical(37, 37)),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 9,
                                  left: 8,
                                  child: SvgPicture.asset(
                                    'assets/images/heartfavourite.svg',
                                    semanticsLabel: 'heartfavourite',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 337,
                          left: 24.184585571289062,
                          child: Text(
                            snapshot.data!.name,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              height: 1,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 367,
                          left: 24.184585571289062,
                          child: Text(
                            widget.artistName,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color.fromRGBO(135, 135, 135, 1),
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              height: 1,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 402,
                          left: 17,
                          child: Text(
                            'Services',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromRGBO(15, 15, 15, 1),
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              height: 1.2,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 450,
                          left: 20,
                          right: 20,
                          child: FutureBuilder<List<Service>>(
                            future: services,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Center(child: Text('No services available'));
                              } else {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    final service = snapshot.data![index];
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
                                );
                              }
                            },
                          ),
                        ),
                        Positioned(
                          top: 717,
                          left: 46,
                          child: GestureDetector(
                            onTap: _onNextButtonPressed,
                            child: SizedBox(
                              width: 300.29229736328125,
                              height: 50,
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: Container(
                                      width: 300.29229736328125,
                                      height: 50,
                                      decoration: BoxDecoration(),
                                      child: Stack(
                                        children: <Widget>[
                                          Positioned(
                                            top: 0,
                                            left: 0,
                                            child: Container(
                                              width: 298,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(25),
                                                  topRight: Radius.circular(25),
                                                  bottomLeft: Radius.circular(25),
                                                  bottomRight: Radius.circular(25),
                                                ),
                                                color: Color.fromRGBO(255, 125, 229, 1),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 13,
                                            left: 75.57691955566406,
                                            child: Text(
                                              'Next',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color.fromRGBO(255, 255, 255, 1),
                                                fontFamily: 'Poppins',
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                height: 1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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