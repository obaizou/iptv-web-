// // import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:iptv_player_web/view/screen/ActivationPage.dart';

// class Login extends StatelessWidget {
//   final TextEditingController macController = TextEditingController();
//   final TextEditingController deviceKeyController = TextEditingController();
//   final ValueNotifier<String> errorMessage = ValueNotifier(""); // لمتابعة الخطأ
//   final ValueNotifier<bool> isLoading =
//       ValueNotifier(false); // لمتابعة حالة التحميل

//   Login({super.key});

//   Future<void> verifyDevice(BuildContext context) async {
//     String macAddress = macController.text.trim();
//     String deviceKey = deviceKeyController.text.trim();

//     if (macAddress.isEmpty || deviceKey.isEmpty) {
//       errorMessage.value = "يرجى إدخال جميع البيانات.";
//       return;
//     }

//     isLoading.value = true; // تشغيل التحميل

//     try {
//       DocumentSnapshot deviceSnapshot = await FirebaseFirestore.instance
//           .collection('devices')
//           .doc(macAddress)
//           .get();

//       if (deviceSnapshot.exists) {
//         String storedDeviceKey = deviceSnapshot.get('device_key');

//         if (storedDeviceKey == deviceKey) {
//           // ✅ نجاح: الانتقال إلى صفحة التفعيل بعد انتظار قصير
//           await Future.delayed(Duration(seconds: 2));
//           isLoading.value = false;
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => ActivationPage(
//                       macAddress: macAddress,
//                     )),
//           );
//           return;
//         } else {
//           errorMessage.value = "رمز الجهاز غير صحيح، يرجى التحقق.";
//         }
//       } else {
//         errorMessage.value = "هذا الجهاز غير مسجل، يرجى التحقق.";
//       }
//     } catch (e) {
//       errorMessage.value = "حدث خطأ أثناء التحقق، حاول مجددًا.";
//       print("❌ خطأ في Firestore: $e");
//     }

//     isLoading.value = false; // إيقاف التحميل في حالة الخطأ
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           ListView(
//             children: [
//               Center(
//                 child: Text(
//                   'Manage Your Playlist',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                 ),
//               ),
//               Center(
//                 child: Text(
//                   'Do It Simply Wherever You Go',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: 300),
//                 padding: EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Color.fromARGB(139, 57, 55, 55),
//                   borderRadius: BorderRadius.all(Radius.circular(20)),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Login to add your playlist',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                           color: Colors.white),
//                     ),
//                     SizedBox(height: 20),
//                     TextFormField(
//                       controller: macController,
//                       decoration: InputDecoration(
//                         labelText: "Mac Address *",
//                         labelStyle: TextStyle(color: Colors.white70),
//                         enabledBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: Colors.white70),
//                         ),
//                         focusedBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: Colors.red),
//                         ),
//                       ),
//                       style: TextStyle(color: Colors.white),
//                       cursorColor: Colors.red,
//                     ),
//                     SizedBox(height: 20),
//                     TextFormField(
//                       controller: deviceKeyController,
//                       decoration: InputDecoration(
//                         labelText: "Device Key *",
//                         labelStyle: TextStyle(color: Colors.white70),
//                         enabledBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: Colors.white70),
//                         ),
//                         focusedBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: Colors.red),
//                         ),
//                       ),
//                       style: TextStyle(color: Colors.white),
//                       cursorColor: Colors.red,
//                     ),
//                     SizedBox(height: 20),
//                     ValueListenableBuilder<String>(
//                       valueListenable: errorMessage,
//                       builder: (context, value, child) {
//                         return value.isNotEmpty
//                             ? Container(
//                                 padding: EdgeInsets.all(10),
//                                 decoration: BoxDecoration(
//                                   color: Colors.red,
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: Text(
//                                   value,
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                               )
//                             : SizedBox.shrink();
//                       },
//                     ),
//                     SizedBox(height: 20),
//                     MaterialButton(
//                       color: Colors.red,
//                       onPressed: () => verifyDevice(context),
//                       child: Text(
//                         'LOGIN',
//                         style: TextStyle(
//                             color: Colors.white, fontWeight: FontWeight.bold),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           // ✅ شاشة تحميل عند الضغط على زر تسجيل الدخول
//           ValueListenableBuilder<bool>(
//             valueListenable: isLoading,
//             builder: (context, loading, child) {
//               return loading
//                   ? Container(
//                       color: Colors.black54,
//                       child: Center(
//                         child: Container(
//                           padding: EdgeInsets.all(20),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               CircularProgressIndicator(color: Colors.red),
//                               SizedBox(height: 15),
//                               Text(
//                                 "Wait Please...",
//                                 style: TextStyle(fontSize: 18),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     )
//                   : SizedBox.shrink();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'dart:html' as html;
import 'package:iptv_player_web/view/screen/Users/ActivationPage.dart';

class Login extends StatelessWidget {
  final TextEditingController macController = TextEditingController();
  final TextEditingController deviceKeyController = TextEditingController();
  final ValueNotifier<String> errorMessage = ValueNotifier("");
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<bool> rememberMe =
      ValueNotifier(false); // ✅ خيار "تذكرني"

  Login({super.key});

  Future<void> verifyDevice(BuildContext context) async {
    String macAddress = macController.text.trim();
    String deviceKey = deviceKeyController.text.trim();

    if (macAddress.isEmpty || deviceKey.isEmpty) {
      errorMessage.value = "يرجى إدخال جميع البيانات.";
      return;
    }

    isLoading.value = true;

    try {
      DocumentSnapshot deviceSnapshot = await FirebaseFirestore.instance
          .collection('devices')
          .doc(macAddress)
          .get();

      if (deviceSnapshot.exists) {
        String storedDeviceKey = deviceSnapshot.get('device_key');

        if (storedDeviceKey == deviceKey) {
          // ✅ إذا كان خيار "تذكرني" مفعلاً، نحفظ الـ MAC Address
          if (rememberMe.value) {
            saveMacAddress(macAddress);
          }

          await Future.delayed(Duration(seconds: 2));
          isLoading.value = false;
          Get.off(ActivationPage(macAddress: macAddress));

          return;
        } else {
          errorMessage.value = "رمز الجهاز غير صحيح، يرجى التحقق.";
        }
      } else {
        errorMessage.value = "هذا الجهاز غير مسجل، يرجى التحقق.";
      }
    } catch (e) {
      errorMessage.value = "حدث خطأ أثناء التحقق، حاول مجددًا.";
      print("❌ خطأ في Firestore: $e");
    }

    isLoading.value = false;
  }

  /// ✅ حفظ MAC Address في `localStorage`
  void saveMacAddress(String macAddress) {
    html.window.localStorage['mac_address'] = macAddress;
  }

  /// ✅ حذف MAC Address عند تسجيل الخروج
  void clearMacAddress() {
    html.window.localStorage.remove('mac_address');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              SizedBox(height: 40),
              Center(
                child: Text(
                  'Manage Your Playlist',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
              Center(
                child: Text(
                  'Do It Simply Wherever You Go',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              SizedBox(height: 30),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 300),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(139, 57, 55, 55),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login to add your playlist',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: macController,
                      decoration: InputDecoration(
                        labelText: "Mac Address *",
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.red,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: deviceKeyController,
                      decoration: InputDecoration(
                        labelText: "Device Key *",
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.red,
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: rememberMe,
                          builder: (context, value, child) {
                            return Checkbox(
                              value: value,
                              onChanged: (newValue) {
                                rememberMe.value = newValue!;
                              },
                              activeColor: Colors.red,
                            );
                          },
                        ),
                        Text(
                          "Remember Me",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ValueListenableBuilder<String>(
                      valueListenable: errorMessage,
                      builder: (context, value, child) {
                        return value.isNotEmpty
                            ? Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  value,
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            : SizedBox.shrink();
                      },
                    ),
                    SizedBox(height: 20),
                    MaterialButton(
                      color: Colors.red,
                      onPressed: () => verifyDevice(context),
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // ✅ شاشة تحميل عند الضغط على زر تسجيل الدخول
          ValueListenableBuilder<bool>(
            valueListenable: isLoading,
            builder: (context, loading, child) {
              return loading
                  ? Container(
                      color: Colors.black54,
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(color: Colors.red),
                              SizedBox(height: 15),
                              Text(
                                "Wait Please...",
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
