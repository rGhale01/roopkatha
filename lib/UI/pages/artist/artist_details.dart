import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roopkatha/UI/pages/artist/service_selection_page.dart';

class ArtistDetails extends StatelessWidget {
  final String artistName;
  final String customerName;
  final String artistProfession;
  final double rating;
  final int reviews;
  final int clients;
  final int years;
  final List<String> works;
  final String artistId;  // Add artistId parameter

  const ArtistDetails({
    super.key,
    required this.artistName,
    required this.customerName,
    required this.artistProfession,
    required this.rating,
    required this.reviews,
    required this.clients,
    required this.years,
    required this.works,
    required this.artistId,  // Add artistId parameter
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(artistName),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.pink[100],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  artistName,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  artistProfession,
                  style: TextStyle(color: Colors.grey),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildIconInfo(Icons.person, "$clients+ Clients"),
                    _buildIconInfo(Icons.schedule, "$years+ Years"),
                    _buildIconInfo(Icons.star, "$rating Rating"),
                    _buildIconInfo(Icons.comment, "$reviews+ Reviews"),
                  ],
                ),
                SizedBox(height: 16),
                Text("Works", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: works.map((work) => Image.network(work)).toList(),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => ServiceSelectionPage(artistName: artistName, artistId: artistId));  // Pass artistId parameter
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text("Book Now", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconInfo(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Colors.pink),
        SizedBox(height: 4),
        Text(text),
      ],
    );
  }
}