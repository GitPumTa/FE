import 'package:gitpumta/models/repo.dart';

class Ranking {

  final List<DurationLeader> durationLeaders;
  final List<CommitLeader> commitLeaders;
  final String myMonitoringGroup;
  final String myMonitoringGroupDescription;
  final int myRank;
  final String myName;

  Ranking({
    required this.durationLeaders,
    required this.commitLeaders,
    required this.myMonitoringGroup,
    required this.myMonitoringGroupDescription,
    required this.myRank,
    required this.myName,
  });

  factory Ranking.fromJson(Map<String, dynamic> json) {
    final durationLeaders = (json['duration_leaders'] as List<dynamic>?)
        ?.map((e) => DurationLeader.fromJson(e))
        .toList() ??
        [];

    final commitLeaders = (json['commit_leaders'] as List<dynamic>?)
        ?.map((e) => CommitLeader.fromJson(e))
        .toList() ??
        [];

    return Ranking(
      durationLeaders: durationLeaders,
      commitLeaders: commitLeaders,
      myMonitoringGroup: json['my_monitoring_group'] ?? '',
      myMonitoringGroupDescription: json['my_monitoring_group_description'] ?? '',
      myRank: int.tryParse(json['my_rank']?.toString() ?? '0') ?? 0,
      myName: json['my_name'] ?? '',
    );
  }

  factory Ranking.empty() {
    return Ranking(
      durationLeaders: [],
      commitLeaders: [],
      myMonitoringGroup: '',
      myMonitoringGroupDescription: '',
      myRank: 0,
      myName: '',
    );
  }

  Ranking copyWith({
    List<DurationLeader>? durationLeaders,
  }) {
    return Ranking(
      durationLeaders: durationLeaders ?? this.durationLeaders,
      commitLeaders: commitLeaders,
      myMonitoringGroup: myMonitoringGroup,
      myMonitoringGroupDescription: myMonitoringGroupDescription,
      myRank: myRank,
      myName: myName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'durationLeaders': durationLeaders.map((e) => e.name).toList(),
      'commitLeaders': commitLeaders.map((e) => e.name).toList(),
      'myMonitoringGroup': myMonitoringGroup,
      'myMonitoringGroupDescription': myMonitoringGroupDescription,
      'myRank': myRank,
      'myName': myName,
    };
  }
}

class DurationLeader {
  final String name;
  final Duration duration;
  final int rank;
  final TimerStatus status;
  final DateTime? sendAt;

  DurationLeader({
    required this.name,
    required this.duration,
    required this.rank,
    required this.status,
    required this.sendAt,
  });

  factory DurationLeader.fromJson(Map<String, dynamic> json) {
    return DurationLeader(
      name: json['name'] ?? '',
      duration: Duration(seconds: json['duration'] ?? 0),
      rank: json['rank'] ?? 0,
      status: TimerStatus.values.firstWhere(
            (s) => s.name == json['status'],
        orElse: () => TimerStatus.stopped,
      ),
      sendAt: json['send_at'] != null ? DateTime.tryParse(json['send_at']) : null,
    );
  }

  factory DurationLeader.empty() {
    return DurationLeader(
      name: '',
      duration: Duration.zero,
      rank: 0,
      status: TimerStatus.stopped,
      sendAt: null,
    );
  }

  DurationLeader copyWith({
    String? name,
    Duration? duration,
    int? rank,
    TimerStatus? status,
    DateTime? sendAt,
  }) {
    return DurationLeader(
      name: name ?? this.name,
      duration: duration ?? this.duration,
      rank: rank ?? this.rank,
      status: status ?? this.status,
      sendAt: sendAt ?? this.sendAt,
    );
  }
}

class CommitLeader {
  final String name;
  final int commitCount;
  final int rank;

  CommitLeader({
    required this.name,
    required this.commitCount,
    required this.rank,
  });

  factory CommitLeader.fromJson(Map<String, dynamic> json) {
    return CommitLeader(
      name: json['name'] ?? '',
      commitCount: json['commit_count'] ?? 0,
      rank: json['rank'] ?? 0,
    );
  }

  factory CommitLeader.empty() {
    return CommitLeader(name: '', commitCount: 0, rank: 0);
  }
}
