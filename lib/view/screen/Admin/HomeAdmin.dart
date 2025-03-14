import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iptv_player_web/view/screen/Admin/login.dart';

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final GetStorage box = GetStorage(); // ✅ التخزين المحلي

    void logout() {
      box.remove('username');
      box.remove('password');
      Get.offAll(() => LoginADMIN()); // ✅ توجيه المستخدم إلى صفحة تسجيل الدخول
    }

    return Scaffold(
      body: Row(
        children: [
          // ✅ الشريط الجانبي (Sidebar)
          Container(
            width: 250,
            height: double.infinity,
            color: Colors.blueGrey[900],
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.admin_panel_settings,
                      size: 40, color: Colors.blueGrey),
                ),
                const SizedBox(height: 20),
                Text(
                  'Admin Panel',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                ListTile(
                  leading: const Icon(Icons.dashboard, color: Colors.white),
                  title: const Text('Dashboard',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.white),
                  title: const Text('Users',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.white),
                  title: const Text('Settings',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {},
                ),
                const Spacer(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title:
                      const Text('Logout', style: TextStyle(color: Colors.red)),
                  onTap: logout,
                ),
              ],
            ),
          ),

          // ✅ المحتوى الرئيسي (Main Content)
          Expanded(
            child: Column(
              children: [
                // ✅ (Top Bar)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  color: Colors.white,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Dashboard',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                // ✅ محتوى الصفحة الرئيسي
                Expanded(
                  child: Center(
                    child: Text(
                      'Welcome to Admin Panel',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
