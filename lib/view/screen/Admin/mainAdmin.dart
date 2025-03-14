// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:iptv_player_web/view/screen/Admin/login.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // ✅ تهيئة Firebase
//   await Firebase.initializeApp(
//     options: const FirebaseOptions(
//       apiKey: "AIzaSyBtBnGBJlMtl-cI-f91fnCOT3LcOzJXfpA",
//       authDomain: "iptvplayer-d7ecd.firebaseapp.com",
//       projectId: "iptvplayer-d7ecd",
//       storageBucket: "iptvplayer-d7ecd.firebasestorage.app",
//       messagingSenderId: "484404976099",
//       appId: "1:484404976099:web:77073767e61166d496e8d6",
//       measurementId: "G-NB3S68HYG3",
//     ),
//   );

//   await GetStorage.init();

//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   static final GlobalKey<NavigatorState> navigatorKey =
//       GlobalKey<NavigatorState>();

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       navigatorKey: navigatorKey,
//       debugShowCheckedModeBanner: false,
//       title: 'IPTV PLAYER',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: LoginADMIN(),
//     );
//   }
// }
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iptv_player_web/view/screen/Admin/HomeAdmin.dart';
import 'package:iptv_player_web/view/screen/Admin/login.dart';

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

  final GetStorage box = GetStorage(); // ✅ التخزين المحلي

  @override
  Widget build(BuildContext context) {
    // ✅ التحقق مما إذا كان المستخدم مسجلاً للدخول
    bool isLoggedIn = box.hasData('username') && box.hasData('password');

    return GetMaterialApp(
      navigatorKey: navigatorKey, // ✅ مفتاح التنقل
      debugShowCheckedModeBanner: false,
      title: 'IPTV PLAYER',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:
          isLoggedIn ? HomeAdmin() : LoginADMIN(), // ✅ توجيه حسب حالة المستخدم
    );
  }
}
