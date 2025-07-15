import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/ranking_controller.dart';
import '../views/widgets/bottom_nav.dart';

class RankingView extends GetView<RankingController> {
  const RankingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          '현장프로젝트 2팀 랭킹',
          style: GoogleFonts.audiowide(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildDateSelector(),
            const SizedBox(height: 20),
            _buildRankingCard('공부시간', controller.ranking.value.durationLeaders, isDuration: true),
            const SizedBox(height: 20),
            _buildRankingCard('커밋횟수', controller.ranking.value.commitLeaders),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildDateSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.chevron_left, size: 32),
        Row(
          children: [
            Text(
              '7월 9일',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                children: const [
                  Text('일간', style: TextStyle(fontWeight: FontWeight.bold)),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            )
          ],
        ),
        Icon(Icons.chevron_right, size: 32),
      ],
    );
  }

  Widget _buildRankingCard(String title, List<dynamic> leaders, {bool isDuration = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
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
            title,
            style: GoogleFonts.audiowide(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          for (var leader in leaders.take(3))
            _buildLeaderTile(leader, isDuration),
        ],
      ),
    );
  }

  Widget _buildLeaderTile(dynamic leader, bool isDuration) {
    final index = leader.rank;
    final barColor = index == 1 ? Color(0xffff8126) : Colors.grey.shade400;
    final maxVal = isDuration
        ? controller.ranking.value.durationLeaders.first.duration.inSeconds
        : controller.ranking.value.commitLeaders.first.commitCount;
    final val = isDuration
        ? leader.duration.inSeconds.toDouble()
        : leader.commitCount.toDouble();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text('${leader.rank}', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  leader.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Stack(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: val / (maxVal == 0 ? 1 : maxVal),
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: barColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            isDuration
                ? controller.formatDuration(leader.duration)
                : '${leader.commitCount}번',
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
