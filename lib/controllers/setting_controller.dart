import 'package:get/get.dart';
import 'package:gitpumta/controllers/auth_controller.dart';
import 'package:gitpumta/routes/app_route.dart';

class SettingController extends GetxController {

  final AuthController authController = Get.find<AuthController>();

  RxString username = "".obs;
  RxList<int> weeklyCommits = List.filled(7, 0).obs;

  Future<void> fetchMockUserData() async {
    await Future.delayed(Duration(seconds: 1));
    username.value = 'hoho';
    weeklyCommits.value = [2,3,4,5,6,3,2];
  }

  Future<void> logout() async {
    await authController.logout();
    Get.offAllNamed(AppRoutes.login);
  }
}