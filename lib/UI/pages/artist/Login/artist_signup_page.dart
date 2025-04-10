import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roopkatha/UI/pages/artist/Login/verifyOTP.dart';
import '../../service/auth_service.dart';
import 'package:roopkatha/UI/pages/artist/Login/arrtist_login.dart';

class ArtistSignupPage extends StatefulWidget {
  const ArtistSignupPage({super.key});

  @override
  _ArtistSignupPage createState() => _ArtistSignupPage();
}

class _ArtistSignupPage extends State<ArtistSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController(); // Added confirmPassword controller
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController(); // For displaying DOB as text
  String? _selectedGender; // Dropdown gender selection

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
                const SizedBox(height: 30),
                const Text("Create Account", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.pinkAccent)),
                const SizedBox(height: 5),
                const Text("Create an account so you can find customers!", textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.black87)),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      _buildTextField(_nameController, "Full Name", Icons.person),
                      const SizedBox(height: 15),
                      _buildTextField(_emailController, "Email", Icons.email, keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 15),
                      _buildTextField(_passwordController, "Password", Icons.lock, obscureText: true),
                      const SizedBox(height: 15),
                      _buildTextField(_confirmPasswordController, "Confirm Password", Icons.lock, obscureText: true), // Confirm Password Field
                      const SizedBox(height: 15),

                      // Date of Birth Field (Calendar Picker)
                      GestureDetector(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );

                          if (pickedDate != null) {
                            setState(() {
                              _dobController.text = pickedDate.toLocal().toString().split(' ')[0]; // Format as YYYY-MM-DD
                            });
                          }
                        },
                        child: AbsorbPointer(
                          child: _buildTextField(_dobController, "Date of Birth (YYYY-MM-DD)", Icons.calendar_today),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Phone Number Field
                      _buildTextField(_phoneController, "Phone Number", Icons.phone, keyboardType: TextInputType.phone),
                      const SizedBox(height: 15),

                      // Gender Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person_outline),
                          hintText: "Select Gender",
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: ['Male', 'Female']
                            .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                        validator: (value) => value == null ? 'Please select your gender' : null,
                      ),
                      const SizedBox(height: 30),

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
                              : const Text("Submit", style: TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Do you have an account? "),
                    TextButton(
                      onPressed: () => Get.to(() => const ArtistLoginPage()),
                      child: const Text("Sign In", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.pinkAccent)),
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

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
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
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your $hint';
        }
        if (hint == "Confirm Password" && value != _passwordController.text) {
          return "Passwords do not match";
        }
        return null;
      },
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_dobController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select your Date of Birth")));
        return;
      }

      if (_selectedGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select your Gender")));
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final response = await _authService.registerArtist(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
        _confirmPasswordController.text, // Include confirmPassword
        _dobController.text,
        _phoneController.text,
        _selectedGender!,
      );

      setState(() {
        _isLoading = false;
      });

      if (response.containsKey('message') && response['message'] == 'Artist registered successfully!') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration successful!')));
        Get.to(() => VerifyOtpScreen(onSuccess: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP Verified!')));
          Get.off(() => const ArtistLoginPage());
        }), arguments: {'email': _emailController.text});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'] ?? 'Registration failed')));
      }
    }
  }
}