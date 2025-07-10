import 'package:flutter/material.dart';
import 'package:gitpumta/views/widgets/bottom_nav.dart';

import '../controllers/setting_controller.dart';
import 'package:get/get.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
        centerTitle: true,
      ),
      body: Center(
        child: TextButton(onPressed: controller.logout, child: Text("로그 아웃")),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

}