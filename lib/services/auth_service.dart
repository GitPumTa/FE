import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/token.dart';

// 인증 토큰이 필요하지 않은 API 요청, 토큰을 위한 요청, 인증 가불 여부.

class AuthService extends GetxService {
  Future<Token> login(String email, String password) async {
    print('login start $email $password');
    final request = await http.post(
      Uri.parse('http://15.164.49.227:8080/user/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'accountId': email,
        'password': password,
      }),
    );
    print("request.statusCode: ${request.statusCode} request.body: ${request.body}");
    if (request.statusCode == 200) {
      print(request.body);
      final userId = json.decode(request.body)['id'];
      final token = Token.testLogin(userId);

      print('login success');
      return token;
    } else {
      print('login fail');
      return Token.empty();
      // throw Exception('Failed to login');
    }
  }
  Future<bool> checkAuth(Token token) async {
    return !token.isEmpty;
  }
}