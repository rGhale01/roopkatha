import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For Date Picker
import 'auth_service.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  String? _selectedGender;
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo and App Name
                Column(
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
                  ],
                ),
                const SizedBox(height: 30),

                // Title
                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.pinkAccent,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Create an account so you can Find the best Artist Around!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                // Form Fields
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      _buildTextField(_fullNameController, "Full Name", Icons.person),
                      const SizedBox(height: 15),
                      _buildTextField(_usernameController, "Username", Icons.account_circle),
                      const SizedBox(height: 15),
                      _buildTextField(_emailController, "Email", Icons.email, keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 15),
                      _buildTextField(_passwordController, "Password", Icons.lock, obscureText: true),
                      const SizedBox(height: 15),

                      // Date of Birth Field
                      TextFormField(
                        controller: _dobController,
                        readOnly: true,
                        onTap: _pickDate,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.calendar_today),
                          hintText: "Date of Birth",
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) => value!.isEmpty ? 'Select your date of birth' : null,
                      ),
                      const SizedBox(height: 15),

                      // Gender Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.transgender),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        hint: const Text("Gender"),
                        items: ["Male", "Female", "Other"].map((String gender) {
                          return DropdownMenuItem(value: gender, child: Text(gender));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                        validator: (value) => value == null ? "Select your gender" : null,
                      ),
                      const SizedBox(height: 30),

                      // "Next" Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                            "Submit",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Login Redirect
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Do you have an account? "),
                    TextButton(
                      onPressed: () => Get.to(() => const LoginPage()),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.pinkAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for building text fields
  Widget _buildTextField(TextEditingController controller, String hint, IconData icon,
      {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
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

  // Date Picker Function
  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  // Form Submission Function
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final response = await _authService.registerCustomer(
        _fullNameController.text,
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (response.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['error'])));
      } else if (response.containsKey('message') && response['message'] == 'Customer Registered') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration successful!')));
        // Navigate to the login screen
        Get.off(() => const LoginPage());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration failed')));
      }
    }
  }
}