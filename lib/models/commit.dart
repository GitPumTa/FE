class Commit {
  final String id;
  final String message;

  Commit({required this.id, required this.message});

  factory Commit.fromJson(Map<String, dynamic> json) {
    return Commit(
      id: json['id'],
      message: json['message'],
    );
  }

  factory Commit.empty() {
    return Commit(id: '', message: '');
  }
}