// import 'package:get/get.dart';
//
// class GroupController extends GetxController {
//
// }
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/group.dart';
import '../models/ranking.dart';
import '../models/repo.dart';

class GroupController extends GetxController {
  RxList<Group> groups = <Group>[].obs;
  RxList<Group> filteredGroups = <Group>[].obs;
  Rx<Group?> selectedGroup = Rx<Group?>(null);
  Rx<Ranking> ranking = Ranking.empty().obs;

  Timer? _rankingTimer;

  void selectGroup(Group group) {
    selectedGroup.value = group;
  }

  @override
  void onInit() {
    super.onInit();
    fetchGroups();
    fetchMockRanking();
  }

  void fetchGroups() {
    groups.value = [
      Group(
        id: '1',
        name: '현장 프로젝트 2팀',
        description: '테스트 그룹입니다.',
        currentMembers: 49,
        maxMembers: 50,
        rules: [
          '하루 커밋 횟수 7회 이하시 강퇴',
          '랭킹 1등에게 Ing 쿠폰 제공',
        ],
        password: '1234',
        isActive: true,
      ),
      ...List.generate(5, (i) {
        return Group(
          id: '${i + 2}',
          name: '테스트 그룹입니다.',
          description: '테스트 그룹입니다.',
          currentMembers: 48,
          maxMembers: 50,
          rules: [
            '하루 커밋 1회 이상 필수',
            '랭킹 3등까지 혜택 제공',
          ],
          password: '0000',
        );
      }),
    ];

    // 기본 화면 - 그룹 전체 보이기
    filteredGroups.value = groups;
  }

  void searchGroup(String query) {
    if (query.isEmpty) {
      filteredGroups.value = groups;
    } else {
      filteredGroups.value = groups
          .where((g) =>
      g.name.contains(query) ||
          g.description.contains(query))
          .toList();
    }
  }

  // 그룹 가입 시 비밀번호 확인 로직
  bool verifyGroupPassword(Group group, String inputPassword) {
    return group.password == inputPassword;
  }

  // 그룹 가입 성공 처리 (추후 서버 요청 등 추가 가능)
  void joinGroup(Group group) {
    final index = groups.indexWhere((g) => g.id == group.id);

    if (index != -1) {
      final existing = groups[index];

      //이미 가입된 그룹이면 리턴
      if (existing.isActive) {
        if (kDebugMode) {
          print('[ALREADY JOINED] ${existing.name}');
        }
        return;
      }

      if (existing.currentMembers < existing.maxMembers) {
        final updated = existing.copyWith(
          currentMembers: existing.currentMembers + 1,
          isActive: true, //가입 상태 true로 변경
        );
        groups[index] = updated;

        // filteredGroups도 동기화
        final fIndex = filteredGroups.indexWhere((g) => g.id == group.id);
        if (fIndex != -1) {
          filteredGroups[fIndex] = updated;
        }

        if (kDebugMode) {
          print('[JOINED] ${updated.name} | ${updated.memberStatus}');
        }
      }
    }
  }

  void addGroup({
    required String name,
    required String description,
    required int maxMembers,
    required List<String> rules,
    required String password,
  }) {
    final newGroup = Group(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      maxMembers: maxMembers,
      rules: rules,
      password: password,
      currentMembers: 1,
      isActive: true,
    );

    groups.insert(0, newGroup);
    searchGroup(''); // 검색어 초기화 → 전체 리스트 재필터링
  }

  Future<void> fetchMockRanking() async {
    await Future.delayed(Duration(seconds: 1));
    // 내 등수와 그룹 등수 및 그룹 리더 타이머 상태, 커밋 갯수 반환, 그룹 드롭 다운 선택, 그룹 설명 반환.
    // 등록한 시간, 총 흐른 시간 으로 타이머 동기화,
    ranking.value = Ranking(
      durationLeaders: [
        DurationLeader(
          name: 'John',
          duration: Duration(seconds: 3600),
          rank: 1,
          status: TimerStatus.running,
          sendAt: DateTime(2025, 7, 14, 12, 50, 0),
        ),
        DurationLeader(
          name: 'Jane',
          duration: Duration(seconds: 3400),
          rank: 2,
          status: TimerStatus.running,
          sendAt: DateTime(2025, 7, 14, 12, 50, 0),
        ),
        DurationLeader(
          name: 'Bob',
          duration: Duration(seconds: 3200),
          rank: 3,
          status: TimerStatus.stopped,
          sendAt: DateTime(2025, 7, 14, 12, 50, 0),
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
    _startRankingTimer();
  }

  void _startRankingTimer() {
    _rankingTimer?.cancel();
    _rankingTimer = Timer.periodic(Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final updatedLeaders =
      ranking.value.durationLeaders.map((leader) {
        if (leader.status == TimerStatus.running) {
          final updatedDuration =
              leader.duration + now.difference(leader.sendAt!);
          return leader.copyWith(duration: updatedDuration, sendAt: now);
        }
        return leader;
      }).toList();

      ranking.value = ranking.value.copyWith(durationLeaders: updatedLeaders);
    });
  }

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

}