// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:iptv_player_web/view/screen/Admin/HomeAdmin.dart';
// import 'package:iptv_player_web/view/screen/Admin/login.dart' as AdminLogin;
// import 'package:iptv_player_web/view/screen/Admin/login.dart';
// import 'package:iptv_player_web/view/screen/Users/login.dart' as UserLogin;
// import 'package:iptv_player_web/view/screen/Users/login.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // ✅ تهيئة Firebase فقط في بيئة الويب
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

//   await GetStorage.init(); // ✅ تهيئة التخزين المحلي

//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   static final GlobalKey<NavigatorState> navigatorKey =
//       GlobalKey<NavigatorState>(); // ✅ مفتاح ثابت

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       navigatorKey: navigatorKey, // ✅ مفتاح التنقل
//       debugShowCheckedModeBanner: false,
//       title: 'IPTV PLAYER',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       initialRoute: "/user", // ✅ اجعل الصفحة الافتراضية هي تسجيل الأدمن
//       getPages: [
//         GetPage(
//             name: "/admin", page: () => LoginADMIN()), // ✅ صفحة تسجيل الأدمن
//         GetPage(name: "/homeAdmin", page: () => HomeAdmin()),

//         GetPage(name: "/user", page: () => Login()), // ✅ صفحة تسجيل المستخدم
//       ],
//       unknownRoute: GetPage(
//         name: "/notfound",
//         page: () => Scaffold(
//           body: Center(
//               child: Text("404 - الصفحة غير موجودة",
//                   style: TextStyle(fontSize: 20))),
//         ),
//       ), // ✅ معالجة الروابط غير المعروفة
//     );
//   }
// }
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:get_storage/get_storage.dart';
// // import 'package:iptv_player_web/view/screen/Admin/HomeAdmin.dart';
// // import 'package:iptv_player_web/view/screen/Admin/login.dart' as AdminLogin;
// // import 'package:iptv_player_web/view/screen/Users/login.dart' as UserLogin;

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();

// //   // ✅ تهيئة Firebase فقط في بيئة الويب
// //   await Firebase.initializeApp(
// //     options: const FirebaseOptions(
// //       apiKey: "AIzaSyBtBnGBJlMtl-cI-f91fnCOT3LcOzJXfpA",
// //       authDomain: "iptvplayer-d7ecd.firebaseapp.com",
// //       projectId: "iptvplayer-d7ecd",
// //       storageBucket: "iptvplayer-d7ecd.firebasestorage.app",
// //       messagingSenderId: "484404976099",
// //       appId: "1:484404976099:web:77073767e61166d496e8d6",
// //       measurementId: "G-NB3S68HYG3",
// //     ),
// //   );

// //   await GetStorage.init(); // ✅ تهيئة التخزين المحلي

// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   static final GlobalKey<NavigatorState> navigatorKey =
// //       GlobalKey<NavigatorState>(); // ✅ مفتاح ثابت

// //   @override
// //   Widget build(BuildContext context) {
// //     return GetMaterialApp(
// //       navigatorKey: navigatorKey, // ✅ مفتاح التنقل
// //       debugShowCheckedModeBanner: false,
// //       title: 'IPTV PLAYER',
// //       theme: ThemeData(
// //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
// //         useMaterial3: true,
// //       ),
// //       initialRoute: "/user", // ✅ اجعل الصفحة الافتراضية هي تسجيل الأدمن
// //       getPages: [
// //         GetPage(
// //             name: "/admin",
// //             page: () => AdminLogin.Login()), // ✅ صفحة تسجيل الأدمن
// //         GetPage(
// //             name: "/user",
// //             page: () => UserLogin.Login()), // ✅ صفحة تسجيل المستخدم
// //         GetPage(
// //             name: "/homeAdmin",
// //             page: () => HomeAdmin()), // ✅ الصفحة الرئيسية للأدمن
// //       ],
// //       unknownRoute: GetPage(
// //         name: "/notfound",
// //         page: () => Scaffold(
// //           body: Center(
// //               child: Text("404 - الصفحة غير موجودة",
// //                   style: TextStyle(fontSize: 20))),
// //         ),
// //       ), // ✅ معالجة الروابط غير المعروفة
// //     );
// //   }
// // }
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iptv_player_web/view/screen/Admin/HomeAdmin.dart';
import 'package:iptv_player_web/view/screen/Admin/login.dart' as AdminLogin;
import 'package:iptv_player_web/view/screen/Admin/login.dart';
import 'package:iptv_player_web/view/screen/Users/login.dart' as UserLogin;
import 'package:iptv_player_web/view/screen/Users/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ تهيئة Firebase فقط في بيئة الويب
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
      GlobalKey<NavigatorState>(); // ✅ مفتاح ثابت

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey, // ✅ مفتاح التنقل
      debugShowCheckedModeBanner: false,
      title: 'IPTV PLAYER',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: "/user", // ✅ اجعل الصفحة الافتراضية هي تسجيل الأدمن
      getPages: [
        GetPage(
            name: "/admin", page: () => LoginADMIN()), // ✅ صفحة تسجيل الأدمن
        GetPage(
            name: "/homeAdmin",
            page: () => HomeAdmin()), // ✅ الصفحة الرئيسية للأدمن
        GetPage(name: "/user", page: () => Login()),
      ],
      unknownRoute: GetPage(
        name: "/notfound",
        page: () => Scaffold(
          body: Center(
              child: Text("404 - الصفحة غير موجودة",
                  style: TextStyle(fontSize: 20))),
        ),
      ), // ✅ معالجة الروابط غير المعروفة
    );
  }
}
