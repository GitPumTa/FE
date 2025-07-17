// lib/controllers/ranking_controller.dart

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/ranking.dart';
import '../models/repo.dart';          // TimerStatus enum
import '../services/token_service.dart';

class RankingController extends GetxController {
  static const _baseUrl = 'http://15.164.49.227:8080';

  final TokenService _tokenService = Get.find<TokenService>();

  /// 화면에 바인딩할 랭킹 데이터
  final Rx<Ranking> ranking = Ranking.empty().obs;

  /// 사용자 선택 날짜 (필요 시)
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    fetchRanking();
  }

  /// GET /ranking/user?account_id=xxx 호출
  Future<void> fetchRanking() async {
    final accountId = await _tokenService.getUsername();
    final uri = Uri.parse('$_baseUrl/ranking/user')
        .replace(queryParameters: {'account_id': accountId});
    try {
      final res = await http.get(uri, headers: {
        'Content-Type': 'application/json',
      });
      if (res.statusCode == 200) {
        final Map<String, dynamic> jsonBody = json.decode(res.body);

        // 공부시간 랭킹 → DurationLeader
        final timeList = (jsonBody['timeRanking'] as List<dynamic>)
            .map((e) => DurationLeader(
                  name: e['nickname'] as String,
                  duration:
                      Duration(seconds: (e['timeDuration'] as int?) ?? 0),
                  rank: e['rank'] as int,
                  status: TimerStatus.stopped, // 상태 정보 API에 없음
                  sendAt: null,
                ))
            .toList();

        // 커밋횟수 랭킹 → CommitLeader
        final commitList = (jsonBody['commitRanking'] as List<dynamic>)
            .map((e) => CommitLeader(
                  name: e['nickname'] as String,
                  commitCount: (e['commitDuration'] as int?) ?? 0,
                  rank: e['rank'] as int,
                ))
            .toList();

        ranking.value = Ranking(
          durationLeaders: timeList,
          commitLeaders: commitList,
          myMonitoringGroup: '',
          myMonitoringGroupDescription: '',
          myRank: 0,
          myName: '',
        );
      } else {
        _useDummy();
      }
    } catch (_) {
      _useDummy();
    }
  }

  /// API 에러 시 더미데이터 사용
  void _useDummy() {
    ranking.value = Ranking(
      durationLeaders: [
        DurationLeader(
          name: '팀장님',
          duration: const Duration(hours: 2, minutes: 5, seconds: 38),
          rank: 1,
          status: TimerStatus.stopped,
          sendAt: null,
        ),
        DurationLeader(
          name: '대리님',
          duration: const Duration(hours: 1, minutes: 20, seconds: 38),
          rank: 2,
          status: TimerStatus.stopped,
          sendAt: null,
        ),
        DurationLeader(
          name: '주임님',
          duration: const Duration(hours: 1, minutes: 2, seconds: 38),
          rank: 3,
          status: TimerStatus.stopped,
          sendAt: null,
        ),
      ],
      commitLeaders: [
        CommitLeader(name: '팀장님', commitCount: 500, rank: 1),
        CommitLeader(name: '대리님', commitCount: 250, rank: 2),
        CommitLeader(name: '주임님', commitCount: 200, rank: 3),
      ],
      myMonitoringGroup: '',
      myMonitoringGroupDescription: '',
      myRank: 0,
      myName: '',
    );
  }

  /// “M월 d일” 포맷
  String get formattedDate =>
      DateFormat('M월 d일').format(selectedDate.value);

  /// 이전/다음 날짜 (추후 fetchRanking 재호출 가능)
  void decrementDate() {
    selectedDate.value =
        selectedDate.value.subtract(const Duration(days: 1));
    // fetchRanking();
  }

  void incrementDate() {
    selectedDate.value =
        selectedDate.value.add(const Duration(days: 1));
    // fetchRanking();
  }

  /// Duration → “HH:mm:ss” 로 변환
  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final h = d.inHours;
    final m = twoDigits(d.inMinutes.remainder(60));
    final s = twoDigits(d.inSeconds.remainder(60));
    return '$h:$m:$s';
  }
}
