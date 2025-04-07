import 'package:flutter/material.dart';
import 'package:roopkatha/UI/pages/artist/Bottomtab/artist_bottomtab.dart';

class ArtistChat extends StatefulWidget {
  const ArtistChat({super.key});

  @override
  State<ArtistChat> createState() => _ArtistChat();
}

class _ArtistChat extends State<ArtistChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: const Center(child: Text('Welcome to the Chat Page!')),
      bottomNavigationBar: ArtistBottomtab(
        currentIndex: 1,
      ),
    );
  }
}
