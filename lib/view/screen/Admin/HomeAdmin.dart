import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iptv_player_web/view/screen/Admin/login.dart';
import 'package:uuid/uuid.dart';

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

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final ValueNotifier<String?> generatedKey = ValueNotifier<String?>(null);
    Future<void> generateActivationKey(int minutes) async {
      try {
        String key = const Uuid().v4();
        DateTime createdAt = DateTime.now();
        DateTime expiryDate = createdAt.add(Duration(minutes: minutes));

        await _firestore.collection('activate_keys').doc(key).set({
          'key': key,
          'created_at': createdAt,
          'expires_at': expiryDate,
          'finish': false,
          'status': 'active',
        });

        generatedKey.value = key;
      } catch (e) {
        print("❌ Error generating key: $e");
      }
    }

    Future<void> deleteActivationKey(String key) async {
      await _firestore.collection('activate_keys').doc(key).delete();
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Welcome to Admin Panel',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      DropdownButton<int>(
                        hint: const Text("Select Validity Period"),
                        items: const [
                          DropdownMenuItem(
                              value: 1, child: Text("1 Minute")), // جديد
                          DropdownMenuItem(
                              value: 1440,
                              child: Text("1 Day")), // 1 يوم = 1440 دقيقة
                          DropdownMenuItem(
                              value: 10080, child: Text("1 Week")), // 7 أيام
                          DropdownMenuItem(
                              value: 43200, child: Text("1 Month")), // 30 يوم
                          DropdownMenuItem(
                              value: 129600, child: Text("3 Months")), // 90 يوم
                          DropdownMenuItem(
                              value: 259200,
                              child: Text("6 Months")), // 180 يوم
                          DropdownMenuItem(
                              value: 525600, child: Text("1 Year")), // 365 يوم
                          DropdownMenuItem(
                              value: 99999999,
                              child: Text("Lifetime")), // بدون انتهاء
                        ],
                        onChanged: (int? minutes) {
                          if (minutes != null) {
                            generateActivationKey(minutes);
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      ValueListenableBuilder<String?>(
                        valueListenable: generatedKey,
                        builder: (context, key, child) {
                          return key != null
                              ? SelectableText(
                                  "Generated Key: $key",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: _firestore
                              .collection('activate_keys')
                              .orderBy('created_at', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            var keys = snapshot.data!.docs;

                            return DataTable(
                              columns: const [
                                DataColumn(label: Text('Key')),
                                DataColumn(label: Text('Created At')),
                                DataColumn(label: Text('Expires At')),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Actions')),
                              ],
                              rows: keys.map((doc) {
                                Map<String, dynamic> data =
                                    doc.data() as Map<String, dynamic>;
                                return DataRow(cells: [
                                  DataCell(SelectableText(data['key'])),
                                  DataCell(Text(
                                      data['created_at'].toDate().toString())),
                                  DataCell(Text(
                                      data['expires_at'].toDate().toString())),
                                  DataCell(Text(data['status'])),
                                  DataCell(
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () =>
                                          deleteActivationKey(data['key']),
                                    ),
                                  ),
                                ]);
                              }).toList(),
                            );
                          },
                        ),
                      ),
                    ],
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
