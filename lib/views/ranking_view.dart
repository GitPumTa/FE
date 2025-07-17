import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/ranking_controller.dart';
import '../models/ranking.dart';
import '../views/widgets/bottom_nav.dart';

class RankingView extends GetView<RankingController> {
  RankingView({super.key});

  // 날짜 버튼의 위치를 구하기 위한 GlobalKey
  final GlobalKey _dateKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              _buildDateControls(context),
              const SizedBox(height: 12),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: _buildRankingCard(
                        '공부시간',
                        controller.ranking.value.durationLeaders,
                        true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _buildRankingCard(
                        '커밋횟수',
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
        const Expanded(
          child: Center(
            child: Text(
              '전체 랭킹',
              style: TextStyle(
                fontFamily: 'Audiowide',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 48), // IconButton 너비만큼 여백
      ],
    );
  }

  Widget _buildDateControls(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: controller.decrementDate,
        ),
        Obx(() {
          return GestureDetector(
            key: _dateKey,
            onTap: () => _showCalendarPopup(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Text(
                controller.formattedDate,
                style: GoogleFonts.audiowide(fontSize: 16),
              ),
            ),
          );
        }),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: controller.incrementDate,
        ),
      ],
    );
  }

 void _showCalendarPopup(BuildContext context) async {
 final renderBox = _dateKey.currentContext!.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero, ancestor: overlay);

    const menuWidth = 300.0;
    final left = offset.dx + size.width / 2 - menuWidth / 2;
    final top = offset.dy + size.height;
    final position = RelativeRect.fromLTRB(
      left,
      top,
      overlay.size.width - (left + menuWidth),
      overlay.size.height - top,
    );

 await showMenu<void>(
    context: context,
    position: position,
    color: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 0,
    items: [
      PopupMenuItem<void>(
        padding: EdgeInsets.zero,
        child: Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          margin: const EdgeInsets.all(4),
          child: SizedBox(
            width: menuWidth,
            child: Theme(
              data: Theme.of(context).copyWith(
                datePickerTheme: DatePickerThemeData(
                   dayStyle: GoogleFonts.audiowide(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                   todayForegroundColor: MaterialStateProperty.all(Colors.white),
                   weekdayStyle: GoogleFonts.audiowide(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                   headerHeadlineStyle: GoogleFonts.audiowide(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                canvasColor: Colors.white,
                cardColor: Colors.white,
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: const Color(0xFFFF8126),
                      onPrimary: Colors.white,
                      background: Colors.white,
                      surface: Colors.white,
                      onSurface: Colors.black,
                    ),
              ),
              child: CalendarDatePicker(
                initialDate: controller.selectedDate.value,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                onDateChanged: (picked) {
                  controller.selectedDate.value = picked;
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
  Widget _buildRankingCard(
    String title,
    List<dynamic> leaders,
    bool isDuration,
  ) {
    final maxValue =
        isDuration
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
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  leaders.take(3).map((leader) {
                    final name =
                        isDuration
                            ? (leader as DurationLeader).name
                            : (leader as CommitLeader).name;
                    final value =
                        isDuration
                            ? (leader as DurationLeader).duration.inSeconds
                            : (leader as CommitLeader).commitCount;
                    final displayValue =
                        isDuration
                            ? controller.formatDuration(
                              Duration(seconds: value),
                            )
                            : '$value번';
                    final isTop = leader.rank == 1;

                    return Row(
                      children: [
                        Text(
                          '${leader.rank}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
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
                                    isTop
                                        ? const Color(0xffff8126)
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          displayValue,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
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
