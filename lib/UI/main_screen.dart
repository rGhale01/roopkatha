import 'package:flutter/material.dart';
import 'package:roopkatha/UI/pages/customer/cus_profile_page.dart';
import 'package:roopkatha/UI/pages/customer/home_page.dart';
import 'package:roopkatha/UI/screen/booking_page.dart';
import 'package:roopkatha/UI/screen/chat_page.dart';
import 'package:roopkatha/UI/screen/explore_page.dart';


class MainScreen extends StatelessWidget {
  final int index;

  MainScreen({required this.index});

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (index) {
      case 0:
        page = CusHomePage();
        break;
      case 1:
        page = ExplorePage();
        break;
      case 2:
        page = BookingPage();
        break;
      case 3:
        page = ChatPage();
        break;
      case 4:
        page = ProfilePage();
        break;
      default:
        page = CusHomePage();
    }

    return page;
  }
}