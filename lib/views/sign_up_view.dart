import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitpumta/controllers/auth_controller.dart';
import 'package:hugeicons/hugeicons.dart';

import '../routes/app_route.dart';

class SignUpView extends GetView<AuthController> {
  const SignUpView({super.key});

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
                border: Border.all(color: Color(0xFFd9d9d9), width: 2),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: TextField(
                controller: controller.signupEmailController,
                decoration: InputDecoration(
                  icon: Icon(HugeIcons.strokeRoundedMail01, size: 30),
                  labelText: '아이디 및 이메일',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFd9d9d9), width: 2),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: TextField(
                controller: controller.signupUsernameController,
                decoration: InputDecoration(
                  icon: Icon(HugeIcons.strokeRoundedUserCircle02, size: 30),
                  labelText: '닉네임',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFd9d9d9), width: 2),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: TextField(
                controller: controller.signupPasswordController,
                decoration: InputDecoration(
                  icon: Icon(HugeIcons.strokeRoundedCircleLock01, size: 30),
                  labelText: '비밀번호',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFd9d9d9), width: 2),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: TextField(
                controller: controller.signupPasswordCheckController,
                decoration: InputDecoration(
                  icon: Icon(HugeIcons.strokeRoundedCircleLockCheck02, size: 30),
                  labelText: '비밀번호 확인',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.toNamed(AppRoutes.signUp),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Color(0xffd9d9d9), width: 2),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text('회원가입', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffff8126))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
