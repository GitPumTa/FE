import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/setting_controller.dart';

class SettingGithubView extends GetView<SettingController> {
  const SettingGithubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffafafa),
      appBar: AppBar(title: Text('Setting'), backgroundColor: Color(0xfffafafa)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller.githubTokenController,
              decoration: InputDecoration(
                labelText: 'Github Token',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.saveGithubToken,
                child: Text('저장'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
