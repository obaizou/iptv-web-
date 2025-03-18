import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iptv_player_web/view/screen/Users/login.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ActivationPage extends StatelessWidget {
  final String macAddress;
  final ValueNotifier<bool> showPlaylistForm = ValueNotifier(false);
  final ValueNotifier<bool> showXtreamForm = ValueNotifier(false);
  final ValueNotifier<bool> showActivateForm = ValueNotifier(false);
  final ValueNotifier<bool> showValidationResult = ValueNotifier(false);
  ValueNotifier<bool> showXtreamDetails = ValueNotifier(false);
  Map<String, dynamic>? xtreamData;
  ValueNotifier<bool> showM3UDetails = ValueNotifier(false);
  Map<String, dynamic>? m3uData;
  Map<String, dynamic>? validatedData;
  ActivationPage({required this.macAddress});

  void _deletePlaylist(Map<String, dynamic> playlist, String macAddress) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('devices').doc(macAddress);

    try {
      DocumentSnapshot doc = await docRef.get();
      List<dynamic> updatedList = List.from(doc['playlist_data']);

      updatedList.removeWhere((p) => p['server'] == playlist['server']);

      await docRef.update({'playlist_data': updatedList});

      Get.snackbar("Deleted", "Playlist removed successfully",
          backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      print("Error deleting playlist: $e");
    }
  }

  void _editPlaylist(
      BuildContext context, Map<String, dynamic> playlist, String macAddress) {
    TextEditingController serverController =
        TextEditingController(text: playlist['server']);
    TextEditingController usernameController =
        TextEditingController(text: playlist['username']);
    TextEditingController passwordController =
        TextEditingController(text: playlist['password']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Playlist"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: serverController,
                decoration: InputDecoration(labelText: "Server"),
              ),
              if (playlist['type'] != 'M3U') ...[
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText: "Username"),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                /// تحديث البيانات في Firestore
                DocumentReference docRef = FirebaseFirestore.instance
                    .collection('devices')
                    .doc(macAddress);

                List<dynamic> updatedList =
                    (await docRef.get()).get('playlist_data');
                int index = updatedList
                    .indexWhere((p) => p['server'] == playlist['server']);

                if (index != -1) {
                  updatedList[index] = {
                    "server": serverController.text,
                    "username": usernameController.text,
                    "password": passwordController.text,
                    "type": playlist['type']
                  };

                  await docRef.update({'playlist_data': updatedList});
                }

                Navigator.pop(context);
              },
              child: Text("Save", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  // Future<bool> validateM3U(String url) async {
  //   try {
  //     // final response = await http.get(Uri.parse(url));
  //     // return response.statusCode == 200;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future<bool> validateXtream(String server, String user, String pass) async {
    if (!server.startsWith("http")) {
      server = "http://$server";
    }

    final url =
        Uri.parse('$server/player_api.php?username=$user&password=$pass');

    try {
      final response = await http.get(url,
          headers: {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"});

      if (response.statusCode == 200 &&
          response.body.contains("\"user_info\"")) {
        return true;
      }
    } catch (e) {
      print("Error validating Xtream: $e");
    }
    return false;
  }

  Future<void> saveToFirestore(Map<String, dynamic> data) async {
    if (macAddress.isEmpty) {
      print("Error: MAC Address is empty!");
      return;
    }

    DocumentReference docRef =
        FirebaseFirestore.instance.collection('devices').doc(macAddress);

    try {
      DocumentSnapshot doc = await docRef.get();

      Map<String, dynamic> updateData = {
        'playlist_data': FieldValue.arrayUnion([data]),
      };

      // ✅ إضافة معلومات السيرفر إذا كان Xtream Codes
      if (data['type'] == 'Xtream') {}

      // ✅ إذا لم يكن المستند موجودًا، يتم إنشاؤه
      if (!doc.exists) {
        await docRef.set(updateData);
      } else {
        await docRef.update(updateData);
      }

      print("✅ Data saved successfully!");
    } catch (e) {
      print("❌ Error saving to Firestore: $e");
    }
  }

  /// ✅ دالة تسجيل الخروج
  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Exit"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                html.window.localStorage.remove('mac_address');
                Get.offAll(Login());
              },
              child: Text("Yes", style: TextStyle(color: Colors.red)),
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
                "Device data not found ❌",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          final deviceData = snapshot.data!;
          bool isActivated = deviceData['is_activated'] ?? false;
          String statusText = isActivated ? "Active ✅" : "Inactive ❌";
          String expirationDate = "Unavailable";
          if (deviceData['expires_at'] != null) {
            Timestamp timestamp = deviceData['expires_at'];
            DateTime dateTime = timestamp.toDate();
            expirationDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
          }

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
                            _buildButton("Add Playlist(M3U)", Colors.red, () {
                              showPlaylistForm.value = !showPlaylistForm.value;
                              showXtreamForm.value = false;
                              showActivateForm.value = false;
                            }),
                            _buildButton("Xtream Codes",
                                Color.fromARGB(255, 246, 132, 9), () {
                              showXtreamForm.value = !showXtreamForm.value;
                              showActivateForm.value = false;
                              showPlaylistForm.value = false;
                            }),
                            _buildButton("Activate", Colors.green, () {
                              showActivateForm.value = !showActivateForm.value;
                              showXtreamForm.value = false;
                              showPlaylistForm.value = false;
                            }),
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
                      ValueListenableBuilder<bool>(
                        valueListenable: showActivateForm,
                        builder: (context, isVisible, child) {
                          return isVisible
                              ? _buildActivateForm()
                              : SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('TYPE',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        Text('SERVER',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        Text('USERNAME',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        Text('PASSWORD',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        Text('ACTIONS',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 10),

                    /// ✅ عرض قائمة السيرفرات من Firestore
                    if (deviceData['playlist_data'] != null &&
                        deviceData['playlist_data'] is List)
                      Column(
                        children:
                            deviceData['playlist_data'].map<Widget>((playlist) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /// 🟢 TYPE
                                Text(playlist['type'] ?? '-',
                                    style: TextStyle(color: Colors.white)),

                                /// 🌍 SERVER
                                Text(
                                    playlist['type'] == 'M3U'
                                        ? playlist['url']
                                        : playlist['server'],
                                    style: TextStyle(color: Colors.white)),
                                // Text(playlist['type'] ?? '-',
                                //     style: TextStyle(color: Colors.white)),

                                /// 👤 USERNAME (لا يظهر إذا كان M3U)
                                Text(
                                    playlist['type'] == 'M3U'
                                        ? '-'
                                        : (playlist['username'] ?? '-'),
                                    style: TextStyle(color: Colors.white)),

                                /// 🔑 PASSWORD (لا يظهر إذا كان M3U)
                                Text(
                                    playlist['type'] == 'M3U'
                                        ? '-'
                                        : (playlist['password'] ?? '-'),
                                    style: TextStyle(color: Colors.white)),

                                /// ✏️ & ❌ ACTIONS
                                Row(
                                  children: [
                                    IconButton(
                                      icon:
                                          Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () {
                                        _editPlaylist(
                                            context, playlist, macAddress);
                                      },
                                    ),
                                    IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        _deletePlaylist(playlist, macAddress);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      )
                    else
                      Center(
                        child: Text("No data found",
                            style: TextStyle(color: Colors.white)),
                      ),
                  ],
                ),
              )
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

  Widget _buildActivateForm() {
    final TextEditingController activateKeyController = TextEditingController();

    return _buildFormContainer("Add Your Key To Activate Your Device", [
      SizedBox(height: 10),
      Text(
        'KEY',
        style: TextStyle(
            fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      _buildTextField("KEY", activateKeyController),
      SizedBox(height: 10),
      _buildButton("SUBMIT", Colors.red, () async {
        String key = activateKeyController.text.trim();

        if (key.isEmpty) {
          Get.snackbar("Error", "Key is required",
              backgroundColor: Colors.red, colorText: Colors.white);
          return;
        }

        // البحث عن المفتاح في Firestore
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('activate_keys')
            .where('key', isEqualTo: key)
            .get();

        if (querySnapshot.docs.isEmpty) {
          Get.snackbar("Error", "Invalid Key",
              backgroundColor: Colors.red, colorText: Colors.white);
          return;
        }

        var keyData = querySnapshot.docs.first.data() as Map<String, dynamic>;

        if (keyData['finish'] == true) {
          Get.snackbar("Error", "Key already used",
              backgroundColor: Colors.red, colorText: Colors.white);
          return;
        }

        // تحديث المفتاح ليكون مستخدمًا (تحويل finish إلى true)
        await FirebaseFirestore.instance
            .collection('activate_keys')
            .doc(querySnapshot.docs.first.id)
            .update({'finish': true});

        // تحديث حالة الجهاز
        await FirebaseFirestore.instance
            .collection('devices')
            .doc(macAddress)
            .update({
          'is_activated': true,
          'created_at': keyData['created_at'],
          'expires_at': keyData['expires_at']
        });

        Get.snackbar("Success", "Device activated successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
      }),
    ]);
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
      SizedBox(height: 10),
      _buildButton("SUBMIT", Colors.red, () async {
        String url = playlistURLController.text.trim();
        String name = playlistNameController.text.trim();

        if (url.isEmpty || name.isEmpty) {
          Get.snackbar("Error", "All fields are required",
              backgroundColor: Colors.red, colorText: Colors.white);
          return;
        }

        bool isValid = await true;
        if (!isValid) {
          Get.snackbar("Invalid Playlist", "The provided M3U URL is not valid",
              backgroundColor: Colors.red, colorText: Colors.white);
          return;
        }

        m3uData = {"name": name, "url": url, "type": "M3U"};
        await saveToFirestore(m3uData!);

        showM3UDetails.value = true;
        Get.snackbar("Success", "M3U Playlist added successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
      }),
    ]);
  }

  Widget _buildTableHeader(String text) {
    return Expanded(
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Expanded(
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 14),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis, // قص النص إذا كان طويلًا
      ),
    );
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
      SizedBox(height: 10),
      _buildButton("SUBMIT", Colors.red, () async {
        String server = serverURLController.text.trim();
        String user = usernameController.text.trim();
        String pass = passwordController.text.trim();

        if (server.isEmpty || user.isEmpty || pass.isEmpty) {
          Get.snackbar("Error", "All fields are required",
              backgroundColor: Colors.red, colorText: Colors.white);
          return;
        }

        bool isValid = await validateXtream(server, user, pass);
        if (!isValid) {
          Get.snackbar(
              "Invalid Xtream", "The provided Xtream Codes are not valid",
              backgroundColor: Colors.red, colorText: Colors.white);
          return;
        }

        xtreamData = {
          "server": server,
          "username": user,
          "password": pass,
          "type": "Xtream"
        };
        await saveToFirestore(xtreamData!);

        showXtreamDetails.value = true;
        Get.snackbar("Success", "Xtream Codes added successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
      }),
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
