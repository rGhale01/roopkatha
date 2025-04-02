import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roopkatha/UI/pages/customer/booking_page.dart';
import 'package:roopkatha/UI/pages/customer/cus_chat_page.dart';
import 'package:roopkatha/UI/pages/customer/cus_profile_page.dart';
import 'explore_page.dart';
import 'home_page.dart';



// Cupertino icons
const String iconFont = 'CupertinoIcons';
const String iconFontPackage = 'cupertino_icons';

const IconData calendar = IconData(
  0xf5b0,
  fontFamily: iconFont,
  fontPackage: iconFontPackage,
);

const IconData chatBubbleText = IconData(
  0xf8bf,
  fontFamily: iconFont,
  fontPackage: iconFontPackage,
);

// Material icons
const IconData explore = IconData(0xe248, fontFamily: 'MaterialIcons');

class CusBottomTabs extends StatefulWidget {
  int currentIndex;
  CusBottomTabs({super.key, required this.currentIndex});

  @override
  State<CusBottomTabs> createState() => _CusBottomTabsState();
}

class _CusBottomTabsState extends State<CusBottomTabs> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
  }

  void onTap(int index) {
    setState(() {
      currentIndex = index;
      switch (currentIndex) {
        case 0:
          Get.to(
            CusHomePage(),
            transition: Transition.rightToLeftWithFade,
            duration: const Duration(seconds: 1),
          );
          break;
        case 1:
          Get.to(
            ExplorePage(),
            transition: Transition.rightToLeftWithFade,
            duration: const Duration(seconds: 1),
          );
          break;
        case 2:
          Get.to(
            BookingPage(),
            transition: Transition.rightToLeftWithFade,
            duration: const Duration(seconds: 1),
          );
          break;
        case 3:
          Get.to(
            CusChatPage(),
            transition: Transition.rightToLeftWithFade,
            duration: const Duration(seconds: 1),
          );
          break;
        case 4:
          Get.to(
            CustomerProfile(),
            transition: Transition.rightToLeftWithFade,
            duration: const Duration(seconds: 1),
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      unselectedFontSize: 0,
      selectedFontSize: 0,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey.withOpacity(0.8),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 30),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(explore, size: 30),
          label: "Explore",
        ),
        BottomNavigationBarItem(
          icon: Icon(calendar, size: 30),
          label: "Booking",
        ),
        BottomNavigationBarItem(
          icon: Icon(chatBubbleText, size: 30),
          label: "Chat",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 30),
          label: "Profile",
        ),
      ],
    );
  }
}
