import 'package:flutter/material.dart';
 class ArtistLogin extends StatefulWidget {
   const ArtistLogin({super.key});

   @override
   State<ArtistLogin> createState() => _ArtistLoginState();
 }
 
 class _ArtistLoginState extends State<ArtistLogin> {
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text('Artist'),
       ) ,
     );
   }
 }
 
