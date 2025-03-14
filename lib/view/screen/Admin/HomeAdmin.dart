import 'package:flutter/material.dart';
import 'package:iptv_player_web/view/screen/Admin/login.dart'; // استيراد صفحة Login

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {},
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to Admin Panel'),
      ),
    );
  }
}
