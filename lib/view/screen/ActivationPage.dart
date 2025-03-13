import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iptv_player_web/view/screen/login.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;

class ActivationPage extends StatelessWidget {
  final String macAddress;
  final ValueNotifier<bool> showPlaylistForm = ValueNotifier(false);
  final ValueNotifier<bool> showXtreamForm = ValueNotifier(false);
  final ValueNotifier<bool> showValidationResult = ValueNotifier(false);
  Map<String, dynamic>? validatedData;
  ActivationPage({required this.macAddress});
  Future<bool> validateM3U(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      return response.statusCode == 200 && response.body.contains("#EXTM3U");
    } catch (e) {
      return false;
    }
  }

  Future<bool> validateXtream(String server, String user, String pass) async {
    final url =
        Uri.parse('$server/get.php?username=$user&password=$pass&type=m3u');
    try {
      final response = await http.get(url);
      return response.statusCode == 200 && response.body.contains("#EXTM3U");
    } catch (e) {
      return false;
    }
  }

  Future<void> saveToFirestore(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('devices')
        .doc(macAddress)
        .set({'playlist_data': data}, SetOptions(merge: true));
  }

  /// ✅ دالة تسجيل الخروج
  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("تأكيد الخروج"),
          content: Text("هل أنت متأكد أنك تريد تسجيل الخروج؟"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("إلغاء"),
            ),
            TextButton(
              onPressed: () {
                html.window.localStorage.remove('mac_address');
                Get.offAll(Login());
              },
              child: Text("نعم", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('devices')
            .doc(macAddress)
            .snapshots(),
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
          String expirationDate = deviceData['expiration'] ?? "غير متوفر";

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

              /// 🔥 Container الرئيسي لمعلومات الجهاز
              Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Your Playlist',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: Colors.white),
                      ),
                      SizedBox(height: 20),
                      _buildInfoRow("Mac Address:", macAddress),
                      _buildInfoRow("Status:", statusText),
                      _buildInfoRow("Expiration:", expirationDate),

                      /// 🔥 أزرار التحكم
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // _buildButton("Add Playlist(M3U)", Colors.red, () {
                            //   showPlaylistForm.value = !showPlaylistForm.value;
                            //   showXtreamForm.value = false;
                            // }),
                            _buildButton("Add Playlist(M3U)", Colors.red, () {
                              showPlaylistForm.value = !showPlaylistForm.value;
                              showXtreamForm.value = false;
                            }),
                            _buildButton("Xtream Codes",
                                Color.fromARGB(255, 246, 132, 9), () {
                              showXtreamForm.value = !showXtreamForm.value;
                              showPlaylistForm.value = false;
                            }),
                            _buildButton("Activate", Colors.green, () {}),
                            _buildButton("Logout", Colors.blue, () {
                              _logout(context);
                            }),
                          ],
                        ),
                      ),

                      /// ✅ إظهار نموذج إدخال Playlist أو Xtream Codes عند الضغط
                      ValueListenableBuilder<bool>(
                        valueListenable: showPlaylistForm,
                        builder: (context, isVisible, child) {
                          return isVisible
                              ? _buildPlaylistForm()
                              : SizedBox.shrink();
                        },
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: showXtreamForm,
                        builder: (context, isVisible, child) {
                          return isVisible
                              ? _buildXtreamForm()
                              : SizedBox.shrink();
                        },
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

  /// 🎯 **تصميم زر مرن**
  Widget _buildButton(String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// 🎯 **عرض معلومات الجهاز (صف)**
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white70)),
          Text(value, style: TextStyle(fontSize: 18, color: Colors.white70)),
        ],
      ),
    );
  }

  /// 🎯 **نموذج إدخال Playlist (M3U)**
  Widget _buildPlaylistForm() {
    final TextEditingController playlistURLController = TextEditingController();
    final TextEditingController playlistNameController =
        TextEditingController();

    return _buildFormContainer("Add M3U Playlist", [
      SizedBox(height: 10),
      Text(
        'Playlist Name',
        style: TextStyle(
            fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      _buildTextField("Playlist Name", playlistNameController),
      SizedBox(height: 10),
      Text(
        'Playlist URL',
        style: TextStyle(
            fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      _buildTextField("Playlist URL", playlistURLController),
    ]);
  }

  /// 🎯 **نموذج إدخال Xtream Codes**
  Widget _buildXtreamForm() {
    final TextEditingController serverURLController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return _buildFormContainer("Add Xtream Codes", [
      SizedBox(height: 10),
      Text(
        'Server URL',
        style: TextStyle(
            fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      _buildTextField("Server URL", serverURLController),
      SizedBox(height: 10),
      Text(
        'Username',
        style: TextStyle(
            fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      _buildTextField("Username", usernameController),
      SizedBox(height: 10),
      Text(
        'Password',
        style: TextStyle(
            fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      _buildTextField("Password", passwordController, isPassword: true),
    ]);
  }

  /// 🔥 **تصميم النموذج الأساسي**
  Widget _buildFormContainer(String title, List<Widget> fields) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(height: 10),
          ...fields,
          SizedBox(height: 10),
          _buildButton("SUBMIT", Colors.red, () {
            print("تم حفظ البيانات");
          }),
        ],
      ),
    );
  }

  /// 🔥 **تصميم حقل إدخال**
  Widget _buildTextField(String hint, TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(),
      ),
    );
  }
}
