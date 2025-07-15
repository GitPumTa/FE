import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../controllers/auth_controller.dart';
import '../routes/app_route.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('logo/playstore-icon.png', width: 200, height: 200),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFFd9d9d9),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: TextField(
                controller: controller.emailController,
                decoration: InputDecoration(
                  icon: Icon(HugeIcons.strokeRoundedUserCircle02, size: 30),
                  labelText: '아이디 및 이메일',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFFd9d9d9),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: TextField(
                controller: controller.passwordController,
                decoration: InputDecoration(
                  icon: Icon(HugeIcons.strokeRoundedCircleLock01, size: 30),
                  labelText: '비밀번호'
                    ,border: InputBorder.none,),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => controller.login(),
                  child: Text('로그인'),
                ),
                ElevatedButton(
                  onPressed: () => Get.toNamed(AppRoutes.signUp),
                  child: Text('회원가입'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
