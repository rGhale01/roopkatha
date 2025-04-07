import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roopkatha/UI/pages/customer/login_page.dart';
import '../service/auth_service.dart';
import 'CusVerifyOTP.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController(); // <-- New phone number controller

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
                      _buildTextField(_emailController, "Email", Icons.email, keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 15),
                      _buildTextField(_passwordController, "Password", Icons.lock, obscureText: true),
                      const SizedBox(height: 15),
                      _buildTextField(_phoneController, "Phone Number", Icons.phone, keyboardType: TextInputType.phone),
                      const SizedBox(height: 30),

                      // "Submit" Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // "Already have an account?" Text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? "),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const CustomerLoginPage());
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.pinkAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, IconData icon, {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Enter your $hintText' : null,
    );
  }

// Form Submission Function
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final response = await _authService.registerCustomer(
        _fullNameController.text,
        _emailController.text,
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (response.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['error'])));
      } else if (response.containsKey('message') && response['message'] == 'Customer registered successfully!') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration successful!')));
        Get.to(() => VerifyOtpCustomerScreen(onSuccess: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP Verified!')));
          Get.off(() => const CustomerLoginPage());
        }), arguments: {'email': _emailController.text});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration failed')));
      }
    }
  }
}