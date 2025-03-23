import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:roopkatha/UI/pages/artist/artist_shared_preferences.dart';

class AddService extends StatefulWidget {
  @override
  _AddServiceState createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  bool _isLoading = false;
  String? _artistID;

  @override
  void initState() {
    super.initState();
    _loadArtistID();
  }

  Future<void> _loadArtistID() async {
    _artistID = await ArtistSharedPreferences.getArtistID();
    print('Artist ID: $_artistID');
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _artistID != null) {
      setState(() {
        _isLoading = true;
      });

      print('Submitting form with data:');
      print('Artist ID: $_artistID');
      print('Name: ${_nameController.text}');
      print('Description: ${_descriptionController.text}');
      print('Price: ${_priceController.text}');
      print('Duration: ${_durationController.text}');

      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8000/service/create'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'artistID': _artistID,
            'name': _nameController.text,
            'description': _descriptionController.text,
            'price': double.parse(_priceController.text),
            'duration': int.parse(_durationController.text),
          }),
        );

        setState(() {
          _isLoading = false;
        });

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Service created successfully')));
          _formKey.currentState!.reset();
        } else {
          print('Failed to create service. Response: ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create service: ${response.reasonPhrase}')));
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print('Error submitting form: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error submitting form: $e')));
      }
    } else {
      print('Form validation failed or missing artistID');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Service')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _buildTextField(_nameController, 'Name', Icons.edit, TextInputType.text),
              SizedBox(height: 15),
              _buildTextField(_descriptionController, 'Description', Icons.description, TextInputType.text),
              SizedBox(height: 15),
              _buildTextField(_priceController, 'Price', Icons.attach_money, TextInputType.number),
              SizedBox(height: 15),
              _buildTextField(_durationController, 'Duration (minutes)', Icons.timer, TextInputType.number),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.pinkAccent)
                    : Text('Submit', style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, TextInputType keyboardType) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Please enter your $hint' : null,
    );
  }
}