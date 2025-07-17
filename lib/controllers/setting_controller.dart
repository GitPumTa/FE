import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:gitpumta/controllers/auth_controller.dart';
import 'package:gitpumta/routes/app_route.dart';

class SettingController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  // Base URL: 일단 테스트 서버
  static const _baseUrl = 'http://15.164.49.227:8080';

  RxString username = ''.obs;
  RxList<int> weeklyCommits = List.filled(7, 0).obs;
  final githubTokenController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _fetchUserInfo();
    _fetchWeeklyCommits(); // 아직 API 미지원이므로 더미 호출
  }

  /// 1) 사용자 프로필 조회
  Future<void> _fetchUserInfo() async {
    try {
      final res = await http.get(
        Uri.parse('$_baseUrl/userInfo'),
        headers: { 'Content-Type': 'application/json' },
      );
      if (res.statusCode == 200) {
        final data = json.decode(res.body) as Map<String, dynamic>;
        username.value = data['nickname'] ?? '이름없음';
      } else {
        // 서버 오류 시 더미 데이터 사용
        _useDummyUserData();
      }
    } catch (e) {
      // 네트워크 오류 등 예외 시 더미 데이터 사용
      _useDummyUserData();
    }
  }

  /// 2) 주간 커밋 통계 조회 (현재는 더미)
  Future<void> _fetchWeeklyCommits() async {
    // TODO: 실제 API 호출 로직으로 교체
    await Future.delayed(const Duration(milliseconds: 300));
    weeklyCommits.value = [2, 3, 4, 5, 6, 3, 2];
  }

  /// 프로필 조회 실패 시 사용할 더미 데이터
  void _useDummyUserData() {
    username.value = 'hoho';
    weeklyCommits.value = [2, 3, 4, 5, 6, 3, 2];
  }

  /// 깃허브 토큰 저장
  Future<void> saveGithubToken() async {
    final token = githubTokenController.text.trim();
    if (token.isNotEmpty) {
      await authController.saveGithubToken(token);
    }
    Get.back();
  }

  /// 로그아웃
  Future<void> logout() async {
    await authController.logout();
    Get.offAllNamed(AppRoutes.login);
  }
}
