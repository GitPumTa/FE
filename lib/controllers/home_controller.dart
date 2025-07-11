import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../models/repo.dart';

enum TabType { timer, group }

class HomeController extends GetxController {
  Rx<TabType> selected = TabType.timer.obs;

  RxList<Repo> repos = <Repo>[].obs;

  RxnString activeRepoId = RxnString(null);
  Timer? _timer;

  Duration get totalDuration => repos.fold(
    Duration.zero,
        (sum, r) => sum + r.duration,
  );

  final Rx<DateTime> currentTime = DateTime.now().obs;

  @override
  onInit() {
    super.onInit();
    fetchMockData();
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
    repos.value = [
      Repo(id: '1', title: 'Repo 1', subtitle: 'Sub Title 1', repoAddress: 'Address 1'),
      Repo(id: '2', title: 'Repo 2', subtitle: 'Sub Title 2', repoAddress: 'Address 2'),
    ];
  }

  void startTimerFor(String repoId) {
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

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  void stopTimer(String? repoId) {
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

  String formatDateTime(DateTime dateTime) {
    final year = dateTime.year;
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '$year.$month.$day';
  }
}