import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/repo.dart'; // TimerStatus enum 포함
import '../models/ranking.dart'; // Ranking, DurationLeader, CommitLeader

class RankingController extends GetxController {
  Rx<Ranking> ranking = Ranking.empty().obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  // 예시: 더미 데이터 로딩
  @override
  void onInit() {
    super.onInit();
    ranking.value = Ranking(
      durationLeaders: [
        DurationLeader(name: '팀장님', duration: Duration(hours: 2, minutes: 5, seconds: 38), rank: 1, status: TimerStatus.running, sendAt: null),
        DurationLeader(name: '대리님', duration: Duration(hours: 1, minutes: 20, seconds: 38), rank: 2, status: TimerStatus.stopped, sendAt: null),
        DurationLeader(name: '주임님', duration: Duration(hours: 1, minutes: 2, seconds: 38), rank: 3, status: TimerStatus.stopped, sendAt: null),
      ],
      commitLeaders: [
        CommitLeader(name: '팀장님', commitCount: 500, rank: 1),
        CommitLeader(name: '대리님', commitCount: 250, rank: 2),
        CommitLeader(name: '주임님', commitCount: 200, rank: 3),
      ],
      myMonitoringGroup: '현장프로젝트 2팀',
      myMonitoringGroupDescription: '',
      myRank: 0,
      myName: '',
    );
  }

  String get formattedDate {
    final formatter = DateFormat('M월 d일');
    return formatter.format(selectedDate.value);
  }

  void decrementDate() {
  selectedDate.value = selectedDate.value.subtract(Duration(days: 1));
  // fetchRankingData(); // ← API 붙이면 여기에 호출
  }

  void incrementDate() {
  selectedDate.value = selectedDate.value.add(Duration(days: 1));
  // fetchRankingData(); // ← API 붙이면 여기에 호출
  }

}