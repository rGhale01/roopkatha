import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:roopkatha/UI/pages/artist/artist_shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<Map<String, dynamic>> registerCustomer(String fullName, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/customer/CustomerRegister'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': fullName,
          'email': email,
          'password': password,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Error: $e');
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> loginCustomer(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/customer/CustomerLogin'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Login response data: $responseData'); // Debug statement

        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Store the customer ID and auth token in SharedPreferences, handling potential null values
        String customerID = responseData['customer']['_id'] ?? '';
        String? authToken = responseData['token']; // Ensure the correct key is used

        await prefs.setString('customerID', customerID);
        print('Stored customer ID: $customerID'); // Debug statement
        if (authToken != null) {
          await prefs.setString('authToken', authToken);
          print('Stored auth token: $authToken'); // Debug statement
        } else {
          print('Auth token is null'); // Debug statement
        }

        return responseData;
      } else {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Error: $e');
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> registerArtist(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/artist/ArtistRegister'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Error: $e');
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> loginArtist(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/artist/ArtistLogin'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Login response data: $responseData'); // Debug statement

        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Store the artist ID and auth token in SharedPreferences, handling potential null values
        String artistID = responseData['artist']['_id'] ?? '';
        String? authToken = responseData['token']; // Ensure the correct key is used

        await ArtistSharedPreferences.setArtistID(artistID);
        print('Stored artist ID: $artistID'); // Debug statement
        if (authToken != null) {
          await ArtistSharedPreferences.setAuthToken(authToken);
          print('Stored auth token: $authToken'); // Debug statement
        } else {
          print('Auth token is null'); // Debug statement
        }

        return responseData;
      } else {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Error: $e');
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> logoutArtist() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authToken');
      print('Retrieved token for logout: $token'); // Debug statement
      if (token == null) {
        return {'error': 'No active session found'};
      }

      final response = await http.post(
        Uri.parse('$baseUrl/artist/logout'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Ensure 'Bearer' prefix
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        await ArtistSharedPreferences.clearArtistPreferences(); // Clear the shared preferences on successful logout
        await prefs.clear(); // Clear all SharedPreferences on successful logout
        return json.decode(response.body);
      } else {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Error: $e');
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> logoutCustomer() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authToken');
      print('Retrieved token for logout: $token'); // Debug statement
      if (token == null) {
        return {'error': 'No active session found'};
      }

      final response = await http.post(
        Uri.parse('$baseUrl/customer/logout'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Ensure 'Bearer' prefix
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        await prefs.clear(); // Clear all SharedPreferences on successful logout
        return json.decode(response.body);
      } else {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Error: $e');
      return {'error': e.toString()};
    }
  }
}