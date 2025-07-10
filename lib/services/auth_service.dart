import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/token.dart';

// 인증 토큰이 필요하지 않은 API 요청, 토큰을 위한 요청, 인증 가불 여부.

class AuthService extends GetxService {
  Future<Token> login(String email, String password) async {
    final request = await http.post(
      Uri.parse('/login'),
      body: {'email': email, 'password': password},
    );
    if (request.statusCode == 200) {
      final token = Token.fromJson(json.decode(request.body));
      return token;
    } else {
      return Token.testLogin();
      // throw Exception('Failed to login');
    }
  }
  Future<bool> checkAuth(Token token) async {
    return !token.isEmpty;
  }
}