import 'package:flutter/material.dart';
import '../../models/ranking.dart';

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