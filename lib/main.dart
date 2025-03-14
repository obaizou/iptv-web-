import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:html' as html;
import 'package:iptv_player_web/view/screen/Users/login.dart';
import 'package:iptv_player_web/view/screen/Users/ActivationPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ تهيئة Firebase
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBtBnGBJlMtl-cI-f91fnCOT3LcOzJXfpA",
      authDomain: "iptvplayer-d7ecd.firebaseapp.com",
      projectId: "iptvplayer-d7ecd",
      storageBucket: "iptvplayer-d7ecd.firebasestorage.app",
      messagingSenderId: "484404976099",
      appId: "1:484404976099:web:77073767e61166d496e8d6",
      measurementId: "G-NB3S68HYG3",
    ),
  );

  await GetStorage.init(); // ✅ تهيئة التخزين المحلي

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>(); // ✅ مفتاح التنقل

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'IPTV PLAYER',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: CheckRememberMe(), // ✅ التحقق من حالة المستخدم
    );
  }
}

/// ✅ هذه الصفحة تتحقق عند بدء التشغيل مما إذا كان المستخدم قد قام بتفعيل "تذكرني"
class CheckRememberMe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 500), () {
      String? savedMac = html.window.localStorage['mac_address'];

      if (savedMac != null && savedMac.isNotEmpty) {
        Get.off(() => ActivationPage(
            macAddress:
                savedMac)); // ✅ إذا كان هناك Mac مخزن، انتقل إلى ActivationPage
      } else {
        Get.off(() => Login()); // ✅ خلاف ذلك، انتقل إلى Login
      }
    });

    return Scaffold(
      body: Center(child: CircularProgressIndicator()), // ✅ شاشة تحميل مؤقتة
    );
  }
}
