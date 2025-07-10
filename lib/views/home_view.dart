import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitpumta/views/home_timer_view.dart';
import '../views/widgets/bottom_nav.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/home_controller.dart';
import 'home_group_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xfffafafa),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            Text('홈 화면'),
            // 탭
            Obx(() {
              return Container(
                height: 44,
                width: screenWidth - 40,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFefefef),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 10,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    AnimatedAlign(
                      alignment: controller.alignment,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: Container(
                        width: (screenWidth - 50) / 2,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        _buildTab('Timer', TabType.timer),
                        _buildTab('Group', TabType.group),
                      ],
                    ),
                  ],
                ),
              );
            }),
            SizedBox(height: 20),
            Obx(() {
              switch (controller.selected.value) {
                case TabType.timer:
                  return HomeTimerView(); // 이미 만들어둔 View
                case TabType.group:
                  return HomeGroupView(); // 이미 만들어둔 View
              }
            })
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Widget _buildTab(String label, TabType type) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => controller.toggle(type),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          child: Container(
            height: 48, // ✅ 터치 영역 확보
            alignment: Alignment.center,
            child: Obx(() {
              final selected = controller.selected.value == type;
              return Text(
                label,
                style: GoogleFonts.audiowide(
                  fontSize: 16,
                  color: selected ? Colors.black : Colors.black,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
