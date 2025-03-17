import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main_screen.dart';
import '../pages/bottomtab.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<dynamic> artists = [];
  final String baseUrl = 'http://10.0.2.2:8000';

  @override
  void initState() {
    super.initState();
    fetchArtists();
  }

  Future<void> fetchArtists() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/all'));
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
      appBar: AppBar(title: Text('Top Artist')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search Artist',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: artists.length,
              itemBuilder: (context, index) {
                final artist = artists[index];
                return ArtistCard(
                  name: artist['name'] ?? 'Unknown Artist',
                  bio: artist['bio'] ?? 'No bio available',
                  rating: artist['rating']?.toString() ?? '0',
                  imageUrl: artist['imageUrl'] ?? 'https://via.placeholder.com/150',
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomTabs(
        currentIndex: 1,
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

class ArtistCard extends StatelessWidget {
  final String name;
  final String bio;
  final String rating;
  final String imageUrl;

  ArtistCard({required this.name, required this.bio, required this.rating, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(bio, overflow: TextOverflow.ellipsis),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(rating, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Icon(Icons.star, color: Colors.yellow),
          ],
        ),
      ),
    );
  }
}