import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/group_controller.dart';

class GroupAddView extends GetView<GroupController> {
  const GroupAddView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('그룹 추가'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('그룹 추가'),
      )
    );
  }

}