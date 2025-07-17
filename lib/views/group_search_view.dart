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



  Widget _buildGroupCard(Group group) {
    return GestureDetector(
      onTap: () => controller.showGroupDetailDialog(Get.context!, group.id), // ← 여기만 바뀜
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
