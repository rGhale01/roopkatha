import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class UploadKycScreen extends StatefulWidget {
  const UploadKycScreen({super.key});

  static MaterialPageRoute getRoute() {
    return MaterialPageRoute(
      builder: (_) => UploadKycScreen(),
    );
  }

  @override
  _UploadKycScreenState createState() => _UploadKycScreenState();
}

class _UploadKycScreenState extends State<UploadKycScreen> {
  File? _citizenshipImage;
  File? _panImage;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();
  final String artistId = Get.arguments['artistId'];

  Future<void> _pickImage(ImageSource source, String type) async {
    final pickedFile = await _picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        if (type == 'citizenship') {
          _citizenshipImage = File(pickedFile.path);
        } else if (type == 'pan') {
          _panImage = File(pickedFile.path);
        }
      }
    });
  }

  Future<void> _uploadKycDocuments(BuildContext context) async {
    if (_citizenshipImage == null || _panImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select both Citizenship and PAN images.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final uri = Uri.parse('http://10.0.2.2:8000/api/upload-kyc/$artistId');
      var request = http.MultipartRequest('POST', uri);

      request.files.add(await http.MultipartFile.fromPath(
        'citizenship',
        _citizenshipImage!.path,
        filename: basename(_citizenshipImage!.path),
      ));

      request.files.add(await http.MultipartFile.fromPath(
        'pan',
        _panImage!.path,
        filename: basename(_panImage!.path),
      ));

      var response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("KYC documents uploaded successfully.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to upload KYC documents.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred while uploading KYC documents.")),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload KYC'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Upload KYC documents for artist ID: $artistId'),
            SizedBox(height: 20),
            _imagePickerButton(context, 'Select Citizenship Image', 'citizenship'),
            _imagePreview(_citizenshipImage),
            SizedBox(height: 20),
            _imagePickerButton(context, 'Select PAN Image', 'pan'),
            _imagePreview(_panImage),
            SizedBox(height: 20),
            _uploadButton(context),
          ],
        ),
      ),
    );
  }

  Widget _imagePickerButton(BuildContext context, String title, String type) {
    return ElevatedButton(
      onPressed: () => _pickImage(ImageSource.gallery, type),
      child: Text(title),
    );
  }

  Widget _imagePreview(File? image) {
    return image == null
        ? Text('No image selected.')
        : Image.file(
      image,
      height: 200,
    );
  }

  Widget _uploadButton(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator()
        : ElevatedButton(
      onPressed: () => _uploadKycDocuments(context),
      child: Text('Upload KYC Documents'),
    );
  }
}