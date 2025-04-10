import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../service/auth_service.dart';
import '../customer_shared_preferences.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isSaving = false;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  String _customerName = '';
  String _customerEmail = '';
  String _customerPhone = '';
  String _profilePictureUrl = '';
  String? _customerId;
  String? _customerDOB = '';
  String? _customerGender = '';
  String? _authToken = '';

  File? _image;
  String? _imageError;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    _fetchCustomerData();
  }

  Future<void> _fetchCustomerData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _customerName = await CustomerSharedPreferences.getCustomerName() ?? '';
      _customerPhone = await CustomerSharedPreferences.getCustomerNumber() ?? '';
      _profilePictureUrl = await CustomerSharedPreferences.getProfilePictureUrl() ?? '';
      _customerEmail = await CustomerSharedPreferences.getCustomerEmail() ?? '';
      _customerId = await CustomerSharedPreferences.getCustomerID();
      _customerDOB = await CustomerSharedPreferences.getCustomerDOB() ?? '';
      _customerGender = await CustomerSharedPreferences.getCustomerGender() ?? '';
      _authToken = await CustomerSharedPreferences.getAuthToken() ?? '';

      nameController.text = _customerName;
      emailController.text = _customerEmail;
      phoneController.text = _customerPhone;

      print('Fetched customer name: $_customerName');
      print('Fetched customer phone: $_customerPhone');
      print('Fetched customer email: $_customerEmail');
      print('Fetched profile image URL: $_profilePictureUrl');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load customer data')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final filePath = pickedFile.path;
        final mimeType = lookupMimeType(filePath);

        print('Selected image path: $filePath');
        print('Selected image MIME type: $mimeType');

        // Clear any previous error
        setState(() {
          _imageError = null;
        });

        // Validate mime type
        if (mimeType == null) {
          setState(() {
            _imageError = 'Could not determine file type';
          });
          return;
        }

        if (!(mimeType == 'image/jpeg' || mimeType == 'image/png')) {
          setState(() {
            _imageError = 'Only JPEG and PNG files are allowed';
          });
          return;
        }

        setState(() {
          _image = File(filePath);
        });
      } else {
        print('No image selected');
      }
    } catch (e) {
      print('Error picking image: $e');
      setState(() {
        _imageError = 'Error picking image: $e';
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

    // Basic validation
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name cannot be empty')),
      );
      return;
    }

    if (emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email cannot be empty')),
      );
      return;
    }

    if (phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone number cannot be empty')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final url = Uri.parse('http://10.0.2.2:8000/api/customer/update/$_customerId');
    final request = http.MultipartRequest('PUT', url);

    request.headers['Authorization'] = 'Bearer $token';

    request.fields['name'] = nameController.text.trim();
    request.fields['email'] = emailController.text.trim();
    request.fields['phoneNo'] = phoneController.text.trim();

    if (_image != null) {
      try {
        print('Adding image to request: ${_image!.path}');

        // Get the file extension
        final fileExt = path.extension(_image!.path).toLowerCase();

        // Determine content type based on extension
        String contentType;
        if (fileExt == '.jpg' || fileExt == '.jpeg') {
          contentType = 'image/jpeg';
        } else if (fileExt == '.png') {
          contentType = 'image/png';
        } else {
          // Default to jpeg if we can't determine
          contentType = 'image/jpeg';
        }

        // Create multipart file with explicit content type
        final multipartFile = await http.MultipartFile.fromPath(
          'profilePicture',
          _image!.path,
          contentType: MediaType.parse(contentType),
        );

        request.files.add(multipartFile);
      } catch (e) {
        print('Error adding image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding image: $e')),
        );
        setState(() {
          _isSaving = false;
        });
        return;
      }
    } else {
      print('No image selected for upload');
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final updatedData = jsonDecode(response.body);

        // Get the updated profile picture URL if available
        String newProfilePictureUrl = _profilePictureUrl;
        if (updatedData['customer']['profilePictureUrl'] != null) {
          newProfilePictureUrl = updatedData['customer']['profilePictureUrl'];
        }

        // Instead of individual setters, use the saveCustomerData method
        await CustomerSharedPreferences.saveCustomerData(
          customerID: _customerId!,
          customerName: nameController.text.trim(),
          customerEmail: emailController.text.trim(),
          customerNumber: phoneController.text.trim(),
          authToken: _authToken!,
          customerDOB: _customerDOB!,
          customerGender: _customerGender!,
          profilePictureUrl: newProfilePictureUrl,
        );

        // Update the state
        setState(() {
          _customerName = nameController.text.trim();
          _customerEmail = emailController.text.trim();
          _customerPhone = phoneController.text.trim();
          _profilePictureUrl = newProfilePictureUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context); // Navigate back after update
      } else {
        // Parse error response
        String errorMessage = 'Failed to update profile';
        try {
          final errorData = jsonDecode(response.body);
          if (errorData['error'] != null) {
            errorMessage = errorData['error'];
          }
        } catch (_) {}

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: $e')),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  Widget _buildProfilePicture() {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : (_profilePictureUrl.isNotEmpty
                    ? NetworkImage(_profilePictureUrl)
                    : const AssetImage('assets/images/default_profile.png')) as ImageProvider,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_imageError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _imageError!,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfilePicture(),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSaving ? null : _updateProfile,
              child: _isSaving
                  ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2)
              )
                  : const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}