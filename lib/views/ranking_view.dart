import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/ranking_controller.dart';
import '../views/widgets/bottom_nav.dart';
import '../models/ranking.dart';

class RankingView extends GetView<RankingController> {
  const RankingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              _buildHeader(),           // 뒤로가기 포함 헤더
              const SizedBox(height: 12),
              _buildDateControls(),
              const SizedBox(height: 12),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: _buildRankingCard(
                        "공부시간",
                        controller.ranking.value.durationLeaders,
                        true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _buildRankingCard(
                        "커밋횟수",
                        controller.ranking.value.commitLeaders,
                        false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        Expanded(
          child: Center(
            child: Obx(() {
              final group = controller.ranking.value.myMonitoringGroup;
              return Text(
                '$group 랭킹',
                style: GoogleFonts.audiowide(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 48), // 뒤로가기 아이콘 크기만큼 공간 확보
      ],
    );
  }

  Widget _buildDateControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: controller.decrementDate,
        ),
        Obx(
          () => Text(
            controller.formattedDate,
            style: GoogleFonts.audiowide(fontSize: 16),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: controller.incrementDate,
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(2, 2)),
            ],
          ),
          child: Row(
            children: const [
              Text('일간', style: TextStyle(fontWeight: FontWeight.bold)),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRankingCard(String title, List<dynamic> leaders, bool isDuration) {
    final maxValue = isDuration
        ? (leaders as List<DurationLeader>)
            .map((e) => e.duration.inSeconds)
            .fold<int>(0, (prev, curr) => curr > prev ? curr : prev)
        : (leaders as List<CommitLeader>)
            .map((e) => e.commitCount)
            .fold<int>(0, (prev, curr) => curr > prev ? curr : prev);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x22000000), blurRadius: 10, offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.audiowide(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: leaders.take(3).map((leader) {
                final name = isDuration
                    ? (leader as DurationLeader).name
                    : (leader as CommitLeader).name;
                final value = isDuration
                    ? (leader as DurationLeader).duration.inSeconds
                    : (leader as CommitLeader).commitCount;
                final displayValue = isDuration
                    ? controller.formatDuration(Duration(seconds: value))
                    : '$value번';
                final isTop = leader.rank == 1;

                return Row(
                  children: [
                    Text('${leader.rank}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: maxValue == 0 ? 0 : value / maxValue,
                              minHeight: 8,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isTop ? const Color(0xffff8126) : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(displayValue, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
