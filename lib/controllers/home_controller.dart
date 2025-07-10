import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

enum TabType { timer, group }

class HomeController extends GetxController {
  Rx<TabType> selected = TabType.timer.obs;

  void toggle(TabType type) {
    selected.value = type;
  }

  Alignment get alignment {
    return selected.value == TabType.timer
        ? Alignment.centerLeft
        : Alignment.centerRight;
  }
}