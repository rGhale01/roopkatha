import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:roopkatha/admin/sidebar.dart';

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
        errorMessage = 'Error: ${e.toString()}'; // ✅ fixed here
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
        title: Text("Pending Verification"),
      ),
      drawer: AdminSidebar(), // Add the sidebar
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Artist Name')),
            DataColumn(label: Text('Citizenship Card')),
            DataColumn(label: Text('Pancard')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Submission Date')),
            DataColumn(label: Text('Action')), // Add Action column
          ],
          rows: artists.map((artist) {
            return DataRow(cells: [
              DataCell(Text(artist['name'] ?? 'N/A')),
              DataCell(
                artist['citizenshipFilePath'] != null
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
              DataCell(
                artist['panFilePath'] != null
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
              DataCell(
                Text(
                  'Pending',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
              DataCell(Text(artist['submissionDate'] ?? 'N/A')),
              DataCell(
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _verifyArtist(artist['_id']);
                      },
                      child: Text("Approve"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // ✅ updated here
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Implement reject functionality
                      },
                      child: Text("Reject"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Background color
                      ),
                    ),
                  ],
                ),
              ),
            ]);
          }).toList(),
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
