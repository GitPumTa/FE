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
}