import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../controllers/group_controller.dart';
import '../routes/app_route.dart';

class GroupSearchView extends GetView<GroupController> {
  const GroupSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('그룹 검색'),
          centerTitle: true,
        ),
        body: Center(
          child: Text('그룹 검색'),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.newGroup),
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
        child: Icon(HugeIcons.strokeRoundedTaskAdd01, color: Colors.grey),
      ),
    );
  }

}