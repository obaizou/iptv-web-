import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iptv_player_web/view/screen/Admin/HomeAdmin.dart';
import 'package:iptv_player_web/view/screen/Admin/login.dart' as AdminLogin;
import 'package:iptv_player_web/view/screen/Users/login.dart' as UserLogin;

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

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IPTV PLAYER',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: "/user", // ✅ اجعل الصفحة الافتراضية هي الرئيسية
      getPages: [
        GetPage(
            name: "/admin",
            page: () => AdminLogin.Login()), // ✅ صفحة تسجيل الأدمن
        GetPage(
            name: "/user",
            page: () => UserLogin.Login()), // ✅ صفحة تسجيل المستخدم
        GetPage(
            name: "/homeAdmin",
            page: () => HomeAdmin()), // ✅ صفحة الأدمن الرئيسية
      ],
    );
  }
}
