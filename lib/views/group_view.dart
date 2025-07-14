// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hugeicons/hugeicons.dart';
// import '../routes/app_route.dart';
// import '../views/widgets/bottom_nav.dart';
//
// import '../controllers/group_controller.dart';
//
// class GroupView extends GetView<GroupController> {
//   const GroupView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xfffafafa),
//         appBar: AppBar(
//           backgroundColor: Color(0xfffafafa),
//           title: Text('그룹'),
//           centerTitle: true,
//         ),
//         body: Center(
//           child: Text('그룹'),
//         ),
//       bottomNavigationBar: BottomNavBar(),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => Get.toNamed(AppRoutes.searchGroup),
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
//         child: Icon(HugeIcons.strokeRoundedSearch02, color: Colors.grey),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../routes/app_route.dart';
import '../views/widgets/bottom_nav.dart';
import '../controllers/group_controller.dart';
import '../models/group.dart';

class GroupView extends GetView<GroupController> {
  const GroupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),

      // 상단 AppBar
      appBar: AppBar(
        backgroundColor: const Color(0xfffafafa),
        elevation: 0,
        title: const Text(
          '내가 가입한 그룹',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      // 본문 영역
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),

        // 전체 그룹 목록 및 선택 상태를 옵저빙
        child: Obx(() {
          final joinedGroups = controller.groups.where((g) => g.isActive).toList();
          final selectedGroup = controller.selectedGroup.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 안내 텍스트
              const Text(
                "그룹을 선택해서\n모니터링하세요",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // 그룹 리스트 영역
              Expanded(
                child: Obx(() {
                  // 활성화된(가입된) 그룹 필터링
                  final joinedGroups = controller.groups.where((g) => g.isActive).toList();
                  final selectedGroup = controller.selectedGroup.value;

                  return ListView.separated(
                    itemCount: joinedGroups.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final group = joinedGroups[index];
                      final isSelected = group.id == selectedGroup?.id;

                      return GestureDetector(
                        onTap: () => controller.selectGroup(group), // 선택 처리
                        child: _buildGroupCard(group, isSelected: isSelected),
                      );
                    },
                  );
                }),
              ),
            ],
          );
        }),
      ),

      // 하단 네비게이션 바
      bottomNavigationBar: const BottomNavBar(),

      // 그룹 검색 버튼
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.searchGroup),
        backgroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xffd9d9d9), width: 2),
        ),
        child: const Icon(HugeIcons.strokeRoundedSearch02, color: Colors.grey),
      ),
    );
  }

  // 그룹 카드 UI 컴포넌트
  Widget _buildGroupCard(Group group, {required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFF8126) : Colors.white,
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
          // 그룹 이름
          Text(
            group.name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
              height: 1.3, // 라인 높이 고정
            ),
          ),
          const SizedBox(height: 5),

          // 그룹 설명과 인원 상태
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                group.description,
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected ? Colors.white : Colors.grey,
                  height: 1.3,
                ),
              ),
              Text(
                group.memberStatus,
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected ? Colors.white : Colors.grey,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}