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

class GroupView extends GetView<GroupController> {
  const GroupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 설명 + 카드
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(0),
                child: Obx(() => ListView.separated(
                  itemCount: controller.groups.length + 1,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const Text(
                        "그룹을 선택해서\n모니터링하세요",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }

                    final group = controller.groups[index - 1];
                    return _buildGroupCard(group);
                  },
                )),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.searchGroup),
        backgroundColor: Colors.white,
        elevation: 0,
        highlightElevation: 0,
        disabledElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xffd9d9d9), width: 2),
        ),
        focusColor: Colors.white,
        focusElevation: 0,
        hoverColor: Colors.white,
        hoverElevation: 0,
        child: const Icon(HugeIcons.strokeRoundedSearch02, color: Colors.grey),
      ),
    );
  }

  Widget _buildGroupCard(group) {
    final isActive = group.isActive;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFFF8126) : Colors.white,
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
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                group.description,
                style: TextStyle(
                  fontSize: 14,
                  color: isActive ? Colors.white : Colors.grey,
                ),
              ),
              Text(
                group.memberStatus,
                style: TextStyle(
                  fontSize: 14,
                  color: isActive ? Colors.white : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}