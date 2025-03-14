import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:iptv_player_web/view/screen/Admin/HomeAdmin.dart'; // ✅ تأكد من استيراد صفحة الأدمن الرئيسية

class Login extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<String> errorMessage = ValueNotifier("");
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<bool> rememberMe = ValueNotifier(false);

  Login({super.key});
  Future<void> verifyDevice(BuildContext context) async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      errorMessage.value = "يرجى إدخال جميع البيانات.";
      return;
    }

    isLoading.value = true;

    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Team')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        var userDoc = userSnapshot.docs.first;
        String storedPassword = userDoc.get('password');

        if (storedPassword == password) {
          isLoading.value = false;
          Get.offAll(() => HomeAdmin());
          return;
        } else {
          errorMessage.value = "كلمة المرور غير صحيحة.";
        }
      } else {
        errorMessage.value = "المستخدم غير موجود.";
      }
    } catch (e) {
      errorMessage.value = "حدث خطأ أثناء التحقق.";
      print("❌ خطأ في Firestore: $e");
    }

    isLoading.value = false;
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
                  'ADMIN PANEL',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
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
                  children: [
                    Text(
                      'Welcome Support',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: "Username *",
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password *",
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                      style: TextStyle(color: Colors.white),
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
                        Text("Remember Me",
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    SizedBox(height: 10),
                    ValueListenableBuilder<String>(
                      valueListenable: errorMessage,
                      builder: (context, value, child) {
                        return value.isNotEmpty
                            ? Text(value, style: TextStyle(color: Colors.red))
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
          ValueListenableBuilder<bool>(
            valueListenable: isLoading,
            builder: (context, loading, child) {
              return loading
                  ? Container(
                      color: Colors.black54,
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.red),
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
