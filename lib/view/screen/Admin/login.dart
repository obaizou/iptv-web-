import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // ✅ لتخزين بيانات المستخدم

class LoginADMIN extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<String> errorMessage = ValueNotifier("");
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final GetStorage box = GetStorage(); // ✅ التخزين المحلي

  LoginADMIN({super.key}) {}

  /// 🔹 التحقق من بيانات المستخدم
  Future<void> verifyDevice({bool autoLogin = false}) async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      if (!autoLogin) errorMessage.value = "يرجى إدخال جميع البيانات.";
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
          // ✅ حفظ بيانات المستخدم تلقائيًا
          box.write('username', username);
          box.write('password', password);

          isLoading.value = false;
          Get.offAllNamed('/homeAdmin'); // ✅ الانتقال إلى صفحة الأدمن
          return;
        } else {
          if (!autoLogin) errorMessage.value = "❌ كلمة المرور غير صحيحة.";
        }
      } else {
        if (!autoLogin) errorMessage.value = "❌ المستخدم غير موجود.";
      }
    } catch (e) {
      if (!autoLogin) errorMessage.value = "⚠️ حدث خطأ أثناء التحقق.";
      print("❌ خطأ في Firestore: $e");
    }

    isLoading.value = false;
  }

  /// 🔹 تسجيل الخروج ومسح البيانات
  void logout() {
    box.remove('username');
    box.remove('password');
    Get.offAllNamed('/admin'); // ✅ الانتقال إلى صفحة تسجيل الدخول
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  'ADMIN PANEL',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 300),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(139, 57, 55, 55),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Welcome Support',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        labelText: "Username *",
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password *",
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    ValueListenableBuilder<String>(
                      valueListenable: errorMessage,
                      builder: (context, value, child) {
                        return value.isNotEmpty
                            ? Text(value,
                                style: const TextStyle(color: Colors.red))
                            : const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 20),
                    MaterialButton(
                      color: Colors.red,
                      onPressed: () => verifyDevice(),
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.red),
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
