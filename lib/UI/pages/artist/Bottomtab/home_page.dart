import 'package:flutter/material.dart';
import 'package:roopkatha/UI/pages/artist/Bottomtab/artist_bottomtab.dart';

class ArtistHomePage extends StatelessWidget {
  const ArtistHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HomePage')),
      body: const Center(child: Text('Welcome to the Artist Home Page!')),
      bottomNavigationBar: ArtistBottomtab(
        currentIndex: 3,
      ),
    );
  }
}