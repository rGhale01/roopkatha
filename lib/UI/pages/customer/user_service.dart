import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = 'http://10.0.2.2:8000';

  get name => null; // Update with your backend URL

  Future<String> fetchUserName(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/customers/$name'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['name'];
    } else {
      throw Exception('Failed to load user data');
    }
  }
}