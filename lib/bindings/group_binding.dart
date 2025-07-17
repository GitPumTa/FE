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
import 'package:gitpumta/models/group.dart';
import '../controllers/group_controller.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';

class GroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService(), fenix: true);
    Get.lazyPut<TokenService>(() => TokenService(), fenix: true);
    Get.lazyPut<GroupController>(() => GroupController(
      apiService: Get.find<ApiService>(),
      tokenService: Get.find<TokenService>(),
    ), fenix: true);
  }
}