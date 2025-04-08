import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../customer_shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  File? _image;
  String? _profileImageUrl;
  bool isLoading = true;
  String? _customerId;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _customerId = prefs.getString(CustomerSharedPreferences.customerIDKey);

    if (_customerId != null) {
      final url = Uri.parse('http://10.0.2.2:8000/api/customer/$_customerId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          nameController.text = data['name'] ?? '';
          emailController.text = data['email'] ?? '';
          phoneController.text = data['phone'] ?? '';
          _profileImageUrl = data['profilePictureUrl'];
          isLoading = false;
        });
      } else {
        print('Failed to fetch profile');
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print('No customer ID found in shared preferences');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_customerId == null) {
      print('No customer ID found');
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');
    if (token == null) {
      print('No auth token found');
      return;
    }

    final url = Uri.parse('http://10.0.2.2:8000/api/customer/update/$_customerId');
    final Map<String, String> updatedFields = {};

    if (nameController.text.trim().isNotEmpty) {
      updatedFields['name'] = nameController.text.trim();
    }
    if (emailController.text.trim().isNotEmpty) {
      updatedFields['email'] = emailController.text.trim();
    }
    if (phoneController.text.trim().isNotEmpty) {
      updatedFields['phone'] = phoneController.text.trim();
    }

    final response = await http.put(url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(updatedFields),
    );

    if (response.statusCode == 200) {
      if (_image != null) await _uploadProfilePicture(token);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated')),
      );
    } else {
      print('Failed to update profile: ${response.body}');
    }
  }

  Future<void> _uploadProfilePicture(String token) async {
    if (_customerId == null) {
      print('No customer ID found');
      return;
    }

    final url = Uri.parse('http://10.0.2.2:8000/api/customer/$_customerId/profile-picture');
    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('profilePicture', _image!.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      print('Profile picture uploaded');
    } else {
      print('Failed to upload profile picture');
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : (_profileImageUrl != null
                        ? NetworkImage(_profileImageUrl!)
                        : AssetImage('assets/default_avatar.png')) as ImageProvider,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _updateProfile,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}