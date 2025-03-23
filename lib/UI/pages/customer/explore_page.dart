import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../artist/artist_details.dart';
import 'bottomtab.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<dynamic> artists = [];
  List<dynamic> filteredArtists = [];
  final String baseUrl = 'http://10.0.2.2:8000';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchArtists();
  }

  Future<void> fetchArtists() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/artist/all'));
      if (response.statusCode == 200) {
        setState(() {
          artists = json.decode(response.body)['artists'];
          filteredArtists = artists;
        });
      } else {
        throw Exception('Failed to load artists');
      }
    } catch (e) {
      print('Error fetching artists: $e');
    }
  }

  Future<List<dynamic>> fetchArtistServices(String artistId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/service/artist/$artistId'));
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

  void filterSearchResults(String query) {
    List<dynamic> dummySearchList = [];
    dummySearchList.addAll(artists);
    if (query.isNotEmpty) {
      List<dynamic> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item['name'].toString().toLowerCase().contains(query.toLowerCase()) ||
            item['profession'].toString().toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        filteredArtists = dummyListData;
      });
      return;
    } else {
      setState(() {
        filteredArtists = artists;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Top Artist')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  filterSearchResults(value);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search Artist by name or profession...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Popular Artists',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  if (filteredArtists.isEmpty)
                    Center(child: Text('No artists available.')),
                  ...filteredArtists.map((artist) => FutureBuilder(
                    future: fetchArtistServices(artist['_id']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error loading services'));
                      } else {
                        final services = snapshot.data ?? [];
                        final serviceNames = services.map((s) => s['name']).join(', ');

                        return ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(artist['profilePictureUrl'] ?? 'https://via.placeholder.com/150'),
                          ),
                          title: Text('${artist['name']}'),
                          subtitle: Text('Services: $serviceNames'),
                          onTap: () {
                            Get.to(ArtistDetails(
                              artistName: artist['name'],
                              artistId: artist['_id'], // Pass artistId
                              customerName: 'Customer', // Replace with actual customer name if available
                            ));
                          },
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
      bottomNavigationBar: CusBottomTabs(currentIndex: 1),
    );
  }
}