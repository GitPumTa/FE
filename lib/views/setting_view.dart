import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/setting_controller.dart';
import '../views/widgets/bottom_nav.dart';
import '../routes/app_route.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text(
              controller.username.value.isEmpty
                  ? '이름 불러오는 중...'
                  : controller.username.value,
              style: GoogleFonts.audiowide(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )),
            const SizedBox(height: 20),
            _buildCommitCard(controller),
            const SizedBox(height: 20),
            _buildSettingMenu(),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildCommitCard(SettingController controller) {
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
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '이번 주 커밋',
                style: GoogleFonts.audiowide(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 140,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const days = ['월', '화', '수', '목', '금', '토', '일'];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                days[value.toInt() % 7],
                                style: TextStyle(fontSize: 12),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: controller.weeklyCommits.value
                        .asMap()
                        .entries
                        .map(
                          (entry) => BarChartGroupData(
                            x: entry.key,
                            barRods: [
                              BarChartRodData(
                                toY: entry.value.toDouble(),
                                color: const Color(0xffff8126),
                                width: 16,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildSettingMenu() {
    return Column(
      children: [
        _buildMenuTile('문의 하기', Icons.mail_outline, () {}),
        _buildMenuTile('테마 설정', Icons.brightness_6, () {}),
        _buildMenuTile('랭킹', Icons.leaderboard, () {
          Get.toNamed(AppRoutes.ranking);
        }),
        _buildMenuTile('깃허브 계정 연동 확인', Icons.link, () {}),
        _buildMenuTile('개발자 정보', Icons.info_outline,  () {}),
      ],
    );
  }

 Widget _buildMenuTile(String title, IconData icon, VoidCallback onTap) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Color(0x22000000),
          blurRadius: 8,
          offset: Offset(2, 2),
        ),
      ],
    ),
    child: ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: GoogleFonts.audiowide(
          fontSize: 15,
          color: Colors.black,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap, // ✅ 전달된 콜백 실행
    ),
  );
}
}
