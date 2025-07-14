import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../controllers/setting_controller.dart';

class SettingStaticsView extends GetView<SettingController> {
  const SettingStaticsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffafafa),
      appBar: AppBar(
        backgroundColor: Color(0xfffafafa),
        title: Text('통계'),),
      body: Center(
        child: Text("통계화면입니다."),
      ),
    );
  }
}