import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roopkatha/UI/pages/artist/Bottomtab/artist_chat.dart';
import 'package:roopkatha/UI/pages/artist/Bottomtab/artist_profile.dart';
import 'package:roopkatha/UI/pages/artist/Bottomtab/home_page.dart';
import 'package:roopkatha/UI/pages/artist/Bottomtab/portfolio.dart';
import 'package:roopkatha/UI/pages/artist/Bottomtab/service_page.dart';





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

class ArtistBottomtab extends StatefulWidget {
  int currentIndex;
  ArtistBottomtab({super.key, required this.currentIndex});

  @override
  State<ArtistBottomtab> createState() =>_ArtistBottomtab();
}

class _ArtistBottomtab extends State<ArtistBottomtab> {
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
            ArtistDashboardPage(),
            transition: Transition.rightToLeftWithFade,
            duration: const Duration(seconds: 1),
          );
          break;
        case 1:
          Get.to(
            ArtistChat(),
            transition: Transition.rightToLeftWithFade,
            duration: const Duration(seconds: 1),
          );
          break;
        case 2:
          Get.to(
            ServicePage(),
            transition: Transition.rightToLeftWithFade,
            duration: const Duration(seconds: 1),
          );
          break;
        case 3:
          Get.to(
            ArtistPortfolioPage(),
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
      selectedItemColor: Colors.pink,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard, size: 30),
          label: 'Dashboard',

        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message, size: 30),
          label: 'Messages',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.miscellaneous_services, size: 30),
          label: 'Service',

        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 30),
          label: 'Profile',
        ),
      ],
    );
  }
}
