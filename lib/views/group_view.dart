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
              final groupName = controller.ranking.value.myMonitoringGroup;
              final groupDescription =
                  controller.ranking.value.myMonitoringGroupDescription;

              return GestureDetector(
                onTap: () {
                  Get.dialog(
                      Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          constraints: const BoxConstraints(
                            maxHeight: 400, // 다이얼로그가 너무 커지지 않도록 제한
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xfffafafa),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.myGroup.length,
                            itemBuilder: (context, index) {
                              final group = controller.myGroup[index];
                              return GestureDetector(
                                onTap: () {
                                  Get.back();
                                  controller.selectGroup(group);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: Text(
                                    group.name, // 또는 group.title 등 적절한 필드
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Color(0xffff8126),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x20000000),
                        blurRadius: 10,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        groupName,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        groupDescription,
                        style: TextStyle(fontSize: 15, color: Colors.white),
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
