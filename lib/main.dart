import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:html' as html; // ✅ استيراد localStorage لاستخدامه على الويب
import 'package:iptv_player_web/view/screen/Users/ActivationPage.dart';
import 'package:iptv_player_web/view/screen/Users/login.dart';

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

  String? savedMacAddress = getSavedMacAddress();

  runApp(MyApp(
      initialPage: savedMacAddress != null
          ? ActivationPage(macAddress: savedMacAddress)
          : Login()));
}

/// ✅ استرجاع MAC Address من `localStorage`
String? getSavedMacAddress() {
  return html.window.localStorage['mac_address'];
}

/// ✅ حفظ MAC Address عند تسجيل الدخول
void saveMacAddress(String macAddress) {
  html.window.localStorage['mac_address'] = macAddress;
}

/// ✅ مسح MAC Address عند تسجيل الخروج
void clearMacAddress() {
  html.window.localStorage.remove('mac_address');
}

class MyApp extends StatelessWidget {
  final Widget initialPage;

  const MyApp({super.key, required this.initialPage});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IPTV PLAYER',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: initialPage, // ✅ تحديد الصفحة الأولى بناءً على تسجيل الدخول
    );
  }
}
