import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../../welcome_page.dart';

class KycUploadedDialog extends StatelessWidget {
  final String message;

  const KycUploadedDialog({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      insetPadding: const EdgeInsets.all(40),
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circle with check icon
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Color(0xFFFF5EDB), // pink color
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.black, size: 24),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'KYC Uploaded',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 100,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF5EDB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to welcome screen after closing dialog
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                        (route) => false, // Remove all previous routes
                  );
                },
                child: const Text(
                    'Ok',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UploadKycScreen extends StatefulWidget {
  const UploadKycScreen({super.key});

  static MaterialPageRoute getRoute() {
    return MaterialPageRoute(
      builder: (_) => const UploadKycScreen(),
    );
  }

  @override
  _UploadKycScreenState createState() => _UploadKycScreenState();
}

class _UploadKycScreenState extends State<UploadKycScreen> {
  File? _citizenshipImage;
  File? _panImage;
  bool _isLoading = false;
  String? _citizenshipError;
  String? _panError;

  final ImagePicker _picker = ImagePicker();
  late final String artistId;

  @override
  void initState() {
    super.initState();
    // Get the artistId from arguments
    artistId = Get.arguments['artistId'];
  }

  // Helper method to validate image type
  bool _isValidImageType(String? mimeType) {
    return mimeType != null &&
        (mimeType == 'image/jpeg' ||
            mimeType == 'image/png' ||
            mimeType == 'image/jpg');
  }

  Future<void> _pickImage(ImageSource source, String type) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1000, // Compress image for better upload
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final filePath = pickedFile.path;
        final mimeType = lookupMimeType(filePath);

        print('Selected $type image: $filePath');
        print('MIME Type: $mimeType');

        if (!_isValidImageType(mimeType)) {
          setState(() {
            if (type == 'citizenship') {
              _citizenshipError = 'Only JPEG and PNG files are allowed';
              _citizenshipImage = null;
            } else {
              _panError = 'Only JPEG and PNG files are allowed';
              _panImage = null;
            }
          });
          return;
        }

        // Clear any previous error
        setState(() {
          if (type == 'citizenship') {
            _citizenshipImage = File(pickedFile.path);
            _citizenshipError = null;
          } else if (type == 'pan') {
            _panImage = File(pickedFile.path);
            _panError = null;
          }
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      setState(() {
        if (type == 'citizenship') {
          _citizenshipError = 'Error selecting image: $e';
        } else {
          _panError = 'Error selecting image: $e';
        }
      });
    }
  }

  Future<void> _uploadKycDocuments(BuildContext context) async {
    if (_citizenshipImage == null || _panImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select both Citizenship and PAN images.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final uri = Uri.parse('http://10.0.2.2:8000/api/upload-kyc/$artistId');
      var request = http.MultipartRequest('POST', uri);

      // Add citizenship image with proper MIME type
      final citizenshipExtension = extension(_citizenshipImage!.path).toLowerCase();
      final citizenshipMimeType = citizenshipExtension == '.png' ? 'image/png' : 'image/jpeg';

      request.files.add(await http.MultipartFile.fromPath(
        'citizenship',
        _citizenshipImage!.path,
        contentType: MediaType.parse(citizenshipMimeType),
        filename: basename(_citizenshipImage!.path),
      ));

      // Add PAN image with proper MIME type
      final panExtension = extension(_panImage!.path).toLowerCase();
      final panMimeType = panExtension == '.png' ? 'image/png' : 'image/jpeg';

      request.files.add(await http.MultipartFile.fromPath(
        'pan',
        _panImage!.path,
        contentType: MediaType.parse(panMimeType),
        filename: basename(_panImage!.path),
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('KYC upload status code: ${response.statusCode}');
      print('KYC upload response body: ${response.body}');

      if (response.statusCode == 200) {
        _showDialog(context, "Documents uploaded successfully.\nYour account will be fully activated\nonce the verification is complete.");
      } else {
        // Try to parse error message
        String errorMessage = "Failed to upload KYC documents.";
        try {
          final responseData = json.decode(response.body);
          if (responseData['error'] != null) {
            errorMessage = responseData['error'];
          }
        } catch (_) {}

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      print('Error uploading KYC documents: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap button to close dialog
      builder: (BuildContext context) {
        return KycUploadedDialog(message: message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/logo.png", height: 80),
              const SizedBox(height: 10),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "Roop",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    TextSpan(
                      text: "Katha",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Verify KYC',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please Submit Your Documents to get Verified',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black45,
                ),
              ),
              const SizedBox(height: 30),

              // Citizenship Image Section
              const Text(
                'Citizenship Document',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildImagePickerSection(
                  context: context,
                  image: _citizenshipImage,
                  error: _citizenshipError,
                  type: 'citizenship'
              ),
              const SizedBox(height: 20),

              // PAN Image Section
              const Text(
                'PAN Document',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildImagePickerSection(
                  context: context,
                  image: _panImage,
                  error: _panError,
                  type: 'pan'
              ),
              const SizedBox(height: 24),

              // Upload Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7DE5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _isLoading ? null : () => _uploadKycDocuments(context),
                  child: _isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    'Submit Documents',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePickerSection({
    required BuildContext context,
    required File? image,
    required String? error,
    required String type,
  }) {
    // When no image is selected, show a small container
    if (image == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 100, // Small height when no image
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: error != null ? Colors.red : Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: InkWell(
              onTap: () => _showImageSourceActionSheet(context, type),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate, size: 40, color: Color(0xFFFF7DE5)),
                    SizedBox(height: 8),
                    Text(
                      'Tap to select image',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      );
    }

    // When an image is selected, adjust to image size while maintaining max constraints
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          constraints: const BoxConstraints(
            minHeight: 100, // Minimum height
            maxHeight: 300, // Maximum height allowed
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: error != null ? Colors.red : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              // Image displayed to fit its natural size
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Image.file(
                    image,
                    fit: BoxFit.contain, // Contains the image in available space
                    width: double.infinity,
                  ),
                ),
              ),

              // Close button
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.close, color: Colors.white, size: 16),
                    onPressed: () {
                      setState(() {
                        if (type == 'citizenship') {
                          _citizenshipImage = null;
                        } else {
                          _panImage = null;
                        }
                      });
                    },
                  ),
                ),
              ),

              // Edit button
              Positioned(
                bottom: 8,
                right: 8,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.edit, color: Colors.white, size: 16),
                    onPressed: () => _showImageSourceActionSheet(context, type),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  void _showImageSourceActionSheet(BuildContext context, String type) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Select Image Source",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Color(0xFFFF7DE5)),
                  title: const Text('Take a Photo'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.camera, type);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library, color: Color(0xFFFF7DE5)),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.gallery, type);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}