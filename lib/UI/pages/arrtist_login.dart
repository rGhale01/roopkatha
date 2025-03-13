import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_service.dart';
import 'signup_page.dart';
import 'artist/home_page.dart'; // Assuming you have an ArtistHomePage

class ArtistLoginPage extends StatefulWidget {
  const ArtistLoginPage({super.key});

  @override
  State<ArtistLoginPage> createState() => _ArtistLoginPageState();
}

class _ArtistLoginPageState extends State<ArtistLoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
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
                const Text(
                  "Welcome, Artist!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Manage your bookings and portfolio.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          hintText: "Your Email",
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Email cannot be empty";
                          }
                          email = value;
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          hintText: "Password",
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password cannot be empty";
                          } else if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          password = value;
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot password?",
                      style: TextStyle(color: Colors.pinkAccent),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
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
                      "Sign In",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const SignupPage());
                      },
                      child: const Text(
                        "Sign up",
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final response = await _authService.loginArtist(email, password);

      setState(() {
        _isLoading = false;
      });

      if (response.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['error'])));
      } else if (response.containsKey('message') && response['message'] == 'Validation done') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login successful!')));
        Get.off(() => ArtistHomePage(userId: '',));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed')));
      }
    }
  }
}
