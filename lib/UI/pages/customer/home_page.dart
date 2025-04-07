import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:roopkatha/UI/pages/artist/artist_details.dart';
import 'bottomtab.dart';
import 'explore_page.dart';

class CusHomePage extends StatefulWidget {
  const CusHomePage({super.key});

  @override
  _CusHomePageState createState() => _CusHomePageState();
}

class _CusHomePageState extends State<CusHomePage> {
  List<dynamic> artists = [];
  String serviceName = '';
  String customerName = '';
  String customerId = 'YOUR_CUSTOMER_ID'; // Add the customer ID here
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchCustomerName();
    fetchArtists();
  }

  Future<void> fetchCustomerName() async {
    final String baseUrl = 'http://10.0.2.2:8000'; // Adjust the base URL as needed
    final String url = '$baseUrl/customer/name/$customerId'; // Adjust the endpoint as needed

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          customerName = json.decode(response.body)['name'];
        });
      } else {
        throw Exception('Failed to load customer name');
      }
    } catch (e) {
      print('Error fetching customer name: $e');
    }
  }

  Future<void> fetchArtists() async {
    final String baseUrl = 'http://10.0.2.2:8000'; // Adjust the base URL as needed
    final String url = '$baseUrl/api/artist/all';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          artists = json.decode(response.body)['artists'];
        });
      } else {
        throw Exception('Failed to load artists');
      }
    } catch (e) {
      print('Error fetching artists: $e');
    }
  }

  Future<List<dynamic>> fetchArtistServices(String artistId) async {
    final String baseUrl = 'http://10.0.2.2:8000'; // Adjust the base URL as needed
    final String url = '$baseUrl/api/service/artist/$artistId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load artist services');
      }
    } catch (e) {
      print('Error fetching artist services: $e');
      return [];
    }
  }

  List<dynamic> getFilteredArtists() {
    List<dynamic> filteredArtists = artists;
    if (serviceName.isNotEmpty) {
      filteredArtists = filteredArtists.where((artist) => artist['profession'] == serviceName).toList();
    }
    if (searchQuery.isNotEmpty) {
      filteredArtists = filteredArtists.where((artist) {
        final name = artist['name']?.toLowerCase() ?? '';
        final profession = artist['profession']?.toLowerCase() ?? '';
        return name.contains(searchQuery.toLowerCase()) || profession.contains(searchQuery.toLowerCase());
      }).toList();
    }
    return filteredArtists;
  }

  void navigateToExplorePage() {
    // Replace with your navigation logic to the explore page
    Get.to(() => ExplorePage()); // Assuming you have an ExplorePage widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Hello,\nHi $customerName,',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(20)),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Let\'s find your top Artist!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search for the best Artist.....',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Services',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.brush, color: Colors.pink[400]),
                      onPressed: () {
                        setState(() {
                          serviceName = 'Makeup';
                        });
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.person, color: Colors.pink[400]),
                      onPressed: () {
                        setState(() {
                          serviceName = 'Nail';
                        });
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.brush, color: Colors.pink[400]),
                      onPressed: () {
                        setState(() {
                          serviceName = 'Bridal Makeup';
                        });
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.person, color: Colors.pink[400]),
                      onPressed: () {
                        setState(() {
                          serviceName = 'Hair';
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Artists',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  TextButton(
                    onPressed: navigateToExplorePage,
                    child: Text(
                      'See All',
                      style: TextStyle(
                        color: Colors.pink[400],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (getFilteredArtists().isEmpty)
                    Center(child: Text('No artists available.')),
                  ...getFilteredArtists().map((artist) => FutureBuilder(
                    future: fetchArtistServices(artist['_id']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error loading services'));
                      } else {
                        final services = snapshot.data ?? [];
                        final serviceNames = services.map((s) => s['name']).join(', ');

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(artist['profilePictureUrl'] ?? 'https://via.placeholder.com/150'),
                            ),
                            title: Text('${artist['name']}'),
                            subtitle: Text('Services: $serviceNames'),
                            trailing: ElevatedButton(
                              onPressed: () {
                                Get.to(ArtistDetails(
                                  artistName: artist['name'],
                                  artistId: artist['_id'], // Pass artistId
                                  customerName: customerName, // Pass customerName if needed
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.pink[400],
                              ),
                              child: Text('Appointment'),
                            ),
                          ),
                        );
                      }
                    },
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CusBottomTabs(
        currentIndex: 0,
      ),
    );
  }
}

