import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../artist/artist_shared_preferences.dart';
import '../customer/customer_shared_preferences.dart';
import 'package:intl/intl.dart'; // You

class AuthService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<Map<String, dynamic>> registerCustomer(
      String fullName,
      String email,
      String password,
      String confirmPassword,
      String phoneNo,
      DateTime dob, // Change dob to DateTime type
      String gender) async {
    try {
      // Format the DateTime object to ISO 8601 string (YYYY-MM-DD)
      String formattedDob = DateFormat('yyyy-MM-dd').format(dob);

      final response = await http.post(
        Uri.parse('$baseUrl/customer/CustomerRegister'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': fullName,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
          'phoneNo': phoneNo,
          'DOB': formattedDob, // Use the formatted DOB
          'gender': gender,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['error']);
      }
    } catch (e) {
      print('Error: $e');
      return {'error': e.toString()};
    }
  }



  Future<Map<String, dynamic>> loginCustomer(String identifier, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/customer/CustomerLogin'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'identifier': identifier, // Can be email or phone number
          'password': password,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Login response data: $responseData'); // Debug statement

        // Save customer data
        await CustomerSharedPreferences.saveCustomerData(
          customerID: responseData['customer']['_id'] ?? '',
          customerName: responseData['customer']['name'] ?? '',
          customerEmail: responseData['customer']['email'] ?? '',
          authToken: responseData['token'] ?? '',
          customerNumber: responseData['customer']['phoneNo'] ?? '',
          customerDOB: responseData['customer']['DOB'] ?? '',
          customerGender: responseData['customer']['gender'] ?? '',
          profilePictureUrl: responseData['customer']['profilePictureUrl'] ?? '',
        );

        return responseData;
      } else {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Error: $e');
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> fetchCustomerDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? customerID = prefs.getString(CustomerSharedPreferences.customerIDKey);
      if (customerID == null) {
        return {'error': 'No customer ID found'};
      }

      final response = await http.get(
        Uri.parse('$baseUrl/customer/$customerID'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Error: $e');
      return {'error': e.toString()};
    }
  }


  Future<Map<String, dynamic>> registerArtist(
      String name,
      String email,
      String password,
      String confirmPassword, // Added confirmPassword
      String dob,
      String phoneNo,
      String gender) async {
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
          'confirmPassword': confirmPassword, // Include confirmPassword
          'DOB': dob, // Include DOB
          'phoneNo': phoneNo, // Include phoneNo
          'gender': gender, // Include gender
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

  // Artist Login (No changes required)
  Future<Map<String, dynamic>> loginArtist(String identifier, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/artist/ArtistLogin'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'identifier': identifier, // Can be email or phone number
          'password': password,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Save artist data
        await ArtistSharedPreferences.saveArtistData(
          artistID: responseData['artist']['_id'] ?? '',
          artistName: responseData['artist']['name'] ?? '',
          artistEmail: responseData['artist']['email'] ?? '',
          authToken: responseData['token'] ?? '',
          artistPhoneNo: responseData['artist']['phoneNo'] ?? '',
          artistDOB: responseData['artist']['DOB'] ?? '',
          artistGender: responseData['artist']['gender'] ?? '',
        );

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