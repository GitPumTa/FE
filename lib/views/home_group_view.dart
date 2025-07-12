import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../controllers/home_controller.dart';
import '../models/ranking.dart';
import '../models/repo.dart';

class HomeGroupView extends GetView<HomeController> {
  const HomeGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          final groupName = controller.ranking.value.myMonitoringGroup;
          final groupDescription =
              controller.ranking.value.myMonitoringGroupDescription;

          return Container(
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
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  "$rank등 입니다",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '공부시간',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 30),
                ...leaders
                    .take(3)
                    .map((leader) => buildRankingItem(leader, maxDuration))
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
    );
  }

  Widget buildRankingItem(DurationLeader leader, Duration maxDuration) {
    final bool isRunning = leader.status == TimerStatus.running;
    final double ratio = leader.duration.inSeconds / maxDuration.inSeconds;

    // 메달 아이콘 매핑
    IconData medalIcon;
    switch (leader.rank) {
      case 1:
        medalIcon = HugeIcons.strokeRoundedMedalFirstPlace;
        break;
      case 2:
        medalIcon = HugeIcons.strokeRoundedMedalSecondPlace;
        break;
      case 3:
        medalIcon = HugeIcons.strokeRoundedMedalThirdPlace;
        break;
      default:
        medalIcon = Icons.error;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(medalIcon, size: 30),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          leader.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        controller.formatDuration(leader.duration),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isRunning ? Color(0xffFF8126) : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final barWidth =
                          constraints.maxWidth * ratio.clamp(0.0, 1.0);
                      return Stack(
                        children: [
                          Container(
                            width: constraints.maxWidth,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Container(
                            width: barWidth,
                            height: 6,
                            decoration: BoxDecoration(
                              color:
                                  isRunning ? Color(0xffFF8126) : Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
      ],
    );
  }

  Widget buildCommitLeaderItem({
    required CommitLeader leader,
    required IconData medalIcon,
    required int maxCommitCount,
  }) {
    final double ratio = leader.commitCount / maxCommitCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🥇 메달 아이콘
            Icon(medalIcon, size: 30), // 예: HugeIcons.strokeRoundedMedal01
            SizedBox(width: 30),

            // 📊 이름, 커밋 수, 프로그래스바
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          leader.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        '${leader.commitCount}개',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final barWidth =
                          constraints.maxWidth * ratio.clamp(0.0, 1.0);
                      return Stack(
                        children: [
                          Container(
                            width: constraints.maxWidth,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Container(
                            width: barWidth,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Color(0xffFF8126), // 항상 주황색
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
