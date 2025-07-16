import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitpumta/views/widgets/bottom_nav.dart';
import 'package:hugeicons/hugeicons.dart';

import '../controllers/group_controller.dart';

import '../routes/app_route.dart';

import 'widgets/group_view/commit_leader_widget.dart';
import 'widgets/group_view/duration_leader_widget.dart';

class GroupView extends GetView<GroupController> {
  const GroupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfffafafa),
        elevation: 0,
        title: const Text(
          '내가 가입한 그룹',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(0xfffafafa),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Obx(() {
              //final groupName = controller.ranking.value.myMonitoringGroup;
              //final groupDescription =
              //    controller.ranking.value.myMonitoringGroupDescription;
              final groupName = controller.selectedGroup.value?.name ?? controller.ranking.value.myMonitoringGroup;
              final groupDescription = controller.selectedGroup.value?.description ?? controller.ranking.value.myMonitoringGroupDescription;

              return GestureDetector(
                onTap: () {
                  controller.searchMyGroup('');
                  controller.tempSelectedGroup.value = controller.selectedGroup.value;
                  controller.selectedGroup.value = controller.selectedGroup.value;
                  Get.dialog(
                      Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Obx(() {
                          return Container(
                            padding: const EdgeInsets.all(20),
                            constraints: const BoxConstraints(maxHeight: 500),
                            decoration: BoxDecoration(
                              color: const Color(0xfffafafa),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // 검색창
                                TextField(
                                  onChanged: controller.searchMyGroup,
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
                                  child: ListView.separated(
                                    itemCount: controller.filteredMyGroups.length,
                                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                                    itemBuilder: (_, index) {
                                      final group = controller.filteredMyGroups[index];
                                      return Obx(() {
                                        final isSelected = group.id == controller.tempSelectedGroup.value?.id;
                                        return GestureDetector(
                                          onTap: () => controller.tempSelectedGroup.value = group,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                            decoration: BoxDecoration(
                                              color: isSelected ? const Color(0xffff8126) : Colors.white,
                                              borderRadius: BorderRadius.circular(20),
                                              boxShadow: const [
                                                BoxShadow(color: Color(0x22000000), blurRadius: 6),
                                              ],
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  group.name,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: isSelected ? Colors.white : Colors.black,
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
                                                        color: isSelected ? Colors.white : Colors.grey,
                                                      ),
                                                    ),
                                                    Text(
                                                      group.memberStatus,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: isSelected ? Colors.white : Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                    },
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // 하단 버튼
                                Row(
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
                                        onPressed: () {
                                          controller.selectedGroup.value = controller.tempSelectedGroup.value;
                                          Get.back();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xffff8126),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 20),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text('선택 완료'),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }),
                      ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xffff8126),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x20000000),
                        blurRadius: 10,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        groupName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        groupDescription,
                        style: const TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            }),
            SizedBox(height: 20),
            Obx(() {
              final rank = controller.ranking.value.myRank;
              final name = controller.ranking.value.myName;
              return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x20000000),
                      blurRadius: 10,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(HugeIcons.strokeRoundedSunglasses, size: 64),
                    SizedBox(height: 10),
                    Text(
                      "$name님은 지금",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "$rank등 입니다",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        controller.fetchMockRanking();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        elevation: 0,
                        backgroundColor: const Color(0xffFF8126),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '새로 고침',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          const SizedBox(width: 10),
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedRefresh,
                            color: Colors.white,
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            SizedBox(height: 20),
            Obx(() {
              final leaders =
                  controller.ranking.value.durationLeaders.take(3).toList();
              final maxDuration = leaders
                  .map((e) => e.duration)
                  .reduce((a, b) => a > b ? a : b);
              return Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 10,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '공부시간',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 30),
                    ...leaders
                        .take(3)
                        .map(
                          (leader) =>
                              buildDurationLeaderItem(leader, maxDuration),
                        )
                        .toList(),
                  ],
                ),
              );
            }),
            SizedBox(height: 20),
            Obx(() {
              final int maxCount =
                  controller.ranking.value.commitLeaders.first.commitCount;

              return Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 10,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '커밋 횟수',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    buildCommitLeaderItem(
                      leader: controller.ranking.value.commitLeaders[0],
                      medalIcon: HugeIcons.strokeRoundedMedalFirstPlace,
                      maxCommitCount: maxCount,
                    ),
                    buildCommitLeaderItem(
                      leader: controller.ranking.value.commitLeaders[1],
                      medalIcon: HugeIcons.strokeRoundedMedalSecondPlace,
                      maxCommitCount: maxCount,
                    ),
                    buildCommitLeaderItem(
                      leader: controller.ranking.value.commitLeaders[2],
                      medalIcon: HugeIcons.strokeRoundedMedalThirdPlace,
                      maxCommitCount: maxCount,
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
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
}
