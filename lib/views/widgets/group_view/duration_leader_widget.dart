import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../models/ranking.dart';
import '../../../models/repo.dart';


Widget buildDurationLeaderItem(DurationLeader leader, Duration maxDuration) {
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
                      formatDuration(leader.duration),
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

String formatDuration(Duration d) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(d.inHours);
  final minutes = twoDigits(d.inMinutes.remainder(60));
  final seconds = twoDigits(d.inSeconds.remainder(60));
  return "$hours:$minutes:$seconds";
}