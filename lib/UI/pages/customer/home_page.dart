import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:roopkatha/UI/pages/artist/artist_details.dart';
import 'dart:convert';
import '../../main_screen.dart';
import '../bottomtab.dart';

class CusHomePage extends StatefulWidget {
  @override
  _CusHomePageState createState() => _CusHomePageState();
}

class _CusHomePageState extends State<CusHomePage> {
  List<dynamic> artists = [];

  @override
  void initState() {
    super.initState();
    fetchArtists();
  }

  Future<void> fetchArtists() async {
    final String baseUrl = 'http://10.0.2.2:8000'; // Adjust the base URL as needed
    final String url = '$baseUrl/artist/all';

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
            Text(
              'Hello,\nHi User,',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
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
                      SizedBox(height: 20),
                      Text(
                        'Let\'s find your top Artist!',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search health issue.....',
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        style: TextStyle(color: Colors.pink),
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.brush, color: Colors.pink),
                  Icon(Icons.person, color: Colors.pink),
                  Icon(Icons.brush, color: Colors.pink),
                  Icon(Icons.person, color: Colors.pink),
                ],
              ),
            ),
            SizedBox(height: 20),
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
                  ...artists.map((artist) => ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage:
                      NetworkImage(artist['profilePictureUrl'] ?? 'https://via.placeholder.com/150'),
                    ),
                    title: Text('${artist['name']}\n${artist['specialization']}'),
                    subtitle: Text(artist['rating']?.toString() ?? 'N/A'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Get.to(ArtistDetails(
                          artistName: artist['name'],
                          artistId: artist['_id'], // Pass artistId
                          artistProfession: artist['specialization'],
                          rating: artist['rating']?.toDouble() ?? 0.0,
                          clients: artist['clients'] ?? 0,
                          years: artist['years'] ?? 0,
                          reviews: artist['reviews'] ?? 0,
                          works: artist['works'] ?? [],
                          customerName: '', // Pass customerName if needed
                        ));
                      },
                      child: Text('Appointment'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.pink,
                      ),
                    ),
                  )).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomTabs(
        currentIndex: 0,
        onItemTapped: (index) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen(index: index)),
          );
        },
      ),
    );
  }
}