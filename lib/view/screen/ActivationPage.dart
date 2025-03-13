import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iptv_player_web/view/screen/login.dart';
import 'dart:html' as html;

class ActivationPage extends StatelessWidget {
  final String macAddress; // تمرير MAC Address عند التنقل للصفحة

  ActivationPage({required this.macAddress});
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("تأكيد الخروج"),
          content: Text("هل أنت متأكد أنك تريد تسجيل الخروج؟"),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context), // ❌ إغلاق النافذة بدون تسجيل خروج
              child: Text("إلغاء"),
            ),
            TextButton(
              onPressed: () {
                _logout(); // ✅ تنفيذ عملية تسجيل الخروج
              },
              child: Text("نعم", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  /// ✅ دالة `logout` لحذف البيانات وإعادة المستخدم إلى صفحة تسجيل الدخول
  void _logout() {
    html.window.localStorage
        .remove('mac_address'); // 🔥 حذف MAC Address من التخزين
    Get.offAll(
        Login()); // 🚀 الانتقال إلى صفحة تسجيل الدخول وإزالة جميع الصفحات السابقة
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('devices')
            .doc(macAddress)
            .snapshots(), // جلب التحديثات مباشرة
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.red));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text(
                "لم يتم العثور على بيانات الجهاز ❌",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          final deviceData = snapshot.data!;
          bool isActivated = deviceData['is_activated'] ?? false;
          String statusText = isActivated ? "Active ✅" : "Inactive ❌";
          String expirationDate = deviceData['expiration'] ?? "غير  متوفر";

          return ListView(
            padding: EdgeInsets.all(20),
            children: [
              Center(
                child: Text(
                  'Manage Your Playlist',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                ),
              ),
              Center(
                child: Text(
                  'Do It Simply Wherever You Go',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(139, 57, 55, 55),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Your Playlist',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 28),
                      ),
                      SizedBox(height: 20),
                      _buildInfoRow("Mac Address:", macAddress),
                      _buildInfoRow("Status:", statusText),
                      _buildInfoRow("Expiration:", expirationDate),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 330),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 14),
                                color: Colors.red,
                                child: Text(
                                  'Add Playlist',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 14),
                                color: Colors.red,
                                child: Text(
                                  'Activate',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showLogoutDialog(
                                    context); // ✅ عرض نافذة تأكيد قبل تسجيل الخروج
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 14),
                                color: Colors.red,
                                child: Text(
                                  'Logout',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Text(value, style: TextStyle(fontSize: 18, color: Colors.white70)),
        ],
      ),
    );
  }
}
