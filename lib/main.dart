import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roopkatha/UI/pages/customer/home_page.dart';
import 'package:roopkatha/UI/pages/login_page.dart';
import 'package:roopkatha/UI/pages/signup_page.dart';
import 'package:roopkatha/UI/pages/artist_signup_page.dart';
import 'package:http/http.dart' as http;
import 'UI/pages/welcome_page.dart';
import 'UI/theme/colors.dart' as color;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Timer? timer;
  bool isLoading = false;
  bool isLoggedIn = false;

  get box => null;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    timer = Timer.periodic(
        const Duration(minutes: 5), (Timer t) => refreshToken());
  }

  Future<void> checkLoginStatus() async {
    if (box.read("token") != null) {
      await refreshToken();
      setState(() {
        isLoggedIn = true;
      });
    }
    setState(() {
      isLoading = true;
    });
  }

  Future<void> refreshToken() async {
    if (box.read("token") == null) return;

    const url = "http://10.0.2.2:8000/api/refresh";
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "refresh_token": box.read("token")["refresh_token"],
      }),
    );

    if (response.statusCode == 200) {
      final decodeToken = jsonDecode(response.body);
      box.write("token", decodeToken);
      setState(() {
        isLoggedIn = true;
      });
    } else {
      setState(() {
        isLoggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'RoopKatha',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.lato().fontFamily,
      ),
      home: isLoading ? const CircularProgressIndicator() : (isLoggedIn ? HomePage(userId: '',) : const WelcomeScreen()),
    );
  }
}