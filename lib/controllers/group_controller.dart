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
  Rx<Group?> selectedGroup = Rx<Group?>(null);

  void selectGroup(Group group) {
    selectedGroup.value = group;
  }

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

}