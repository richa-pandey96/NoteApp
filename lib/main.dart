import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/widgets.dart';
import 'package:note_app/notes_home.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
  ?await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAnMWvaEW7KLSdWfqmbM908NX7e3Pxv_jo',
       appId: '1:991156109377:android:235dea1f366e141c5fc6c0',
        messagingSenderId: '991156109377', 
        projectId: 'noteapp-659cd')
  )
  :await Firebase.initializeApp();

  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  MyApp({super.key});

 @override 
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotesHomesScreen(),


    );
  }
  }