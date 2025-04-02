import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerifyKycPage extends StatefulWidget {
  @override
  _VerifyKycPageState createState() => _VerifyKycPageState();
}

class _VerifyKycPageState extends State<VerifyKycPage> {
  List<dynamic> artists = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchUnverifiedArtists();
  }

  Future<void> _fetchUnverifiedArtists() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      var url = Uri.parse('http://localhost:8000/api/unverified');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['artists'] != null) {
          setState(() {
            artists = responseData['artists'];
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            errorMessage = 'No data found';
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to fetch artists: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  Future<void> _verifyArtist(String artistId) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:8000/api/verify/$artistId'),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        _fetchUnverifiedArtists(); // Refresh the artist list
      } else {
        print('Failed to verify artist: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify KYC"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : ListView.builder(
        itemCount: artists.length,
        itemBuilder: (context, index) {
          final artist = artists[index];
          return Card(
            child: ListTile(
              title: Text(artist['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(artist['email']),
                  SizedBox(height: 8),
                  artist['citizenshipFilePath'] != null
                      ? Image.network(artist['citizenshipFilePath'])
                      : Text('No Citizenship Image'),
                  SizedBox(height: 8),
                  artist['panFilePath'] != null
                      ? Image.network(artist['panFilePath'])
                      : Text('No PAN Image'),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  _verifyArtist(artist['_id']);
                },
                child: Text("Verify"),
              ),
            ),
          );
        },
      ),
    );
  }
}