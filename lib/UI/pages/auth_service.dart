import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'http://10.0.2.2:8000';

  Future<Map<String, dynamic>> registerCustomer(
      String fullName, String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/customers/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': fullName,
          'username': username,
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
        Uri.parse('$baseUrl/customers/login'),
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
      String name, String email, String password, String specialization,) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/artist/ArtistRegister'), // Corrected endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'email': email,
          'password': password,
          'specialization': specialization,
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