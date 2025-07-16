// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hugeicons/hugeicons.dart';
//
// import '../controllers/group_controller.dart';
// import '../routes/app_route.dart';
//
// class GroupSearchView extends GetView<GroupController> {
//   const GroupSearchView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('그룹 검색'),
//           centerTitle: true,
//         ),
//         body: Center(
//           child: Text('그룹 검색'),
//         ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => Get.toNamed(AppRoutes.newGroup),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         highlightElevation: 0,
//         disabledElevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//           side: BorderSide(color: Color(0xffd9d9d9), width: 2),
//         ),
//         focusColor: Colors.white,
//         focusElevation: 0,
//         hoverColor: Colors.white,
//         hoverElevation: 0,
//         child: Icon(HugeIcons.strokeRoundedTaskAdd01, color: Colors.grey),
//       ),
//     );
//   }
//
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../controllers/group_controller.dart';
import '../models/group.dart';
import '../routes/app_route.dart';

class GroupSearchView extends GetView<GroupController> {
  const GroupSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      appBar: AppBar(
        backgroundColor: const Color(0xfffafafa),
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Text(
              '스터디 그룹 검색',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "그룹을 검색해서\n스터디 그룹에 속해보세요.",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 검색 입력창
            TextField(
              onChanged: controller.searchGroup,
              decoration: InputDecoration(
                hintText: '그룹명을 입력하세요',
                suffixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 그룹 리스트
            Expanded(
              child: Obx(
                () => ListView.separated(
                  itemCount: controller.filteredGroups.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final group = controller.filteredGroups[index];
                    return _buildGroupCard(group);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.newGroup),
        backgroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xffd9d9d9), width: 2),
        ),
        child: const Icon(HugeIcons.strokeRoundedTaskAdd01, color: Colors.grey),
      ),
    );
  }

  void showGroupDetailDialog(BuildContext context, Group group) {
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  group.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '그룹 규칙',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 8),

                // 규칙 리스트
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        group.rules
                            .map(
                              (rule) => Text(
                                '• $rule',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            )
                            .toList(),
                  ),
                ),

                const SizedBox(height: 16),
                Text(
                  '인원 ${group.memberStatus}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),

                // 비밀번호 입력 필드
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                    hintText: '비밀번호를 입력하세요',
                    filled: true,
                    fillColor: const Color(0xFFF6F6F6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    labelStyle: const TextStyle(
                      color: Color(0xffff8126),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('취소'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: group.isActive
                            ? null  // 이미 가입한 그룹은 비활성화
                            : () {
                          final password = passwordController.text;
                          final isValid = controller.verifyGroupPassword(group, password);

                          if (isValid) {
                            if (group.currentMembers >= group.maxMembers) {
                              Get.snackbar('가입 실패', '정원이 초과된 그룹입니다',
                                  snackPosition: SnackPosition.BOTTOM);
                            } else {
                              controller.joinGroup(group);
                              Get.back();
                              Get.snackbar('가입 성공', '${group.name}에 가입되었습니다!',
                                  snackPosition: SnackPosition.BOTTOM);
                            }
                          } else {
                            Get.snackbar('오류', '비밀번호가 올바르지 않습니다',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.redAccent,
                                colorText: Colors.white);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: group.isActive ? Colors.grey.shade400 : const Color(0xffff8126),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          group.isActive ? '이미 가입한 그룹' : '그룹 가입',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGroupCard(Group group) {
    return GestureDetector(
      onTap: () => showGroupDetailDialog(Get.context!, group), // 팝업 띄우기
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 10,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              group.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  group.description,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  group.memberStatus,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
