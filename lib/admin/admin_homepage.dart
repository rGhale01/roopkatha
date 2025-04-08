import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:roopkatha/admin/sidebar.dart';

class AdminHomepage extends StatefulWidget {
  @override
  _AdminHomepageState createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  int totalCustomers = 0;
  int totalVerifiedArtists = 0;
  int totalUnverifiedArtists = 0;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final customerResponse = await http.get(Uri.parse('http://localhost:8000/api/customers/total'));
      final verifiedArtistResponse = await http.get(Uri.parse('http://localhost:8000/api/artists/total-verified'));
      final unverifiedArtistResponse = await http.get(Uri.parse('http://localhost:8000/api/artists/total-unverified'));

      print('Customer Response: ${customerResponse.body}');
      print('Verified Artist Response: ${verifiedArtistResponse.body}');
      print('Unverified Artist Response: ${unverifiedArtistResponse.body}');

      if (customerResponse.statusCode == 200 &&
          verifiedArtistResponse.statusCode == 200 &&
          unverifiedArtistResponse.statusCode == 200) {

        final customerData = json.decode(customerResponse.body);
        final verifiedArtistData = json.decode(verifiedArtistResponse.body);
        final unverifiedArtistData = json.decode(unverifiedArtistResponse.body);

        setState(() {
          totalCustomers = customerData['totalCustomers'];
          totalVerifiedArtists = verifiedArtistData['totalVerifiedArtists'];
          totalUnverifiedArtists = unverifiedArtistData['totalUnverifiedArtists'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to fetch dashboard data';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Home Page'),
      ),
      drawer: AdminSidebar(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Overview', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCard('Total Customers', totalCustomers, Colors.pink),
                _buildCard('Total Verified Artists', totalVerifiedArtists, Colors.green),
                _buildCard('Total Unverified Artists', totalUnverifiedArtists, Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, int count, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: color,
              radius: 20,
            ),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(count.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}