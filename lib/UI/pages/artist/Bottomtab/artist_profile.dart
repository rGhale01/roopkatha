import 'package:flutter/material.dart';
import 'package:roopkatha/UI/pages/artist/Bottomtab/artist_bottomtab.dart';

class ArtistProfile extends StatefulWidget {
  const ArtistProfile({super.key});

  @override
  State<ArtistProfile> createState() => _ArtistProfile();
}

class _ArtistProfile extends State<ArtistProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: const Center(child: Text('Welcome to the Chat Page!')),
      bottomNavigationBar: ArtistBottomtab(
        currentIndex: 3,
      ),
    );
  }
}
