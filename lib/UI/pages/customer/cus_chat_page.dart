import 'package:flutter/material.dart';
import 'package:roopkatha/UI/pages/customer/bottomtab.dart';

class CusChatPage extends StatefulWidget {
  const CusChatPage({super.key});

  @override
  State<CusChatPage> createState() => _CusChatPageState();
}

class _CusChatPageState extends State<CusChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: const Center(child: Text('Welcome to the Chat Page!')),
      bottomNavigationBar: CusBottomTabs(
        currentIndex: 3,
      ),
    );
  }
}
