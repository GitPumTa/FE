// import 'package:get/get.dart';
//
// class GroupController extends GetxController {
//
// }
import 'package:get/get.dart';
import '../models/group.dart';

class GroupController extends GetxController {
  RxList<Group> groups = <Group>[].obs;

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
        memberStatus: '49/50명',
        isActive: true,
      ),
      ...List.generate(5, (i) {
        return Group(
          id: '${i + 2}',
          name: '테스트 그룹입니다.',
          description: '테스트 그룹입니다.',
          memberStatus: '49/50명',
        );
      }),
    ];
  }
}