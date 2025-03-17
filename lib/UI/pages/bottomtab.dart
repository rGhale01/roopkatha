import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roopkatha/UI/screen/booking_page.dart';
import '../screen/chat_page.dart';
import '../screen/explore_page.dart';
import '../screen/profile_page.dart';
import 'customer/home_page.dart';

// Cupertino icons
const String iconFont = 'CupertinoIcons';
const String iconFontPackage = 'cupertino_icons';

const IconData calendar = IconData(
  0xf5b0,
  fontFamily: iconFont,
  fontPackage: iconFontPackage,
);

const IconData chat_bubble_text = IconData(
  0xf8bf,
  fontFamily: iconFont,
  fontPackage: iconFontPackage,
);

// Material icons
const IconData explore = IconData(0xe248, fontFamily: 'MaterialIcons');





// ignore: must_be_immutable
class BottomTabs extends StatefulWidget {
  int currentIndex;
  final Function(int) onItemTapped;

  BottomTabs({Key? key, required this.currentIndex, required this.onItemTapped}) : super(key: key);

  @override
  State<BottomTabs> createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
  }

  void onTap(int index) {
    widget.onItemTapped(index);
    setState(() {
      currentIndex = index;
      if (currentIndex == 0) {
        Get.to(
           CusHomePage(), // Replace with actual user ID
          transition: Transition.rightToLeftWithFade,
          duration: const Duration(seconds: 1),
        );
      } else if (currentIndex == 1) {
        Get.to(
           ExplorePage(),
          transition: Transition.rightToLeftWithFade,
          duration: const Duration(seconds: 1),
        );
      } else if (currentIndex == 2) {
        Get.to(
           BookingPage(),
          transition: Transition.rightToLeftWithFade,
          duration: const Duration(seconds: 1),
        );
      } else if (currentIndex == 3) {
        Get.to(
           ChatPage(),
          transition: Transition.rightToLeftWithFade,
          duration: const Duration(seconds: 1),
        );
      } else if (currentIndex == 4) {
        Get.to(
           ProfilePage(),
          transition: Transition.rightToLeftWithFade,
          duration: const Duration(seconds: 1),
        );
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
          label: "Calendar",
        ),
        BottomNavigationBarItem(
          icon: Icon(chat_bubble_text, size: 30),
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