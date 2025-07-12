// import 'package:get/get.dart';
//
// import '../controllers/group_controller.dart';
//
// class GroupBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<GroupController>(() => GroupController(), fenix: true);
//   }
//
// }
import 'package:get/get.dart';
import '../controllers/group_controller.dart';

class GroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupController(), fenix: true);
  }
}