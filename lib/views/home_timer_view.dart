import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeTimerView extends GetView<HomeController> {
  const HomeTimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("타이머"),
    );
  }
}
