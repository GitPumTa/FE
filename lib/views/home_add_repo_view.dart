import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeAddRepoView extends GetView<HomeController> {
  const HomeAddRepoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffafafa),
      appBar: AppBar(
        backgroundColor: Color(0xfffafafa),
        title: Text('Add Repo'),
        centerTitle: true,
      ),
    );
  }
}
