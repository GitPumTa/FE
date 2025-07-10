import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import '../routes/app_route.dart';
import '../views/widgets/bottom_nav.dart';

import '../controllers/group_controller.dart';

class GroupView extends GetView<GroupController> {
  const GroupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffafafa),
        appBar: AppBar(
          backgroundColor: Color(0xfffafafa),
          title: Text('그룹'),
          centerTitle: true,
        ),
        body: Center(
          child: Text('그룹'),
        ),
      bottomNavigationBar: BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.searchGroup),
        backgroundColor: Colors.white,
        elevation: 0,
        highlightElevation: 0,
        disabledElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Color(0xffd9d9d9), width: 2),
        ),
        focusColor: Colors.white,
        focusElevation: 0,
        hoverColor: Colors.white,
        hoverElevation: 0,
        child: Icon(HugeIcons.strokeRoundedSearch02, color: Colors.grey),
      ),
    );
  }
}