import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:roopkatha/admin/sidebar.dart';

class VerifiedArtistPage extends StatefulWidget {
  @override
  _VerifiedArtistPageState createState() => _VerifiedArtistPageState();
}

class _VerifiedArtistPageState extends State<VerifiedArtistPage> {
  List<dynamic> artists = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchVerifiedArtists();
  }

  Future<void> _fetchVerifiedArtists() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      var url = Uri.parse('http://localhost:8000/api/verified');
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

  void _viewFile(String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageViewPage(imagePath: imagePath),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Approved Verification"),
      ),
      drawer: AdminSidebar(), // Add the sidebar
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Approved Verification', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Table(
                columnWidths: {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(1),
                },
                border: TableBorder.all(color: Colors.grey),
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Artist Name', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Citizenship Card', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Pancard', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ]),
                  ...artists.map((artist) {
                    return TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(artist['name'] ?? 'N/A'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: artist['citizenshipFilePath'] != null
                            ? InkWell(
                          onTap: () {
                            _viewFile(artist['citizenshipFilePath']);
                          },
                          child: Text(
                            'View file',
                            style: TextStyle(color: Colors.blue),
                          ),
                        )
                            : Text('No Citizenship Image'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: artist['panFilePath'] != null
                            ? InkWell(
                          onTap: () {
                            _viewFile(artist['panFilePath']);
                          },
                          child: Text(
                            'View file',
                            style: TextStyle(color: Colors.blue),
                          ),
                        )
                            : Text('No PAN Image'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Approved',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ]);
                  }).toList(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageViewPage extends StatelessWidget {
  final String imagePath;

  ImageViewPage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Image"),
      ),
      body: Center(
        child: Image.network(imagePath),
      ),
    );
  }
}