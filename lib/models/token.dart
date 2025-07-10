class Token {
  final String gitToken;
  final String accessToken;
  final String refreshToken;

  Token(
      this.gitToken,
      this.accessToken,
      this.refreshToken,
      );
  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      json['gitToken'],
      json['accessToken'],
      json['refreshToken'],
    );
  }
  factory Token.empty() {
    return Token(
      '',
      '',
      '',
    );
  }
  factory Token.testLogin() {
    return Token(
      '1234',
      '1234',
      '1234',
    );
  }
  bool get isEmpty => gitToken == '' && accessToken == '' && refreshToken == '';
}