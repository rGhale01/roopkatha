import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'http://10.0.2.2:8000'; // Update with your machine's IP address for physical devices

  Future<Map<String, dynamic>> register(
      String fullName, String username, String email, String password, String dob, String gender) async {
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
          // Remove dob and gender if not used in backend
          // 'dob': dob,
          // 'gender': gender,
        }),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        return json.decode(response.body);
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
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

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return json.decode(response.body);
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}