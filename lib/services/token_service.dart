import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../models/token.dart';

// 토큰 저장, 꺼내기, 삭제

class TokenService extends GetxService {
  final _storage = const FlutterSecureStorage();

  static const _gitTokenKey = 'gitToken';
  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';
  static const _usernameKey = 'username';


  Future<void> saveToken(Token token) async {
    await _storage.write(key: _gitTokenKey, value: token.gitToken);
    await _storage.write(key: _accessTokenKey, value: token.accessToken);
    await _storage.write(key: _refreshTokenKey, value: token.refreshToken);
    await _storage.write(key: _usernameKey, value: token.username);
  }

  Future<Token> getToken() async {
    final gitToken = await _storage.read(key: _gitTokenKey);
    final accessToken = await _storage.read(key: _accessTokenKey);
    final refreshToken = await _storage.read(key: _refreshTokenKey);
    final username = await _storage.read(key: _usernameKey);

    if (gitToken != null && accessToken != null && refreshToken != null && username != null) {
      print("we call token service: $gitToken");
      return Token(gitToken, accessToken, refreshToken, username);
    } else {
      print('토큰이 없습니다.');
      return Token.empty();
    }
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _gitTokenKey);
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _usernameKey);
  }

  Future<void> saveGithubToken(String githubToken) async {
    await _storage.write(key: _gitTokenKey, value: githubToken);
  }
  Future<void> saveUsername(String username) async {
    await _storage.write(key: _usernameKey, value: username);
  }
  Future<String> getUsername() async {
    final username = await _storage.read(key: _usernameKey);
    return username ?? '';
  }
}