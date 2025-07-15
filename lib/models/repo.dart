enum TimerStatus { stopped, running, paused }

class Repo {
  final String id;
  final String title;
  final String subtitle;
  final String repoAddress;
  Duration duration;
  TimerStatus status;

  Repo({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.repoAddress,
    this.duration = Duration.zero,
    this.status = TimerStatus.stopped,
  });

  factory Repo.fromJson(Map<String, dynamic> json) {
    return Repo(
      id: json['id'],
      title: json['title'],
      subtitle: json['sub_title'],
      repoAddress: json['repo_address'],
    );
  }

  factory Repo.empty() {
    return Repo(
      id: '',
      title: '',
      subtitle: '',
      repoAddress: '',
    );
  }
  Repo copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? repoAddress,
    Duration? duration,
    TimerStatus? status,
  }) {
    return Repo(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      repoAddress: repoAddress ?? this.repoAddress,
      duration: duration ?? this.duration,
      status: status ?? this.status,
    );
  }
}