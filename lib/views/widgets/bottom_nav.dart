import 'package:flutter/material.dart';
import 'package:gitpumta/routes/app_route.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:get/get.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: 0,
      onTap: (index) {
        switch (index) {
          case 0:
            Get.offAllNamed(AppRoutes.home);
            break;
          case 1:
            Get.offAllNamed(AppRoutes.group);
            break;
          case 2:
            Get.offAllNamed(AppRoutes.settings);
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(HugeIcons.strokeRoundedHome09),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(HugeIcons.strokeRoundedUserMultiple),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(HugeIcons.strokeRoundedSettings01),
          label: '',
        )
      ],

    );
  }
}