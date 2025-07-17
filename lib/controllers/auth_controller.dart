import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gitpumta/routes/app_route.dart';

import '../services/auth_service.dart';
import '../services/token_service.dart';

class AuthController extends GetxController {
  final AuthService authService;
  final TokenService tokenService;
  AuthController({required this.authService, required this.tokenService});

  @override
  void onInit() {
    super.onInit();
    checkAuth();
  }

  // 로그인 텍스트 필드 컨트롤러

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // 회원가입 텍스트 필드 컨트롤러
  final signupUsernameController = TextEditingController();
  final signupEmailController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final signupPasswordCheckController = TextEditingController();

  RxBool isLoggedIn = false.obs;

  Future<void> checkAuth() async {
    final token = await tokenService.getToken();
    final auth = await authService.checkAuth(token);
    print('in auth controller:$auth');

    if (!auth) {
      print('인증 실패.');
      isLoggedIn.value = false;
    }
    else {
      print('인증 성공.');
      isLoggedIn.value = true;
    }
  }

  Future<void> login() async {
    final email = emailController.text;
    final password = passwordController.text;
    final token = await authService.login(email, password);
    if (token.isEmpty) {
      return;
    }
    else{
      print('login success');
      await tokenService.saveToken(token);
      isLoggedIn.value = true;
      Get.offAllNamed(AppRoutes.home);
    }
  }

  Future<void> logout() async {
    await tokenService.deleteToken();
    isLoggedIn.value = false;
  }

  Future<bool> tryAutoLogin() async {
    final token = await tokenService.getToken();
    if (!token.isEmpty) {
      isLoggedIn.value = true;
      return true;
    }
    return false;
  }

  Future<void> saveGithubToken(String githubToken) async {
    await tokenService.saveGithubToken(githubToken);
  }

  Future<void> signUp() async {}


}