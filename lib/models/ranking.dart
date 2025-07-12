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
    final durationLeaders =
        (json['duration_leaders'] as List)
            .map((e) => DurationLeader.fromJson(e))
            .toList();
    final commitLeaders =
        (json['commit_leaders'] as List)
            .map((e) => CommitLeader.fromJson(e))
            .toList();
    return Ranking(
      durationLeaders: durationLeaders,
      commitLeaders: commitLeaders,
      myMonitoringGroup: json['my_monitoring_group'],
      myMonitoringGroupDescription: json['my_monitoring_group_description'],
      myRank: json['my_rank'],
      myName: json['my_name'],
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

  factory Ranking.mock() {
    // 테스트용 목데이터.
    return Ranking(
      durationLeaders: [
        DurationLeader(
          name: 'John',
          duration: Duration(seconds: 3600),
          rank: 1,
          status: TimerStatus.running,
          sendAt: DateTime(2025, 7, 12, 18, 55, 0),
        ),
        DurationLeader(
          name: 'Jane',
          duration: Duration(seconds: 3400),
          rank: 2,
          status: TimerStatus.running,
          sendAt: DateTime(2025, 7, 12, 18, 55, 0),
        ),
        DurationLeader(
          name: 'Bob',
          duration: Duration(seconds: 3200),
          rank: 3,
          status: TimerStatus.paused,
          sendAt: DateTime(2025, 7, 12, 18, 55, 0),
        ),
      ],
      commitLeaders: [
        CommitLeader(name: 'John', commitCount: 10, rank: 1),
        CommitLeader(name: 'Jane', commitCount: 8, rank: 2),
        CommitLeader(name: 'Bob', commitCount: 6, rank: 3),
      ],
      myMonitoringGroup: 'Group A',
      myMonitoringGroupDescription: 'Description of Group A',
      myRank: 5,
      myName: 'Alice',
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
      name: json['name'],
      duration: Duration(seconds: json['duration']),
      rank: json['rank'],
      status: TimerStatus.values.firstWhere((s) => s.name == json['status']),
      sendAt: json['send_at'] != null ? DateTime.parse(json['send_at']) : null,
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
      name: json['name'],
      commitCount: json['commit_count'],
      rank: json['rank'],
    );
  }

  factory CommitLeader.empty() {
    return CommitLeader(name: '', commitCount: 0, rank: 0);
  }
}
