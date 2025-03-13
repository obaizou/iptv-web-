import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iptv_player_web/view/screen/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyBtBnGBJlMtl-cI-f91fnCOT3LcOzJXfpA",
          authDomain: "iptvplayer-d7ecd.firebaseapp.com",
          projectId: "iptvplayer-d7ecd",
          storageBucket: "iptvplayer-d7ecd.firebasestorage.app",
          messagingSenderId: "484404976099",
          appId: "1:484404976099:web:77073767e61166d496e8d6",
          measurementId: "G-NB3S68HYG3"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IPTV PLAYER',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Login(),
    );
  }
}
