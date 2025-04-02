import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:roopkatha/UI/pages/artist/Login/UploadKycScreen.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key, required this.onSuccess});
  final Function onSuccess;

  static MaterialPageRoute getRoute({required Function onSuccess}) {
    return MaterialPageRoute(
      builder: (_) => VerifyOtpScreen(onSuccess: onSuccess),
    );
  }

  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  bool _isLoading = false;

  String? email;

  @override
  void initState() {
    super.initState();
    email = Get.arguments['email'] ?? '';
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> verifyOtp() async {
    setState(() {
      _isLoading = true;
    });

    final requestBody = jsonEncode(<String, String>{
      'email': email!,
      'otp': _otpController.text,
    });
    print('Sending OTP verification request: $requestBody');  // Debug log

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/artist/verifyOTP'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: requestBody,
    );

    print('Received OTP verification response: ${response.statusCode}, ${response.body}');  // Debug log

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['artist'] != null) {
        // Navigate to the KYC upload page
        Get.to(() => UploadKycScreen(), arguments: {'artistId': responseData['artist']['_id']});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("OTP invalid!")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error verifying OTP! Please try again.")),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _submit(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      FocusManager.instance.primaryFocus?.unfocus();
      await verifyOtp();
    }
  }

  Widget _form(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: MediaQuery.of(context).size.width - 32,
      margin: const EdgeInsets.symmetric(vertical: 32) + const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0xffeaeaea),
            offset: Offset(4, 4),
            blurRadius: 10,
          )
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Image.asset('assets/logo.png', height: 150),  // Update with your app icon path
            const SizedBox(height: 10),
            Text(
              "Please enter OTP we’ve sent you on $email",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ).paddingSymmetric(horizontal: 16),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: _otpController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'OTP',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter OTP';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => _submit(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Verify", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          top: false,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                top: -MediaQuery.of(context).size.height * .5,
                left: -MediaQuery.of(context).size.width * .55,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: Colors.pinkAccent,
                      borderRadius: BorderRadius.circular(500),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Theme.of(context).dividerColor,
                            offset: const Offset(0, 4),
                            blurRadius: 5)
                      ]),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 120),
                      Text(
                        "Verify OTP",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontSize: 26, color: Colors.white),
                      ),
                      _form(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}