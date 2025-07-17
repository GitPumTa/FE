class Commit {
  final DateTime date;
  final String message;

  Commit({required this.date, required this.message});

  factory Commit.fromJson(Map<String, dynamic> json) {
    return Commit(
      message: json['commit']['message'] ?? '',
      date: DateTime.parse(json['commit']['author']['date']),
    );
  }

  factory Commit.empty() {
    return Commit(date: DateTime.now(), message: '');
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'time': date.toIso8601String(), // 날짜 형식 문자열로 직렬화
    };
  }
}