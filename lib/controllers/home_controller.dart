import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../models/commit.dart';
import '../models/ranking.dart';
import '../models/repo.dart';

import '../services/api_service.dart';
import '../services/token_service.dart';

enum TabType { timer, group }

class HomeController extends GetxController {
  final ApiService apiService;
  final TokenService tokenService;
  HomeController({required this.apiService, required this.tokenService});

  Rx<TabType> selected = TabType.timer.obs;

  RxList<Repo> repos = <Repo>[].obs;
  RxList<Commit> commits = <Commit>[].obs;
  Rx<Ranking> ranking = Ranking.empty().obs;

  RxnString activeRepoId = RxnString(null);

  Timer? _timer;
  Timer? _rankingTimer;

  Duration get totalDuration => repos.fold(
    Duration.zero,
        (sum, r) => sum + r.duration,
  );

  final Rx<DateTime> currentTime = DateTime.now().obs;

  @override
  onInit() {
    super.onInit();
    fetchMockData();
    fetchMockRanking();
  }

  void toggle(TabType type) {
    selected.value = type;
  }

  Alignment get alignment {
    return selected.value == TabType.timer
        ? Alignment.centerLeft
        : Alignment.centerRight;
  }

  Future<void> fetchMockData() async {
    await Future.delayed(Duration(seconds: 1));
    // 내 이름으로 등록된 repo 리스트 반환, repo 동기화된 시간 수신 및 동기화.
    repos.value = [
      Repo(id: '1', title: 'Repo 1', subtitle: 'Sub Title 1', repoAddress: 'Address 1', duration: Duration(seconds: 10)),
      Repo(id: '2', title: 'Repo 2', subtitle: 'Sub Title 2', repoAddress: 'Address 2', duration: Duration(seconds: 20)),
    ];
  }


  Future <void> fetchMockCommit(Repo repo) async {
    await Future.delayed(Duration(seconds: 1));
    // repo의 git address 로 api 요청 및, commit 리스트 반환, 갯수 반환 및 타이머 실행동안 커밋 수 확인 및 리더보드 등록 요청 보내기.
    commits.value = [
      Commit(id: '1', message: 'Commit 1'),
      Commit(id: '2', message: 'Commit 2'),
    ];
  }
  Future <void> fetchMockRanking() async {
    await Future.delayed(Duration(seconds: 1));
    // 내 등수와 그룹 등수 및 그룹 리더 타이머 상태, 커밋 갯수 반환.
    // 등록한 시간, 총 흐른 시간 으로 타이머 동기화,
    ranking.value = Ranking.mock();
    _startRankingTimer();
  }

  void _startRankingTimer() {
    _rankingTimer?.cancel();
    _rankingTimer = Timer.periodic(Duration(seconds: 1), (_) {
      final now = DateTime.now();

      final updatedLeaders = ranking.value.durationLeaders.map((leader) {
        if (leader.status == TimerStatus.running) {
          final updatedDuration = leader.duration + now.difference(leader.sendAt!);
          return leader.copyWith(duration: updatedDuration, sendAt: now);
        }
        return leader;
      }).toList();

      ranking.value = ranking.value.copyWith(durationLeaders: updatedLeaders);
    });
  }

  void startTimerFor(String repoId) {
    // 완전 처음일 때, 맨 처음 시작 시간(start at)(맨 처음 시작한 시간으로 커밋 데이터 자를 예정)
    // 시작 시간(send at), total duration, 상태(start), repos 서버에 전송.
    if (_timer != null && activeRepoId.value != null) {
      final prevIndex = repos.indexWhere((r) => r.id == activeRepoId.value);
      if (prevIndex != -1) {
        repos[prevIndex] = repos[prevIndex].copyWith(status: TimerStatus.paused);
      }
      _timer!.cancel();
    }
    activeRepoId = RxnString(repoId);
    final index = repos.indexWhere((r) => r.id == repoId);
    if (index == -1) return;

    repos[index] = repos[index].copyWith(status: TimerStatus.running);
    repos.refresh();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      final i = repos.indexWhere((r) => r.id == activeRepoId.value);
      if (i != -1) {
        final updated = repos[i].copyWith(
          duration: repos[i].duration + Duration(seconds: 1),
        );
        repos[i] = updated;
        repos.refresh();
      }
    });
  }

  void pauseTimer() {
    // 일시 정지 시간(send at), total duration, 상태(pause), repos 서버에 전송.
    if (activeRepoId.value == null) return;

    final index = repos.indexWhere((r) => r.id == activeRepoId.value);
    if (index != -1) {
      repos[index] = repos[index].copyWith(status: TimerStatus.paused);
      repos.refresh();
    }

    _timer?.cancel();
    _timer = null;
  }

  void toggleTimer(Repo repo) {
    if (activeRepoId.value == repo.id) {
      if (repo.status == TimerStatus.running) {
        pauseTimer();
        return;
      }
      if (repo.status == TimerStatus.paused) {
        startTimerFor(repo.id);
        return;
      }
    } else {
      stopTimer(activeRepoId.value);
      startTimerFor(repo.id);
    }
  }

  void stopTimer(String? repoId) {
    // 종료 시간(send_at), total_duration, 상태(stop), repos 서버에 전송.
    if (repoId == null) return;
    if (activeRepoId.value == repoId) {
      _timer?.cancel();
      _timer = null;
      activeRepoId = RxnString(null);
    }
    final index = repos.indexWhere((r) => r.id == repoId);
    if (index != -1) {
      repos[index] = repos[index].copyWith(
        status: TimerStatus.stopped,
      );
      repos.refresh();
    }
  }
  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  double barPercent(DurationLeader leader) {
    final top = ranking.value.durationLeaders.first.duration.inSeconds;
    return (leader.duration.inSeconds / top).clamp(0.0, 1.0);
  }

  String formatDateTime(DateTime dateTime) {
    final year = dateTime.year;
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '$year.$month.$day';
  }
}