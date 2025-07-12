// import 'package:get/get.dart';
//
// class GroupController extends GetxController {
//
// }
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/group.dart';

class GroupController extends GetxController {
  RxList<Group> groups = <Group>[].obs;
  RxList<Group> filteredGroups = <Group>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchGroups();
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
    if (index != -1 && groups[index].currentMembers < groups[index].maxMembers) {
      final updated = groups[index].copyWith(
        currentMembers: groups[index].currentMembers + 1,
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