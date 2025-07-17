import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitpumta/services/api_service.dart';
import '../models/group.dart';
import '../models/ranking.dart';
import '../models/repo.dart';
import '../services/group_service.dart';
import '../services/token_service.dart';

class GroupController extends GetxController {
  final GroupService groupService = GroupService();
  final ApiService apiService;
  final TokenService tokenService;
  GroupController({required this.apiService, required this.tokenService});

  // 전체 그룹 리스트 (원본)
  RxList<Group> allGroups = <Group>[].obs;

  // 사용자 가입 상태가 반영된 리스트
  RxList<Group> groups = <Group>[].obs;

  // 화면 출력용 필터링된 리스트
  RxList<Group> filteredGroups = <Group>[].obs;

  Rx<Group?> selectedGroup = Rx<Group?>(null); // 실제 선택된 그룹
  Rx<Group?> tempSelectedGroup = Rx<Group?>(null); // 팝업 내 임시 선택 그룹

  RxList<Group> myGroup = <Group>[].obs;

  Rx<Ranking> ranking = Ranking.empty().obs;

  RxString searchText = ''.obs;
  RxList<Group> filteredMyGroups = <Group>[].obs;

  Timer? _rankingTimer;

  void selectGroup(Group group) {
    selectedGroup.value = group;
  }

  @override
  void onInit() {
    super.onInit();
    fetchMyGroup().then((_) {
      fetchGroups();
      if (selectedGroup.value != null) {
        fetchGroupRanking();
      }
    });
  }

  Future<void> fetchGroups() async {
    try {
      final token = await tokenService.getToken();
      final userId = token.username;

      final groupsFromApi = await groupService.fetchGroups(userId);

      final updated = groupsFromApi.map((group) => group.copyWith(isActive: false)).toList();
      allGroups.value = updated;
      groups.value = [...updated];

      final myGroupIds = myGroup.map((g) => g.id).toSet();
      filteredGroups.value = updated.where((g) => !myGroupIds.contains(g.id)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching groups: $e');
      }
    }
  }


  Future<void> fetchMyGroup() async {
    try {
      final token = await tokenService.getToken();
      final userId = token.username;
      final myGroups = await groupService.fetchMyGroups(userId);

      myGroup.value = myGroups;
      searchMyGroup('');

      //선택 그룹 기본값 설정
      if (myGroups.isNotEmpty) {
        selectedGroup.value = myGroups.first;
        fetchGroupRanking(); // 선택된 그룹 기준 랭킹 불러오기
      }

    } catch (e) {
      if (kDebugMode) {
        print('Error fetching my groups: $e');
      }
    }
  }



  void searchGroup(String keyword) {
    final query = keyword.trim().toLowerCase();

    final myGroupIds = myGroup.map((g) => g.id).toSet(); // 내 그룹 ID 집합 생성

    filteredGroups.value = allGroups
        .where((group) =>
    group.name.toLowerCase().contains(query) &&
        !myGroupIds.contains(group.id)) // 내가 가입한 그룹은 제외
        .toList();
  }



  void searchMyGroup(String keyword) {
    searchText.value = keyword;
    final query = keyword.trim().toLowerCase(); // 소문자로 변환

    filteredMyGroups.value = myGroup
        .where((group) => group.name.toLowerCase().contains(query)) // 소문자 기준 비교
        .toList();
  }


  bool verifyGroupPassword(Group group, String inputPassword) {
    return group.password == inputPassword;
  }

  Future<void> joinGroup(Group group, String password) async {
    try {
      final token = await tokenService.getToken();
      final userId = token.username;

      if (kDebugMode) {
        print('[JOIN REQUEST] groupId=${group.id}, userId=$userId, password=$password');
      }

      final result = await groupService.joinGroup(
        groupId: group.id,
        userId: userId,
        password: password,
      );

      if (kDebugMode) {
        print('[JOIN RESULT] $result');
      }

      if (result['success'] == true) {
        final updated = group.copyWith(
          currentMembers: group.currentMembers + 1,
          isActive: true,
        );

        final index = allGroups.indexWhere((g) => g.id == group.id);
        if (index != -1) {
          allGroups[index] = updated;
          groups[index] = updated;
        }

        myGroup.add(updated);
        searchMyGroup(searchText.value);
        Get.back();

        Get.snackbar('가입 성공', result['message'],
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('가입 실패', result['message'],
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      if (kDebugMode) {
        print('[JOIN ERROR] $e');
      }
      Get.snackbar('오류', '서버에 연결할 수 없습니다.',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }



  Future<void> addGroup({
    required String name,
    required String description,
    required int maxMembers,
    required List<String> rules,
    required String password,
  }) async {
    try {
      final token = await tokenService.getToken();
      final userId = token.username;

      final newGroup = await groupService.addGroup(
        userId: userId,
        name: name,
        description: description,
        maxMembers: maxMembers,
        rules: rules,
        password: password,
      );

      if (newGroup != null) {
        allGroups.insert(0, newGroup);
        groups.insert(0, newGroup);
        myGroup.insert(0, newGroup);
        searchMyGroup(searchText.value);
        selectedGroup.value = newGroup;

        Get.snackbar('그룹 생성 완료', '그룹이 생성되었습니다.',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('그룹 생성 실패', '서버 응답 오류',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('오류', '그룹 생성 중 문제가 발생했습니다',
          backgroundColor: Colors.red, colorText: Colors.white);
      if (kDebugMode) {
        print('[ADD GROUP ERROR] $e');
      }
    }
  }


  // Future<void> fetchMockRanking() async {
  //   await Future.delayed(Duration(seconds: 1));
  //   // 내 등수와 그룹 등수 및 그룹 리더 타이머 상태, 커밋 갯수 반환, 그룹 드롭 다운 선택, 그룹 설명 반환.
  //   // 등록한 시간, 총 흐른 시간 으로 타이머 동기화,
  //   ranking.value = Ranking(
  //     durationLeaders: [
  //       DurationLeader(
  //         name: 'John',
  //         duration: Duration(seconds: 3600),
  //         rank: 1,
  //         status: TimerStatus.running,
  //         sendAt: DateTime(2025, 7, 14, 12, 50, 0),
  //       ),
  //       DurationLeader(
  //         name: 'Jane',
  //         duration: Duration(seconds: 3400),
  //         rank: 2,
  //         status: TimerStatus.running,
  //         sendAt: DateTime(2025, 7, 14, 12, 50, 0),
  //       ),
  //       DurationLeader(
  //         name: 'Bob',
  //         duration: Duration(seconds: 3200),
  //         rank: 3,
  //         status: TimerStatus.stopped,
  //         sendAt: DateTime(2025, 7, 14, 12, 50, 0),
  //       ),
  //     ],
  //     commitLeaders: [
  //       CommitLeader(name: 'John', commitCount: 10, rank: 1),
  //       CommitLeader(name: 'Jane', commitCount: 8, rank: 2),
  //       CommitLeader(name: 'Bob', commitCount: 6, rank: 3),
  //     ],
  //     myMonitoringGroup: 'Group A',
  //     myMonitoringGroupDescription: 'Description of Group A',
  //     myRank: 5,
  //     myName: 'Alice',
  //   );
  //   _startRankingTimer();
  // }

  Future<void> fetchGroupRanking() async {
    try {
      final token = await tokenService.getToken();
      final userId = token.username;
      final groupId = selectedGroup.value?.id;

      print('>>> [RANKING] selectedGroup: ${selectedGroup.value}');
      print('>>> [RANKING] groupId: $groupId');
      print('>>> [RANKING] userId: $userId');

      if (groupId == null) {
        Get.snackbar('오류', '선택된 그룹이 없습니다');
        return;
      }

      final rankingData = await groupService.fetchGroupRanking(
        accountId: userId,
        groupId: groupId,
      );

      print('>>> [RANKING] 결과: $rankingData');

      ranking.value = rankingData;
      _startRankingTimer();
    } catch (e) {
      if (kDebugMode) {
        print('[fetchGroupRanking ERROR] $e');
      }
      Get.snackbar('오류', '랭킹 데이터를 불러오는 데 실패했습니다.');
    }
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
