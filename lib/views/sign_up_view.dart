import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitpumta/controllers/auth_controller.dart';

class SignUpView extends GetView<AuthController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Text('회원가입'),
      )
    );
  }

}