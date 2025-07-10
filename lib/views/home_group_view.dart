import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeGroupView extends GetView<HomeController> {
  const HomeGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text('그룹'),
    );
  }
}
