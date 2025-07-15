// import 'package:get/get.dart';
//
// class GroupController extends GetxController {
//
// }
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/group.dart';

class GroupController extends GetxController {
  // 전체 그룹 리스트 (원본)
  RxList<Group> allGroups = <Group>[].obs;

  // 사용자 가입 상태가 반영된 리스트
  RxList<Group> groups = <Group>[].obs;

  // 화면 출력용 필터링된 리스트
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
    final dummyJsonList = [
      {
        'id': '1',
        'name': '현장 프로젝트 2팀',
        'description': '테스트 그룹입니다.',
        'currentMembers': 49,
        'maxMembers': 50,
        'rules': [
          '하루 커밋 횟수 7회 이하시 강퇴',
          '랭킹 1등에게 Ing 쿠폰 제공',
        ],
        'password': '1234',
        'isActive': true,
      },
      ...List.generate(5, (i) => {
        'id': '${i + 2}',
        'name': '테스트 그룹입니다.',
        'description': '테스트 그룹입니다.',
        'currentMembers': 48,
        'maxMembers': 50,
        'rules': [
          '하루 커밋 1회 이상 필수',
          '랭킹 3등까지 혜택 제공',
        ],
        'password': '0000',
        'isActive': false,
      }),
    ];

    // 원본 전체 그룹 리스트 초기화
    allGroups.value = dummyJsonList.map((json) => Group.fromJson(json)).toList();

    // 상태 반영용 그룹 리스트 복사
    groups.value = [...allGroups];

    // 가입하지 않은 그룹만 필터링
    filteredGroups.value = allGroups.where((group) => !group.isActive).toList();
  }

  void searchGroup(String keyword) {
    final query = keyword.trim();
    filteredGroups.value = allGroups
        .where((group) =>
    !group.isActive && group.name.contains(query))
        .toList();
  }

  bool verifyGroupPassword(Group group, String inputPassword) {
    return group.password == inputPassword;
  }

  void joinGroup(Group group) {
    final index = groups.indexWhere((g) => g.id == group.id);
    final allIndex = allGroups.indexWhere((g) => g.id == group.id);

    if (index == -1 || allIndex == -1) return;

    final existing = groups[index];

    if (existing.isActive) {
      if (kDebugMode) {
        print('[ALREADY JOINED] ${existing.name}');
      }
      return;
    }

    if (existing.currentMembers < existing.maxMembers) {
      final updatedJson = existing.toJson()
        ..update('currentMembers', (value) => value + 1)
        ..update('isActive', (value) => true);

      final updated = Group.fromJson(updatedJson);
      groups[index] = updated;
      allGroups[allIndex] = updated;

      final fIndex = filteredGroups.indexWhere((g) => g.id == group.id);
      if (fIndex != -1) {
        filteredGroups.removeAt(fIndex); // 가입 후 필터 목록에서 제거
      }

      if (kDebugMode) {
        print('[JOINED] ${updated.name} | ${updated.memberStatus}');
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
    final newGroupJson = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'description': description,
      'currentMembers': 1,
      'maxMembers': maxMembers,
      'rules': rules,
      'password': password,
      'isActive': true,
    };

    final newGroup = Group.fromJson(newGroupJson);

    // 모든 리스트에 반영
    allGroups.insert(0, newGroup);
    groups.insert(0, newGroup);

    // 필터된 리스트는 다시 검색해서 갱신
    searchGroup('');
  }
}
