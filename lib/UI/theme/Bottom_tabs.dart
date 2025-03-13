// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:roopkatha/UI/pages/customer/home_page.dart';
// import 'package:roopkatha/UI/pages/booking_page.dart';
// import 'package:roopkatha/UI/pages/chat_page.dart';
// import 'package:roopkatha/UI/pages/customer/cus_profile_page.dart';
// import 'package:roopkatha/UI/pages/search_page.dart';
//
// class BottomTabs extends StatefulWidget {
//   final int currentIndex;
//   const BottomTabs({Key? key, required this.currentIndex}) : super(key: key);
//
//   @override
//   State<BottomTabs> createState() => _BottomTabsState();
// }
//
// class _BottomTabsState extends State<BottomTabs> {
//   late int currentIndex;
//
//   void onTap(int index) {
//     if (index == currentIndex) return; // Prevent unnecessary navigation
//
//     setState(() {
//       currentIndex = index;
//       switch (index) {
//         case 0:
//           Get.to(() => const HomePage(),
//               transition: Transition.rightToLeftWithFade,
//               duration: const Duration(milliseconds: 500));
//           break;
//         case 1:
//           Get.to(() => const SearchPage(),
//               transition: Transition.rightToLeftWithFade,
//               duration: const Duration(milliseconds: 500));
//           break;
//         case 2:
//           Get.to(() => const BookingPage(),
//               transition: Transition.rightToLeftWithFade,
//               duration: const Duration(milliseconds: 500));
//           break;
//         case 3:
//           Get.to(() => const ChatPage(),
//               transition: Transition.rightToLeftWithFade,
//               duration: const Duration(milliseconds: 500));
//           break;
//         case 4:
//           Get.to(() => const ProfilePage(),
//               transition: Transition.rightToLeftWithFade,
//               duration: const Duration(milliseconds: 500));
//           break;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     currentIndex = widget.currentIndex;
//
//     return Container(
//         decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.only(
//         topLeft:
