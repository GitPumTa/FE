import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../routes/app_route.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller.emailController,
              decoration: InputDecoration(labelText: '이메일'),
            ),
            TextField(
              controller: controller.passwordController,
              decoration: InputDecoration(labelText: '비밀번호'),
            ),
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
