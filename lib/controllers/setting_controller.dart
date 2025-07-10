import 'package:get/get.dart';
import 'package:gitpumta/controllers/auth_controller.dart';
import 'package:gitpumta/routes/app_route.dart';

class SettingController extends GetxController {

  final AuthController authController = Get.find<AuthController>();

  Future<void> logout() async {
    await authController.logout();
    Get.offAllNamed(AppRoutes.login);
  }
}