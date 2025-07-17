class Token {
  final String gitToken;
  final String accessToken;
  final String refreshToken;
  final String username;

  Token(this.gitToken, this.accessToken, this.refreshToken, this.username);

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(json['gitToken'], json['accessToken'], json['refreshToken'], json['username']);
  }

  factory Token.empty() {
    return Token('', '', '', '');
  }

  factory Token.testLogin(String userId) {
    return Token('1234', '1234', '1234', userId);
  }

  Token copyWith({
    String? gitToken,
    String? accessToken,
    String? refreshToken,
    String? username,
  }) {
    return Token(
      gitToken ?? this.gitToken,
      accessToken ?? this.accessToken,
      refreshToken ?? this.refreshToken,
      username ?? this.username,
    );
  }

  bool get isEmpty => gitToken == '' && accessToken == '' && refreshToken == '' && username == '';
}
