class Token {
  final String gitToken;
  final String accessToken;
  final String refreshToken;

  Token(this.gitToken, this.accessToken, this.refreshToken);

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(json['gitToken'], json['accessToken'], json['refreshToken']);
  }

  factory Token.empty() {
    return Token('', '', '');
  }

  factory Token.testLogin() {
    return Token('1234', '1234', '1234');
  }

  Token copyWith({
    String? gitToken,
    String? accessToken,
    String? refreshToken,
  }) {
    return Token(
      gitToken ?? this.gitToken,
      accessToken ?? this.accessToken,
      refreshToken ?? this.refreshToken,
    );
  }

  bool get isEmpty => gitToken == '' && accessToken == '' && refreshToken == '';
}
